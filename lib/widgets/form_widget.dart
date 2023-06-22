import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/palm_priovider.dart';

class BaseURLFormWidget extends StatefulWidget {
  const BaseURLFormWidget({super.key});

  @override
  State<BaseURLFormWidget> createState() => _BaseURLFormWidgetState();
}

class _BaseURLFormWidgetState extends State<BaseURLFormWidget> {
  @override
  Widget build(BuildContext context) {
    final palmProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    var baseURL = palmProvider.getBaseURL;
    return TextFormField(
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
      initialValue: baseURL,
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
  const ApiKeyFormWidget({super.key});

  @override
  State<ApiKeyFormWidget> createState() => _ApiKeyFormWidgetState();
}

class _ApiKeyFormWidgetState extends State<ApiKeyFormWidget> {
  @override
  Widget build(BuildContext context) {
    final palmProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    var apiKey = palmProvider.getApiKey;
    return TextFormField(
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
      initialValue: apiKey,
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

class ChatInputFormWidget extends StatelessWidget {
  const ChatInputFormWidget({
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

class ChatTitleFormWidget extends StatefulWidget {
  const ChatTitleFormWidget({super.key});

  @override
  State<ChatTitleFormWidget> createState() => _ChatTitleFormWidget();
}

class _ChatTitleFormWidget extends State<ChatTitleFormWidget> {
  @override
  Widget build(BuildContext context) {
    final palmProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    var currentChatTitle = palmProvider.getCurrentChatTitle;
    return TextFormField(
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
      initialValue: currentChatTitle,
      onChanged: (value) {
        setState(() {
          currentChatTitle = value.toString();
        });
        palmProvider.setCurrentChatTitle(value.toString());
      },
      onSaved: (value) {
        currentChatTitle = value.toString();
        palmProvider.setCurrentChatTitle(value.toString());
        log("chatInfo.title: $currentChatTitle");
      },
    );
  }
}

class ChatPromptFormWidget extends StatefulWidget {
  const ChatPromptFormWidget({super.key});

  @override
  State<ChatPromptFormWidget> createState() => _ChatPromptFormWidget();
}

class _ChatPromptFormWidget extends State<ChatPromptFormWidget> {
  @override
  Widget build(BuildContext context) {
    final palmProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    var currentChatPrompt = palmProvider.getCurrentChatPrompt;
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Prompt",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.description_outlined),
      ),
      initialValue: currentChatPrompt,
      onChanged: (value) {
        setState(() {
          currentChatPrompt = value.toString();
        });
        palmProvider.setCurrentChatPrompt(value.toString());
      },
      onSaved: (value) {
        currentChatPrompt = value.toString();
        palmProvider.setCurrentChatPrompt(value.toString());
        log("chatInfo.prompt: $currentChatPrompt");
      },
    );
  }
}
