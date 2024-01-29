import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:moli_ai/data/datasources/sqlite_chat_message_source.dart';
import 'package:moli_ai/data/datasources/sqlite_chat_source.dart';
import 'package:moli_ai/data/models/error_resp.dart';
import 'package:moli_ai/data/repositories/chat/chat_message_repo_impl.dart';
import 'package:moli_ai/data/repositories/chat/chat_repo_impl.dart';
import 'package:moli_ai/data/repositories/configretion/config_repo_impl.dart';
import 'package:moli_ai/domain/dto/ai_service_dto.dart';
import 'package:moli_ai/domain/dto/azure_openai_dto.dart';
import 'package:moli_ai/data/providers/conversation_privider.dart';
import 'package:moli_ai/data/services/azure_openai_service.dart';

import 'package:moli_ai/data/services/palm_api_service.dart';
import 'package:moli_ai/domain/entities/constants.dart';
import 'package:moli_ai/domain/entities/conversation_entity.dart';
import 'package:moli_ai/domain/inputs/chat_completion_input.dart';
import 'package:moli_ai/domain/inputs/chat_info_input.dart';
import 'package:moli_ai/domain/inputs/chat_messages_input.dart';
import 'package:moli_ai/domain/outputs/ai_chat_output.dart';
import 'package:moli_ai/domain/usecases/ai_chat_completion_usecase.dart';
import 'package:moli_ai/domain/usecases/chat_create_usecase.dart';
import 'package:moli_ai/domain/usecases/chat_detail_usecase.dart';
import 'package:moli_ai/domain/usecases/chat_message_create_usecase.dart';
import 'package:moli_ai/domain/usecases/chat_messages_get_usecase.dart';
import 'package:moli_ai/presentation/widgets/chat_message_widget.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../data/models/config_model.dart';
import '../../data/models/conversation_model.dart';
import '../../domain/dto/palm_text_dto.dart';
import '../../core/providers/palm_priovider.dart';
import '../../data/datasources/sqlite_config_source.dart';
import '../widgets/appbar/conversation_appbar.dart';
import '../widgets/form/form_widget.dart';
import 'conversation_setting_screen.dart';

