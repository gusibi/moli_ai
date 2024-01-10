import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../providers/palm_priovider.dart';

class TextFormWidget extends StatefulWidget {
  const TextFormWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.onSaved,
  });

  final TextEditingController controller;
  final String label;
  final void Function(String? value) onSaved;

  @override
  State<TextFormWidget> createState() => _TextFormWidgetState();
}

class _TextFormWidgetState extends State<TextFormWidget> {
  late String baseURL;
  @override
  void initState() {
    super.initState();
    // baseURL = widget.defaultValue;    baseURL = "";
  }

  @override
  Widget build(BuildContext context) {
    // var baseURL = widget.defaultValue;
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.label,
        border: InputBorder.none,
        // border: OutlineInputBorder(),
      ),

      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter ${widget.label}';
        }
        return null;
      },
      // style: TextStyle(),
      onChanged: (value) {},
      onSaved: (value) {
        log("${widget.label}: $value");
        widget.onSaved(value);
      },
    );
  }
}

class BaseURLFormWidget extends StatefulWidget {
  const BaseURLFormWidget({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  State<BaseURLFormWidget> createState() => _BaseURLFormWidgetState();
}

class _BaseURLFormWidgetState extends State<BaseURLFormWidget> {
  late String baseURL;
  @override
  void initState() {
    super.initState();
    // baseURL = widget.defaultValue;    baseURL = "";
  }

  @override
  Widget build(BuildContext context) {
    final palmProvider = Provider.of<AISettingProvider>(context, listen: false);
    // var baseURL = widget.defaultValue;
    return TextFormField(
      controller: widget.controller,
      decoration: const InputDecoration(
        labelText: "Base URL",
        border: InputBorder.none,
        // border: OutlineInputBorder(),
      ),

      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter base URL';
        }
        return null;
      },
      // style: TextStyle(),
      onChanged: (value) {
        setState(() {
          baseURL = value.toString();
        });
        palmProvider.setBasePalmURL(value.toString());
      },
      onSaved: (value) {
        baseURL = value.toString();
        palmProvider.setBasePalmURL(value.toString());
        log("baseURL: $baseURL");
      },
    );
  }
}

class ApiKeyFormWidget extends StatefulWidget {
  const ApiKeyFormWidget({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  State<ApiKeyFormWidget> createState() => _ApiKeyFormWidgetState();
}

class _ApiKeyFormWidgetState extends State<ApiKeyFormWidget> {
  bool isObscureText = true;
  @override
  Widget build(BuildContext context) {
    final palmProvider = Provider.of<AISettingProvider>(context, listen: false);
    var apiKey = "";
    return TextFormField(
      obscureText: isObscureText,
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: "API Key",
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            isObscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              isObscureText = !isObscureText;
            });
          },
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter API Key';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          apiKey = value.toString();
        });
        palmProvider.setPalmApiKey(value.toString());
      },
      onSaved: (value) {
        apiKey = value.toString();
        palmProvider.setPalmApiKey(value.toString());
        log("apiKey: $apiKey");
      },
    );
  }
}

class PromptMessageInputFormWidget extends StatefulWidget {
  const PromptMessageInputFormWidget({
    super.key,
    required this.textController,
    required this.sendOnPressed,
    required this.leftOnPressed,
  });
  final TextEditingController textController;
  final VoidCallback sendOnPressed;
  final VoidCallback leftOnPressed;

  @override
  State<PromptMessageInputFormWidget> createState() =>
      _PromptMessageInputFormWidgetState();
}

