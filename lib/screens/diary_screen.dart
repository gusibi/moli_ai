import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/color.dart';
import '../widgets/form/form_widget.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  late TextEditingController textEditingController;
  bool _isTyping = false;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
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
        shadowColor: getShadowColor(colorScheme),
        title: const Text("Diary"),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {
              // 点击按钮时的操作
            },
          ),
        ],
      ),
      body: GestureDetector(
          onTap: () => _hideKeyboard(context),
          child: Container(
              color: colorScheme.primary,
              child: Align(
                child: Column(
                  children: [
                    Expanded(child: Text("content")),
                    PromptMessageInputFormWidget(
                        textController: textEditingController,
                        onPressed: () {
                          if (_isTyping) {
                            log("asking");
                          } else {
                            _hideKeyboard(context);
                          }
                        }),
                  ],
                ),
              ))),
    );
  }
}
