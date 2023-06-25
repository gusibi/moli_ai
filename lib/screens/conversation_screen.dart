import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:moli_ai/services/palm_api_service.dart';
import 'package:moli_ai/utils/icon.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../models/config_model.dart';
import '../models/conversation_model.dart';
import '../providers/palm_priovider.dart';
import '../repositories/configretion/config_repo.dart';
import '../repositories/conversation/conversation.dart';
import '../repositories/conversation/conversation_message.dart';
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

  late final _backgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);

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
          desc: "desc",
          icon: currentConversation.icon,
          modelName: widget.conversationData.modelName,
          rank: 0,
          lastTime: 0);
      print("cnv $cnv");
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
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        automaticallyImplyLeading: false,
        backgroundColor: _colorScheme.primary,
        shadowColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: _colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  child: Icon(convertCodeToIconData(currentConversation.icon)),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        currentConversation.title,
                        style: TextStyle(
                            color: _colorScheme.onPrimary, fontSize: 14),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        currentConversation.desc,
                        style: TextStyle(
                            color: _colorScheme.onSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _navigateToConversationSettingScreen();
                  },
                  icon: const Icon(Icons.settings),
                  color: _colorScheme.onSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => _hideKeyboard(context),
        child: Container(
          color: _backgroundColor,
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
                    const SpinKitThreeBounce(
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                  const SizedBox(height: 15),
                  // ChatInputFormWidget(),
                  PromptMessageInputFormWidget(
                      textController: textEditingController,
                      onPressed: () {
                        if (_isTyping) {
                          log("asking");
                        } else {
                          _hideKeyboard(context);
                          sendMessageFCT(context);
                        }
                      }),
                ],
              )),
        ),
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

  Future<void> sendMessageFCT(BuildContext context) async {
    String text = textEditingController.text;
    ConversationMessageModel userMessage = await ConversationMessageRepo()
        .createUserMessage(text, currentConversation.id);
    setState(() {
      messageList.add(userMessage);
      _isTyping = true;
      textEditingController.clear();
    });
    try {
      String prompt = currentConversation.prompt;
      prompt = "$prompt:{$text}";
      final response = await PalmApiService.getTextReponse(context, prompt);
      if (response != null) {
        ConversationMessageModel aiMessage = await ConversationMessageRepo()
            .createMessageWithRole(response[0].chatRole, response[0].msg,
                currentConversation.id, userMessage.id);
        setState(() {
          messageList.add(aiMessage);
        });
      } else {}
    } catch (error) {
      log("error $error");
    } finally {
      setState(() {
        _isTyping = false;
      });
    }
  }
}