class _PromptMessageInputFormWidgetState
    extends State<PromptMessageInputFormWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var focusNode = FocusNode();
    return SizedBox(
      // height: 60,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
        child: Form(
          key: _formKey,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                  child: IconButton(
                onPressed: () {
                  widget.leftOnPressed();
                },
                icon: const Icon(Icons.clear_all),
              )),
              const SizedBox(width: 8),
              Expanded(
                child: RawKeyboardListener(
                  focusNode: focusNode,
                  onKey: (event) {
                    if (event is RawKeyUpEvent) {
                      if (event.logicalKey == LogicalKeyboardKey.enter) {
                        if (event.isShiftPressed) {
                          final text = widget.textController.text.trim();
                          if (text.isEmpty) {
                            // 处理回车事件
                            widget.textController.clear();
                          }
                          log('Enter: $text');
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            widget.sendOnPressed();
                          }
                        } else {
                          // 获取当前行的文本内容
                          final text = widget.textController.value.text;
                          final cursorPosition =
                              widget.textController.selection.baseOffset;
                          String textBefore = text.substring(0, cursorPosition);
                          textBefore = textBefore.trimRight();
                          var offset = textBefore.length + 1;
                          if (text.length == textBefore.length) {
                            offset = textBefore.length;
                          }
                          widget.textController.value = TextEditingValue(
                            text: text,
                            selection: TextSelection.collapsed(offset: offset),
                          );
                        }
                      }
                    }
                  },
                  child: TextFormField(
                    maxLines: 2,
                    style: const TextStyle(fontSize: 14),
                    controller: widget.textController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your message';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      border: const OutlineInputBorder(),
                      hintText: "Type your message",
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                  child: IconButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.sendOnPressed();
                  }
                },
                icon: const Icon(Icons.send),
              )),
              // const CircleAvatar(child: Icon(Icons.send)),
            ],
          ),
        ),
      ),
    );
  }
}

class ConversationTitleFormWidget extends StatefulWidget {
  const ConversationTitleFormWidget({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  State<ConversationTitleFormWidget> createState() =>
      _ConversationTitleFormWidget();
}

class _ConversationTitleFormWidget extends State<ConversationTitleFormWidget> {
  @override
  Widget build(BuildContext context) {
    late final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final palmProvider = Provider.of<AISettingProvider>(context, listen: false);
    var currentTitle = palmProvider.getCurrentConversationTitle;
    return TextFormField(
      controller: widget.controller,
      decoration: const InputDecoration(
        labelText: "Chat Name",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.badge_outlined),
      ),
      style: TextStyle(
          color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter Chat Name';
        }
        return null;
      },
      // style: TextStyle(),
      onChanged: (value) {
        setState(() {
          currentTitle = value.toString();
        });
        palmProvider.setCurrentConversationTitle(value.toString());
      },
      onSaved: (value) {
        currentTitle = value.toString();
        palmProvider.setCurrentConversationTitle(value.toString());
        log("conversation.title: $currentTitle");
      },
    );
  }
}

class ConversationPromptFormWidget extends StatefulWidget {
  const ConversationPromptFormWidget({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  State<ConversationPromptFormWidget> createState() =>
      _ConversationPromptFormWidget();
}

class _ConversationPromptFormWidget
    extends State<ConversationPromptFormWidget> {
  late final ColorScheme colorScheme = Theme.of(context).colorScheme;
  @override
  Widget build(BuildContext context) {
    final palmProvider = Provider.of<AISettingProvider>(context, listen: false);
    var currentPrompt = palmProvider.getCurrentConversationPrompt;
    return TextFormField(
      maxLines: 2,
      controller: widget.controller,
      decoration: const InputDecoration(
        labelText: "Prompt",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.tips_and_updates_outlined),
      ),
      style: TextStyle(
          color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500),
      onChanged: (value) {
        setState(() {
          currentPrompt = value.toString();
        });
        palmProvider.setCurrentConversationPrompt(value.toString());
      },
      onSaved: (value) {
        currentPrompt = value.toString();
        palmProvider.setCurrentConversationPrompt(value.toString());
        log("conversation.prompt: $currentPrompt");
      },
    );
  }
}

class ConversationDescFormWidget extends StatefulWidget {
  const ConversationDescFormWidget({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  State<ConversationDescFormWidget> createState() =>
      _ConversationDescFormWidget();
}

class _ConversationDescFormWidget extends State<ConversationDescFormWidget> {
  @override
  Widget build(BuildContext context) {
    late final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final palmProvider = Provider.of<AISettingProvider>(context, listen: false);
    var currentConversation = palmProvider.getCurrentConversationInfo;
    var currentDesc = currentConversation.desc;
    return TextFormField(
      controller: widget.controller,
      decoration: const InputDecoration(
        labelText: "Description",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.description_outlined),
      ),
      style: TextStyle(
          color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500),
      onChanged: (value) {
        setState(() {
          currentDesc = value.toString();
        });
        currentConversation.desc = currentDesc;
        palmProvider.setCurrentConversationInfo(currentConversation);
      },
      onSaved: (value) {
        currentDesc = value.toString();
        currentConversation.desc = currentDesc;
        palmProvider.setCurrentConversationInfo(currentConversation);
        log("conversation.desc: $currentDesc");
      },
    );
  }
}
