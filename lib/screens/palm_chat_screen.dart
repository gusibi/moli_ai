import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:moli_ai_box/services/palm_api_service.dart';
import 'package:provider/provider.dart';
import '../models/chat_list_model.dart';
import '../models/palm_text_model.dart';
import '../providers/palm_priovider.dart';
import '../widgets/chat_widget.dart';
import '../widgets/form_widget.dart';
import 'chat_setting_screen.dart';

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

  late TextEditingController textEditingController;
  late ChatCardModel currentChatInfo;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
    final palmProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    currentChatInfo = palmProvider.getCurrentChatInfo;
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void _hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        automaticallyImplyLeading: false,
        backgroundColor: _colorScheme.primary,
        shadowColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: _colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  child: Icon(currentChatInfo.icon),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        currentChatInfo.title,
                        style: TextStyle(
                            color: _colorScheme.onPrimary, fontSize: 14),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        currentChatInfo.prompt!,
                        style: TextStyle(
                            color: _colorScheme.onSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _navigateToChatSetting();
                  },
                  icon: const Icon(Icons.settings),
                  color: _colorScheme.onSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => _hideKeyboard(context),
        child: Container(
          color: _backgroundColor,
          child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                children: [
                  Flexible(
                    child: ListView.builder(
                      itemCount: chatList.length,
                      itemBuilder: (context, index) {
                        return ChatMessageWidget(chatInfo: chatList[index]);
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
                  // ChatInputFormWidget(),
                  ChatInputFormWidget(
                      textController: textEditingController,
                      onPressed: () {
                        if (_isTyping) {
                          log("asking");
                        } else {
                          _hideKeyboard(context);
                          sendMessageFCT(context);
                        }
                      }),
                ],
              )),
        ),
      ),
    );
  }

  void _navigateToChatSetting() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ChatSettingScreen(),
      ),
    );
  }

  Future<void> sendMessageFCT(BuildContext context) async {
    try {
      String text = textEditingController.text;
      setState(() {
        chatList.add(TextChatModel(msg: text, chatIndex: 0));
        _isTyping = true;
        textEditingController.clear();
      });
      final list = await PalmApiService.getTextReponse(context, text);
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
