import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moli_ai_box/widgets/chat_widget.dart';

import '../constants/constants.dart';
import '../models/chat_list_model.dart';
import '../widgets/chat_card_widget.dart';
import 'palm_chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late final _colorScheme = Theme.of(context).colorScheme;
  late final _backgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: _backgroundColor,
          child: ChatListView(
            onSelected: _navigateToChatDetailPage,
            selectedIndex: 0,
          )),
      floatingActionButton: FloatingActionButton(
        heroTag: "newChat",
        backgroundColor: _colorScheme.tertiaryContainer,
        foregroundColor: _colorScheme.onTertiaryContainer,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToChatDetailPage(ChatCardModel chat) {
    log("redirect");
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PalmChatScreen(),
      ),
    );
  }
}

class ChatListView extends StatelessWidget {
  const ChatListView({
    super.key,
    this.selectedIndex,
    this.onSelected,
  });

  final int? selectedIndex;
  final ValueChanged<ChatCardModel>? onSelected;

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
                  onSelected: onSelected != null
                      ? () {
                          onSelected!(chats[index]);
                        }
                      : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
