import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../constants/constants.dart';
import '../services/assets_manager.dart';
import '../widgets/chat_widget.dart';

class PalmChatScreen extends StatefulWidget {
  const PalmChatScreen({super.key});

  @override
  State<PalmChatScreen> createState() => _PalmChatScreenState();
}

class _PalmChatScreenState extends State<PalmChatScreen> {
  final bool _isTyping = true;
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
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.palmLogo),
        ),
        title: const Text("Palm Chat"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: testChatMessages.length,
              itemBuilder: (context, index) {
                return ChatWidget(
                  message: testChatMessages[index]["message"].toString(),
                  chatIndex: int.parse(
                      testChatMessages[index]["chatIndex"].toString()),
                );
              },
            ),
          ),
          if (_isTyping) ...[
            const SpinKitThreeBounce(
              color: Colors.white,
              size: 18,
            ),
            SizedBox(height: 15),
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: textEditingController,
                        onSubmitted: (value) {
                          // TODO send message
                        },
                        decoration: const InputDecoration.collapsed(
                          hintText: "How can I help you",
                          hintStyle: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.send, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ],
      )),
    );
  }
}
