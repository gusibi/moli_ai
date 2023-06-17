import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:moli_ai_box/services/palm_api_service.dart';
import 'package:provider/provider.dart';
import '../models/palm_text_model.dart';
import '../providers/palm_priovider.dart';
import '../widgets/chat_widget.dart';

class PalmChatScreen extends StatefulWidget {
  const PalmChatScreen({
    super.key,
  });

  @override
  State<PalmChatScreen> createState() => _PalmChatScreenState();
}

class _PalmChatScreenState extends State<PalmChatScreen> {
  bool _isTyping = false;
  List<TextChatModel> chatList = [];
  late final _colorScheme = Theme.of(context).colorScheme;
  late final _backgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);
  late final _buttonColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);

  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palmProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    String chatTitle = palmProvider.getChatInfo.title;
    log("title: $chatTitle");
    return Scaffold(
      appBar: AppBar(
        title: Text(chatTitle),
      ),
      body: Container(
        color: _backgroundColor,
        child: SafeArea(
            child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    message: chatList[index].msg,
                    chatIndex: chatList[index].chatIndex,
                  );
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
            Material(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      // 支持换行
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: textEditingController,
                        onSubmitted: (value) {},
                        decoration: const InputDecoration.collapsed(
                          hintText: "How can I help you",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          sendMessageFCT(context);
                        },
                        icon: const Icon(
                          Icons.send,
                        )),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  Future<void> sendMessageFCT(BuildContext context) async {
    try {
      setState(() {
        chatList
            .add(TextChatModel(msg: textEditingController.text, chatIndex: 0));
      });
      setState(() {
        _isTyping = true;
        textEditingController.clear();
      });
      final list = await PalmApiService.getTextReponse(
          context, textEditingController.text);
      setState(() {
        chatList.add(list[0]);
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