ConversationScreen newConversationScreen(ChatEntity chatInfo) {
  return ConversationScreen(
    createChatUseCase: ChatCreateUseCase(ChatRepoImpl(ConversationDBSource())),
    chatDetailUseCase: ChatDetailUseCase(ChatRepoImpl(ConversationDBSource())),
    chatMessagesListUseCase: GetChatMessagesUseCase(
        ChatMessageRepoImpl(ConversationMessageDBSource())),
    chatMessagesCreateUseCase: ChatMessageCreateUseCase(
        ChatMessageRepoImpl(ConversationMessageDBSource())),
    aiChatCompletionUseCase:
        AiChatCompletionUseCase(ConfigRepoImpl(ConfigDBSource())),
    chatInfo: chatInfo,
  );
}

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({
    super.key,
    required this.chatInfo,
    required ChatCreateUseCase createChatUseCase,
    required ChatDetailUseCase chatDetailUseCase,
    required GetChatMessagesUseCase chatMessagesListUseCase,
    required ChatMessageCreateUseCase chatMessagesCreateUseCase,
    required AiChatCompletionUseCase aiChatCompletionUseCase,
  })  : _createChatUseCase = createChatUseCase,
        _chatDetailUseCase = chatDetailUseCase,
        _chatMessagesListUseCase = chatMessagesListUseCase,
        _chatMessagesCreateUseCase = chatMessagesCreateUseCase,
        _aiChatCompletionUseCase = aiChatCompletionUseCase;

  final ChatEntity chatInfo;
  final ChatCreateUseCase _createChatUseCase;
  final ChatDetailUseCase _chatDetailUseCase;
  final GetChatMessagesUseCase _chatMessagesListUseCase;
  final ChatMessageCreateUseCase _chatMessagesCreateUseCase;
  final AiChatCompletionUseCase _aiChatCompletionUseCase;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  bool _isTyping = false;
  List<ChatMessageEntity> messageList = [];
  late final _colorScheme = Theme.of(context).colorScheme;

  late TextEditingController textEditingController;
  late ChatEntity currentChat;
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
      currentChat = widget.chatInfo.copy();
    });
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    if (currentChat.id == 0) {
      // create new
      ChatCreateInput chatCreate = ChatCreateInput(
          title: currentChat.title,
          prompt: "prompt",
          convType: "chat",
          desc: "desc",
          icon: currentChat.icon,
          modelName: widget.chatInfo.modelName);
      // log("cnv $cnv");
      ChatEntity chatEntity = await widget._createChatUseCase.call(chatCreate);
      currentChat = chatEntity;
      chatProvider.setCurrentChatInfo(currentChat);
      chatProvider.addNewChatToList(currentChat);
    } else {
      ChatEntity? cnv = await widget._chatDetailUseCase
          .call(ChatDetailInput(chatId: currentChat.id));
      chatProvider.setCurrentModel(cnv.modelName);
      currentChat = cnv;
    }
    setState(() {
      currentChat = currentChat;
    });
  }

  void _initDefaultConfig() async {
    final palmProvider = Provider.of<AISettingProvider>(context, listen: false);
    var configMap = await ConfigDBSource().getAllConfigsMap();
    ConfigModel? conf = configMap[palmConfigname];

    if (conf != null) {
      final palmConfig = conf.toPalmConfig();
      palmProvider.setBasePalmURL(palmConfig.basicUrl);
      palmProvider.setPalmApiKey(palmConfig.apiKey);
      palmProvider.setCurrentPalmModel(palmConfig.modelName);
    }
    conf = configMap[azureConfigname];
    if (conf != null) {
      final azureConfig = conf.toAzureConfig();
      palmProvider.setAzureOpenAIConfig(azureConfig);
    }
  }

  void _queryConversationMessages() async {
    messageList = await widget._chatMessagesListUseCase.call(
        ChatMessageListInput(
            chatId: currentChat.id, pageNum: 1, pageSize: 100));
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
    late final colorScheme = Theme.of(context).colorScheme;
    late final backgroundColor = Color.alphaBlend(
        _colorScheme.primary.withOpacity(0.14), colorScheme.surface);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    final palmSettingProvider =
        Provider.of<AISettingProvider>(context, listen: false);
    return Scaffold(
      appBar: ConversationAppBarWidget(
          currentChat: currentChat,
          onPressSetting: _navigateToConversationSettingScreen),
      backgroundColor: backgroundColor,
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
                      return ChatMessageWidget(
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
                      resetConversationMessage(context);
                      _hideKeyboard(context);
                    },
                    sendOnPressed: () {
                      if (_isTyping) {
                        log("asking");
                      } else {
                        _hideKeyboard(context);
                        sendMessageByApi(
                            context,
                            palmSettingProvider.getBasePalmURL,
                            palmSettingProvider.getPalmApiKey);
                      }
                    }),
              ],
            )),
      ),
    );
  }

  Future<void> resetConversationMessage(BuildContext context) async {
    if (messageList.isNotEmpty && messageList.last.role != roleContext) {
      ChatMessageEntity sysMessage = await widget._chatMessagesCreateUseCase
          .call(ChatMessageCreateInput(
              chatId: currentChat.id, message: "上下文已清除", role: roleSys));
      setState(() {
        messageList.add(sysMessage);
        _isTyping = false;
        textEditingController.clear();
      });
    }
  }

  void _navigateToConversationSettingScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ConversationSettingScreen(conversationData: currentChat),
      ),
    );
  }

  Future<List<String>> sendMessageByTextApi(String basicUrl, apiKey,
      inputMessage, ChatModel currentConversation) async {
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
    List<PalmChatReqMessageData> messages = [];
    var count = 0;
    for (var i = messageList.length - 1; i >= 0; i--) {
      if (messageList[i].role == roleContext) {
        break;
      }
      if (messageList[i].role != roleSys) {
        count += 1;
        messages.insert(
            0,
            PalmChatReqMessageData(
                content: messageList[i].message, role: messageList[i].role));
      }
      if (count == n) {
        break;
      }
    }
    return messages;
  }

  Future<List<String>> sendMessageByChatApi(String basicUrl, apiKey,
      inputMessage, ChatModel currentConversation) async {
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

  Future<List<String>> sendMessageByAzureApi(String basicUrl, apiKey,
      inputMessage, ChatModel currentConversation) async {
    String prompt = currentConversation.prompt;
    final aiSettingProvider =
        Provider.of<AISettingProvider>(context, listen: false);
    List<PalmChatReqMessageData> contents =
        getLastNMessages(currentConversation.memeoryCount);

    List<AzureOpenAIChatReqMessageData> ms = contents.map((m) {
      var role = m.role;
      if (role == roleAI) {
        role = roleAssistant;
      }
      return AzureOpenAIChatReqMessageData(content: m.content, role: role);
    }).toList();
    AzureOpenAIMessageReq azureReq = AzureOpenAIMessageReq(
      messages: ms,
      modelName: currentConversation.modelName,
      basicUrl: basicUrl,
      apiKey: apiKey,
      temperature: 0.7,
      apiVersion: aiSettingProvider.getAuzreOpenAIConfig.apiVersion,
      maxTokens: 4096 - prompt.length,
    );
    final resp = await AzureOpenAIApiService.getChatReponse(azureReq);
    TextMessageResp response = TextMessageResp.fromAzureResp(resp);
    var chatRole = roleAI;
    var message = "";
    if (response.error != null && response.error!.code != 0) {
      chatRole = roleSys;
      message = response.error!.message;
    } else if (response.candidates!.isNotEmpty) {
      message = response.candidates![0].message!.content;
    }
    return [chatRole, message];
  }

  Future<void> sendMessageByApi(
      BuildContext context, String basicUrl, apiKey) async {
    String text = textEditingController.text;
    String trimmedText = text.trimRight();

    ChatMessageEntity userMessage = await widget._chatMessagesCreateUseCase
        .call(ChatMessageCreateInput(
            chatId: currentChat.id, message: trimmedText, role: roleUser));
    setState(() {
      messageList.add(userMessage);
      _isTyping = true;
      textEditingController.clear();
    });
    try {
      // widget._aiChatCompletionUseCase(AIChatCompletionInput(
      //     model: currentChat.modelName, messages: messages));
      // widget._aiChatCompletionUseCase(AiChatCompletionUseCase(
      //     newGoogleGeminiRepoImpl(
      //         GeminiApiConfig(apiKey: apiKey, basicUrl: basicUrl))));

      AIChatCompletionOutput result = await widget._aiChatCompletionUseCase
          .call(ChatCompletionInput(
              chatInfo: currentChat, messageList: messageList));
      // ConversationMessageModel aiMessage = await ConversationMessageRepo()
      //     .createMessageWithRole(
      //         chatRole, message, currentChat.id, userMessage.id);
      // setState(() {
      //   messageList.add(aiMessage);
      // });
      // List<String> result;
      // var chatRole = roleAI;
      // var message = "";
      // if (currentChat.modelName == palmModelsMap[PalmModels.textModel]) {
      //   result = await sendMessageByTextApi(
      //       basicUrl, apiKey, trimmedText, currentChat);
      //   chatRole = result[0];
      //   message = result[1];
      // } else if (currentChat.modelName == palmModelsMap[PalmModels.chatModel]) {
      //   result = await sendMessageByChatApi(
      //       basicUrl, apiKey, trimmedText, currentChat);
      //   chatRole = result[0];
      //   message = result[1];
      // } else if (currentChat.modelName ==
      //     palmModelsMap[PalmModels.geminiProModel]) {
      //   result = await sendMessageByGeminiApi(
      //       basicUrl, apiKey, trimmedText, currentChat);
      //   chatRole = result[0];
      //   message = result[1];
      // } else if (currentChat.modelName == azureGPT35Model.modelName) {
      //   final aiSettingProvider =
      //       Provider.of<AISettingProvider>(context, listen: false);
      //   basicUrl = aiSettingProvider.getAuzreOpenAIConfig.basicUrl;
      //   apiKey = aiSettingProvider.getAuzreOpenAIConfig.apiKey;
      //   result = await sendMessageByAzureApi(
      //       basicUrl, apiKey, trimmedText, currentChat);
      //   chatRole = result[0];
      //   message = result[1];
      // }

      // ConversationMessageModel aiMessage = await ConversationMessageRepo()
      //     .createMessageWithRole(
      //         chatRole, message, currentChat.id, userMessage.id);
      // setState(() {
      //   messageList.add(aiMessage);
      // });
    } catch (error) {
      log("error $error");
    } finally {
      setState(() {
        _isTyping = false;
      });
    }
  }
}

// Define getRole function based on your specific role logic
String getRole(ConversationMessageModel message) {
  if (message.role == roleAI) return "model";
  return roleUser;
}
