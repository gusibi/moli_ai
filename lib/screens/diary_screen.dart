import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sprintf/sprintf.dart';

import 'package:moli_ai/constants/constants.dart';
import 'package:moli_ai/providers/diary_privider.dart';
import 'package:provider/provider.dart';

import '../models/config_model.dart';
import '../models/conversation_model.dart';
import '../models/palm_text_model.dart';
import '../providers/palm_priovider.dart';
import '../repositories/configretion/config_repo.dart';
import '../repositories/conversation/conversation.dart';
import '../repositories/conversation/conversation_message.dart';
import '../services/palm_api_service.dart';
import '../utils/color.dart';
import '../widgets/conversation_widget.dart';
import '../widgets/form/form_widget.dart';

class DiaryScreen extends StatefulWidget {
  final ConversationModel diaryData;

  const DiaryScreen({
    super.key,
    required this.diaryData,
  });

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  late TextEditingController textEditingController;
  final _scrollController = ScrollController();
  late ConversationModel currentDiary;
  late String currentDay = '${DateTime.now().day}';
  List<ConversationMessageModel> messageList = [];
  bool _isTyping = false;

  void _queryConversationMessages() async {
    messageList =
        await ConversationMessageRepo().getMessages(currentDiary.id, 0);
    setState(() {
      messageList = messageList;
    });
  }

  void _initDefaultConfig() async {
    final palmProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    var configMap = await ConfigReop().getAllConfigsMap();
    ConfigModel? conf = configMap[palmConfigname];

    if (conf != null) {
      final palmConfig = conf.toPalmConfig();
      palmProvider.setBaseURL(palmConfig.basicUrl);
      palmProvider.setApiKey(palmConfig.apiKey);
      palmProvider.setCurrentModel(palmConfig.modelName);
    }
  }

  Future<void> _initDiary() async {
    setState(() {
      currentDiary = widget.diaryData.copy();
    });
    final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
    if (currentDiary.id == 0) {
      final title =
          '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
      // get diary by title
      ConversationModel? cnv =
          await ConversationReop().getConversationById(currentDiary.id);
      if (cnv == null) {
        // create new
        ConversationModel cnv = newDiaryConversation;
        log("cnv $cnv");
        cnv.title = title;
        int id = await ConversationReop().createConversation(cnv);
        cnv.id = id;
        currentDiary = cnv;
      } else {
        currentDiary = cnv;
      }
      diaryProvider.setCurrentDiaryInfo(currentDiary);
    } else {
      ConversationModel? cnv =
          await ConversationReop().getConversationById(currentDiary.id);
      if (cnv != null) {
        currentDiary = cnv;
      }
    }
    setState(() {
      currentDiary = currentDiary;
      List<String> dateList = currentDiary.title.split('-');
      currentDay = dateList[2];
    });
  }

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
    _initDiary();
    _queryConversationMessages();
    _initDefaultConfig();
  }

  void _hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  Widget build(BuildContext context) {
    late final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        automaticallyImplyLeading: false,
        title: const Text("Diary"),
        // backgroundColor: colorScheme.primary,
        shadowColor: getShadowColor(colorScheme),
        flexibleSpace: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  // color: colorScheme.onPrimary,
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              CircleAvatar(
                child: Text(currentDay),
              ),
              const SizedBox(
                width: 12,
              ),
              const Expanded(
                child: Column(children: []),
              ),
              IconButton(
                onPressed: () {
                  summaryDaily(context);
                },
                icon: const Icon(Icons.functions),
                // color: colorScheme.onSecondary,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings),
                // color: colorScheme.onSecondary,
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
          onTap: () => _hideKeyboard(context),
          child: Align(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: messageList.length,
                    itemBuilder: (context, index) {
                      return ConversationMessageWidget(
                          conversation: messageList[index]);
                    },
                  ),
                ),
                PromptMessageInputFormWidget(
                    textController: textEditingController,
                    leftOnPressed: () {
                      resetDiaryMessage(context);
                      _hideKeyboard(context);
                    },
                    sendOnPressed: () {
                      if (_isTyping) {
                        log("asking");
                      } else {
                        saveNoteMessage(context);
                        _hideKeyboard(context);
                      }
                    }),
              ],
            ),
          )),
    );
  }

  Future<List<String>> sendMessageByTextApi(
      String diaryMessage, ConversationModel currentConversation) async {
    final palmSettingProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    String prompt = sprintf(diaryPrompt, [diaryMessage]);
    PalmTextMessageReq req = PalmTextMessageReq(
      prompt: prompt,
      modelName: currentConversation.modelName,
      basicUrl: palmSettingProvider.getBaseURL,
      apiKey: palmSettingProvider.getApiKey,
      temperature: 0.7,
      maxOutputTokens: 4092,
    );
    final response = await PalmApiService.getTextReponse(req);
    var chatRole = roleAI;
    var message = "";
    if (response.error != null && response.error!.code != 0) {
      chatRole = roleSys;
      message = response.error!.message;
    } else if (response.candidates!.isNotEmpty) {
      message = response.candidates![0].output!;
    }
    return [chatRole, message];
  }

  Future<void> summaryDaily(BuildContext context) async {
    // get diary message
    try {
      List<ConversationMessageModel> _messageList =
          await ConversationMessageRepo().getMessages(currentDiary.id, 0);
      var message = '';
      for (var i = 0; i < _messageList.length; i++) {
        if (_messageList[i].role == roleAI) {
          continue;
        }
        if (_messageList[i].role == roleSys) {
          if (_messageList[i].message == "diary reset") {
            message = "";
          }
          continue;
        }
        message += "${_messageList[i].message}\n";
      }
      List<String> result;
      var chatRole = roleAI;
      result = await sendMessageByTextApi(message, currentDiary);
      chatRole = result[0];
      message = result[1];
      ConversationMessageModel aiMessage = await ConversationMessageRepo()
          .createMessageWithRole(chatRole, message, currentDiary.id, 0);
      setState(() {
        messageList.add(aiMessage);
        _isTyping = false;
      });
    } catch (error) {
      log("error $error");
    } finally {
      setState(() {
        _isTyping = false;
      });
    }
  }

  Future<void> saveNoteMessage(BuildContext context) async {
    String text = textEditingController.text;
    String trimmedText = text.trimRight();
    ConversationMessageModel userMessage = await ConversationMessageRepo()
        .createUserMessage(trimmedText, currentDiary.id);
    setState(() {
      messageList.add(userMessage);
      _isTyping = false;
      textEditingController.clear();
    });
  }

  Future<void> resetDiaryMessage(BuildContext context) async {
    ConversationMessageModel sysMessage = await ConversationMessageRepo()
        .createSysMessage("diary reset", currentDiary.id);
    setState(() {
      messageList.add(sysMessage);
      _isTyping = false;
      textEditingController.clear();
    });
  }
}
