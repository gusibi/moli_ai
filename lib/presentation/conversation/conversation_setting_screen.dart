import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../data/models/conversation_model.dart';
import '../../core/providers/palm_priovider.dart';
import '../../data/repositories/chat/chat_repo_impl.dart';
import '../../core/utils/color.dart';
import '../../core/utils/time.dart';
import '../widgets/form/form_widget.dart';
import '../widgets/form/models_choice_widget.dart';
import '../widgets/list/setting_widget.dart';

class ConversationSettingScreen extends StatefulWidget {
  const ConversationSettingScreen({
    super.key,
    required this.conversationData,
  });

  final ChatModel conversationData;

  @override
  State<ConversationSettingScreen> createState() =>
      _ConversationSettingScreenState();
}

class _ConversationSettingScreenState extends State<ConversationSettingScreen> {
  late final _colorScheme = Theme.of(context).colorScheme;
  late final _backgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);
  late final _buttonColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.primary);
  late final _buttonTextColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.onPrimary);

  String selectedModel = geminiProModel.modelName;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descController;
  late TextEditingController promptController;
  var palmModel = ValueNotifier<PalmModels>(PalmModels.textModel);

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
      if (widget.conversationData.modelName ==
          palmModelsMap[PalmModels.textModel]) {
        palmModel = ValueNotifier<PalmModels>(PalmModels.textModel);
      } else if (widget.conversationData.modelName ==
          palmModelsMap[PalmModels.chatModel]) {
        palmModel = ValueNotifier<PalmModels>(PalmModels.chatModel);
      } else if (widget.conversationData.modelName ==
          palmModelsMap[PalmModels.geminiProModel]) {
        palmModel = ValueNotifier<PalmModels>(PalmModels.geminiProModel);
      }
      selectedModel = widget.conversationData.modelName;
    });
    super.initState();
  }

  void handleModelSelected(String value) {
    setState(() {
      selectedModel = value;
    });
    // _saveDefaultAIConfig();
  }

  @override
  Widget build(BuildContext context) {
    final palmProvider = Provider.of<AISettingProvider>(context, listen: false);
    var conversationInfo = widget.conversationData;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          conversationInfo.title,
          // style: TextStyle(color: _colorScheme.onSecondary),
        ),
        centerTitle: true,
        shadowColor: getShadowColor(_colorScheme),
        elevation: 4,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            // color: _colorScheme.onPrimary,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      backgroundColor: _backgroundColor,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GestureDetector(
            onTap: () => _hideKeyboard(context),
            child: Form(
              key: _formKey,
              child: ListView(children: [
                FormSection(title: "自定义配置", children: [
                  ConversationTitleFormWidget(controller: titleController),
                  ConversationDescFormWidget(controller: descController),
                  ConversationPromptFormWidget(controller: promptController),
                ]),
                // FormSection(title: "选择模型", children: [
                //   PalmModelRadioListTile(notifier: palmModel),
                // ]),
                FormSection(title: "模型选择", children: [
                  DefaultAIDropDownWidget(
                      labelText: "Diary AI",
                      options: [
                        textModel.modelName,
                        chatModel.modelName,
                        geminiProModel.modelName,
                        azureGPT35Model.modelName,
                      ],
                      onOptionSelected: handleModelSelected,
                      selectedOption: selectedModel),
                ]),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(_buttonColor),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(_buttonTextColor),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        conversationInfo.title = titleController.text;
                        conversationInfo.prompt = promptController.text;
                        conversationInfo.desc = descController.text;
                        conversationInfo.modelName =
                            palmModelsMap[palmModel.value]!;
                        conversationInfo.modelName = selectedModel;
                        palmProvider
                            .setCurrentConversationInfo(conversationInfo);
                        ChatModel conv = ChatModel(
                            id: conversationInfo.id,
                            title: titleController.text,
                            convType: "chat",
                            prompt: promptController.text,
                            icon: conversationInfo.icon,
                            desc: conversationInfo.desc,
                            modelName: conversationInfo.modelName,
                            rank: 0,
                            lastTime: timestampNow());
                        log("{{$conv.id}}");
                        log(conv.modelName);
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
