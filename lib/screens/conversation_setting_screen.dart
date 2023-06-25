import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../models/conversation_model.dart';
import '../providers/palm_priovider.dart';
import '../repositories/conversation/conversation.dart';
import '../utils/time.dart';
import '../widgets/form/form_widget.dart';
import '../widgets/form/models_choice_widget.dart';
import '../widgets/setting_widget.dart';

class ConversationSettingScreen extends StatefulWidget {
  const ConversationSettingScreen({
    super.key,
    required this.conversationData,
  });

  final ConversationModel conversationData;

  @override
  State<ConversationSettingScreen> createState() =>
      _ConversationSettingScreenState();
}

class _ConversationSettingScreenState extends State<ConversationSettingScreen> {
  late final _colorScheme = Theme.of(context).colorScheme;
  late final _backgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);

  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descController;
  late TextEditingController promptController;
  final palmModel = ValueNotifier<PalmModels>(PalmModels.textModel);

  void _hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  void initState() {
    setState(() {
      titleController =
          TextEditingController(text: widget.conversationData.title);
      descController =
          TextEditingController(text: widget.conversationData.desc);
      promptController =
          TextEditingController(text: widget.conversationData.prompt);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final palmProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    var conversationInfo = widget.conversationData;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          conversationInfo.title,
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
      backgroundColor: _backgroundColor,
      body: GestureDetector(
        onTap: () => _hideKeyboard(context),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    SingleSection(title: "自定义配置", children: [
                      ConversationTitleFormWidget(controller: titleController),
                      ConversationDescFormWidget(controller: descController),
                      ConversationPromptFormWidget(
                          controller: promptController),
                    ]),
                    SingleSection(title: "选择模型", children: [
                      PalmModelRadioListTile(notifier: palmModel),
                    ]),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            conversationInfo.title = titleController.text;
                            conversationInfo.prompt = promptController.text;
                            conversationInfo.desc = descController.text;
                            conversationInfo.modelName =
                                palmModelsMap[palmModel.value]!;
                            palmProvider
                                .setCurrentConversationInfo(conversationInfo);
                            ConversationModel conv = ConversationModel(
                                id: conversationInfo.id,
                                title: titleController.text,
                                prompt: promptController.text,
                                icon: conversationInfo.icon,
                                desc: conversationInfo.desc,
                                modelName: palmModelsMap[palmModel.value]!,
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
      ),
    );
  }
}
