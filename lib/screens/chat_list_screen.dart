import 'dart:developer';

import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/chat_list_model.dart';
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
  late final _colorScheme = Theme.of(context).colorScheme;
  late final _backgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView(
        children: [
          const SizedBox(height: 8),
          ...List.generate(
            chats.length,
            (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ChatCardWidget(
                  title: chats[index].title,
                  index: index,
                  prompt: chats[index].prompt,
                  icon: chats[index].icon,
                  modelName: chats[index].modelName,
                  onSelected: () {
                    _navigateToChatDetailPage(chats[index]);
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PalmChatScreen(),
      ),
    );
  }
}
