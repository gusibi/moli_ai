import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../models/chat_list_model.dart';
import '../providers/palm_priovider.dart';
import '../widgets/chat_card_widget.dart';
import 'palm_chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({
    super.key,
    this.onSelected,
  });
  final ValueChanged<ChatCardModel>? onSelected;

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  // late final _colorScheme = Theme.of(context).colorScheme;
  // late final _backgroundColor = Color.alphaBlend(
  //     _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);

  @override
  Widget build(BuildContext context) {
    final palmProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    List<ChatCardModel> chatList = palmProvider.getChatList;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView(
        children: [
          const SizedBox(height: 18),
          ...List.generate(
            chatList.length,
            (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ChatCardWidget(
                  chatInfo: chatList[index],
                  id: chatList[index].id,
                  index: index,
                  onSelected: () {
                    _navigateToChatDetailPage(chatList[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _navigateToChatDetailPage(ChatCardModel chat) {
    final palmProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    palmProvider.setChatInfo(chat);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PalmChatScreen(),
      ),
    );
  }
}
