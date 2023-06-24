import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/palm_priovider.dart';

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
    final palmProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    // var baseURL = widget.defaultValue;
    return TextFormField(
      controller: widget.controller,
      decoration: const InputDecoration(
        labelText: "Base URL",
        border: OutlineInputBorder(),
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
        palmProvider.setBaseURL(value.toString());
      },
      onSaved: (value) {
        baseURL = value.toString();
        palmProvider.setBaseURL(value.toString());
        print("baseURL: $baseURL");
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
  @override
  Widget build(BuildContext context) {
    final palmProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    var apiKey = "";
    return TextFormField(
      controller: widget.controller,
      decoration: const InputDecoration(
        labelText: "API Key",
        border: OutlineInputBorder(),
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
        palmProvider.setApiKey(value.toString());
      },
      onSaved: (value) {
        apiKey = value.toString();
        palmProvider.setApiKey(value.toString());
        print("apiKey: $apiKey");
      },
    );
  }
}

class PromptMessageInputFormWidget extends StatelessWidget {
  const PromptMessageInputFormWidget({
    super.key,
    required this.textController,
    required this.onPressed,
  });
  final TextEditingController textController;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 60,
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(child: Icon(Icons.cleaning_services_outlined)),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                maxLines: 2,
                style: const TextStyle(color: Colors.black, fontSize: 14),
                controller: textController,
                decoration: InputDecoration(
                  isDense: true,
                  border: const OutlineInputBorder(),
                  hintText: "Type your message",
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
                child: IconButton(
              onPressed: onPressed,
              icon: const Icon(Icons.send),
            )),
            // const CircleAvatar(child: Icon(Icons.send)),
          ],
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
    final palmProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    var currentTitle = palmProvider.getCurrentConversationTitle;
    return TextFormField(
      controller: widget.controller,
      decoration: const InputDecoration(
        labelText: "Chat Name",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.badge_outlined),
      ),

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
  @override
  Widget build(BuildContext context) {
    final palmProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    var currentPrompt = palmProvider.getCurrentConversationPrompt;
    return TextFormField(
      controller: widget.controller,
      decoration: const InputDecoration(
        labelText: "Prompt",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.description_outlined),
      ),
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
