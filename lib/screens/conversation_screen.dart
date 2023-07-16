import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:moli_ai/services/palm_api_service.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../models/config_model.dart';
import '../models/conversation_model.dart';
import '../models/palm_text_model.dart';
import '../providers/palm_priovider.dart';
import '../repositories/configretion/config_repo.dart';
import '../repositories/conversation/conversation.dart';
import '../repositories/conversation/conversation_message.dart';
import '../widgets/appbar/conversation_appbar.dart';
import '../widgets/conversation_widget.dart';
import '../widgets/form/form_widget.dart';
import 'conversation_setting_screen.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({
    super.key,
    required this.conversationData,
  });

  final ConversationModel conversationData;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  bool _isTyping = false;
  List<ConversationMessageModel> messageList = [];
  late final _colorScheme = Theme.of(context).colorScheme;

  late TextEditingController textEditingController;
  late ConversationModel currentConversation;
  late int minMessageId;
  late bool allMessageloaed = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
    _initDefaultConfig();
    _initConversation();
    _queryConversationMessages();
  }

  Future<void> _initConversation() async {
    setState(() {
      currentConversation = widget.conversationData.copy();
    });
    final palmProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    if (currentConversation.id == 0) {
      // create new
      // print(palmProvider.getSqliteClient());
      ConversationModel cnv = ConversationModel(
          id: 0,
          title: currentConversation.title,
          prompt: "prompt",
          convType: "chat",
          desc: "desc",
          icon: currentConversation.icon,
          modelName: widget.conversationData.modelName,
          rank: 0,
          lastTime: 0);
      log("cnv $cnv");
      int id = await ConversationReop().createConversation(cnv);
      cnv.id = id;
      currentConversation = cnv;
      palmProvider.setCurrentConversationInfo(currentConversation);
    } else {
      ConversationModel? cnv =
          await ConversationReop().getConversationById(currentConversation.id);
      if (cnv != null) {
        palmProvider.setCurrentModel(cnv.modelName);
        currentConversation = cnv;
      }
    }
    setState(() {
      currentConversation = currentConversation;
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

  void _queryConversationMessages() async {
    messageList =
        await ConversationMessageRepo().getMessages(currentConversation.id, 0);
    if (messageList.isNotEmpty) {
      minMessageId = messageList[0].id;
      if (messageList.length < queyMessageLimit) {
        allMessageloaed = true;
      }
    } else {
      allMessageloaed = true;
    }
    setState(() {
      allMessageloaed = allMessageloaed;
      messageList = messageList;
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    _scrollController.dispose();
    _isTyping = false;
    super.dispose();
  }

  void _hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  /*这段代码的作用是将滚动条滚动到 ScrollController 的最底部位置。
  具体来说，它使用 animateTo() 方法来滚动到指定位置。
  _scrollController.position.maxScrollExtent 表示滚动条的最大位置，即最底部位置。
  duration 属性表示滚动的持续时间，这里设置为 const Duration(milliseconds: 1)，表示在 1 毫秒内完成滚动。
  curve 属性表示滚动的动画曲线，这里使用 Curves.easeOut，表示使用缓出的动画效果。
  */
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 1),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    final palmSettingProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    return Scaffold(
      appBar: ConversationAppBarWidget(
          currentConversation: currentConversation,
          onPressSetting: _navigateToConversationSettingScreen),
      body: GestureDetector(
        onTap: () => _hideKeyboard(context),
        child: Align(
            alignment: Alignment.bottomLeft,
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
                if (_isTyping) ...[
                  SpinKitThreeBounce(
                    color: _colorScheme.onBackground,
                    size: 18,
                  ),
                ],
                const SizedBox(height: 15),
                // ChatInputFormWidget(),
                PromptMessageInputFormWidget(
                    textController: textEditingController,
                    leftOnPressed: () {
                      _hideKeyboard(context);
                    },
                    sendOnPressed: () {
                      if (_isTyping) {
                        log("asking");
                      } else {
                        _hideKeyboard(context);
                        sendMessageByApi(
                            context,
                            palmSettingProvider.getBaseURL,
                            palmSettingProvider.getApiKey);
                      }
                    }),
              ],
            )),
      ),
    );
  }

  void _navigateToConversationSettingScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ConversationSettingScreen(conversationData: currentConversation),
      ),
    );
  }

  Future<List<String>> sendMessageByTextApi(String basicUrl, apiKey,
      inputMessage, ConversationModel currentConversation) async {
    String prompt = currentConversation.prompt;
    prompt = "$prompt:{$inputMessage}";
    PalmTextMessageReq req = PalmTextMessageReq(
      prompt: prompt,
      modelName: currentConversation.modelName,
      basicUrl: basicUrl,
      apiKey: apiKey,
      temperature: 0.7,
      maxOutputTokens: 1024,
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

  List<PalmChatReqMessageData> getLastNMessages(int n) {
    List<ConversationMessageModel> historyMessages = [];
    if (messageList.length <= n) {
      historyMessages = messageList;
    } else {
      historyMessages = messageList.sublist(messageList.length - n);
    }
    List<PalmChatReqMessageData> messages = [];
    for (var message in historyMessages) {
      messages.add(PalmChatReqMessageData(
        content: message.message,
      ));
    }
    return messages;
  }

  Future<List<String>> sendMessageByChatApi(String basicUrl, apiKey,
      inputMessage, ConversationModel currentConversation) async {
    String prompt = currentConversation.prompt;
    List<PalmChatReqMessageData> messages =
        getLastNMessages(currentConversation.memeoryCount);

    PalmChatMessageReq req = PalmChatMessageReq(
      context: prompt,
      modelName: currentConversation.modelName,
      basicUrl: basicUrl,
      apiKey: apiKey,
      temperature: 0.7,
      messages: messages,
      maxOutputTokens: 1024,
    );
    final response = await PalmApiService.getChatReponse(req);
    var chatRole = roleAI;
    var message = "";
    if (response.error != null && response.error!.code != 0) {
      chatRole = roleSys;
      message = response.error!.message;
    } else if (response.candidates!.isNotEmpty) {
      message = response.candidates![0].content;
    }
    return [chatRole, message];
  }

  Future<void> sendMessageByApi(
      BuildContext context, String basicUrl, apiKey) async {
    String text = textEditingController.text;
    String trimmedText = text.trimRight();
    ConversationMessageModel userMessage = await ConversationMessageRepo()
        .createUserMessage(trimmedText, currentConversation.id);
    setState(() {
      messageList.add(userMessage);
      _isTyping = true;
      textEditingController.clear();
    });
    try {
      List<String> result;
      var chatRole = roleAI;
      var message = "";
      if (currentConversation.modelName ==
          palmModelsMap[PalmModels.textModel]) {
        result = await sendMessageByTextApi(
            basicUrl, apiKey, trimmedText, currentConversation);
        chatRole = result[0];
        message = result[1];
      } else if (currentConversation.modelName ==
          palmModelsMap[PalmModels.chatModel]) {
        result = await sendMessageByChatApi(
            basicUrl, apiKey, trimmedText, currentConversation);
        chatRole = result[0];
        message = result[1];
      }

      ConversationMessageModel aiMessage = await ConversationMessageRepo()
          .createMessageWithRole(
              chatRole, message, currentConversation.id, userMessage.id);
      setState(() {
        messageList.add(aiMessage);
      });
    } catch (error) {
      log("error $error");
    } finally {
      setState(() {
        _isTyping = false;
      });
    }
  }
}
