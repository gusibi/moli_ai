import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:moli_ai_box/services/palm_api_service.dart';
import '../constants/constants.dart';
import '../models/palm_text_model.dart';
import '../services/assets_manager.dart';
import '../services/services.dart';
import '../widgets/chat_widget.dart';
import '../widgets/text_widget.dart';

class PalmChatScreen extends StatefulWidget {
  const PalmChatScreen({super.key});

  @override
  State<PalmChatScreen> createState() => _PalmChatScreenState();
}

class _PalmChatScreenState extends State<PalmChatScreen> {
  bool _isTyping = false;
  List<TextChatModel> chatList = [];
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
    return Scaffold(
      appBar: AppBar(
        // elevation: 2,
        // leading: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Image.asset(AssetsManager.palmLogo),
        // ),
        title: const Text("Palm Chat"),
      ),
      body: SafeArea(
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
          SizedBox(height: 15),
          Material(
            color: cardColor,
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
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        try {
                          setState(() {
                            chatList.add(TextChatModel(
                                msg: textEditingController.text, chatIndex: 0));
                          });
                          setState(() {
                            _isTyping = true;
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
                      },
                      icon: const Icon(Icons.send, color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
