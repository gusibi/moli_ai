import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/conversation_model.dart';
import '../providers/palm_priovider.dart';
import '../repositories/conversation/conversation.dart';
import '../utils/time.dart';
import '../widgets/form_widget.dart';

class ChatSettingScreen extends StatefulWidget {
  const ChatSettingScreen({
    super.key,
    required this.conversationData,
  });

  final ConversationModel conversationData;

  @override
  State<ChatSettingScreen> createState() => _ChatSettingScreenState();
}

class _ChatSettingScreenState extends State<ChatSettingScreen> {
  late final _colorScheme = Theme.of(context).colorScheme;
  late final _backgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);

  final _formKey = GlobalKey<FormState>();

  void _hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  Widget build(BuildContext context) {
    final palmProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    var chatInfo = widget.conversationData;

    List<Widget> formList = [
      const ChatTitleFormWidget(),
      const ChatPromptFormWidget(),
      // const ModelsDropdownFormWidget()
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          chatInfo.title,
          style: TextStyle(color: _colorScheme.onSecondary),
        ),
        centerTitle: true,
        backgroundColor: _colorScheme.primary,
        shadowColor: Colors.white,
        elevation: 4,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: _colorScheme.onPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
        onTap: () => _hideKeyboard(context),
        child: Container(
          color: _backgroundColor,
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 8),
              ...List.generate(
                formList.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: formList[index],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      String newTitle = palmProvider.getCurrentChatTitle;
                      String newPrompt = palmProvider.getCurrentChatPrompt;
                      log("prompt: $newPrompt, title: $newTitle");
                      chatInfo.title = newTitle;
                      chatInfo.prompt = newPrompt;
                      palmProvider.setCurrentChatInfo(chatInfo);
                      ConversationModel conv = ConversationModel(
                          id: chatInfo.id,
                          title: newTitle,
                          prompt: newPrompt,
                          icon: chatInfo.icon,
                          desc: chatInfo.desc,
                          modelName: chatInfo.modelName,
                          rank: 0,
                          lastTime: timestampNow());
                      ConversationReop().updateConversation(conv);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
