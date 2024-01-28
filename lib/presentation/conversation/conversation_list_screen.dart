import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moli_ai/data/providers/conversation_privider.dart';
import 'package:moli_ai/domain/entities/constants.dart';
import 'package:moli_ai/domain/entities/conversation_entity.dart';
import 'package:moli_ai/domain/inputs/chat_info_input.dart';
import 'package:moli_ai/domain/usecases/chat_delete_usecase.dart';
import 'package:moli_ai/domain/usecases/chat_get_usecase.dart';
import 'package:moli_ai/presentation/widgets/chat_card_widget.dart';
import 'package:provider/provider.dart';

import 'conversation_screen.dart';

class ChatListScreen extends StatefulWidget {
  final ValueChanged<ChatEntity>? onSelected;
  final GetChatListUseCase _getChatListUseCase;
  final ChatDeleteUseCase _deleteChatUseCase;

  const ChatListScreen({
    super.key,
    this.onSelected,
    required GetChatListUseCase chatListUseCase,
    required ChatDeleteUseCase deleteChatUseCase,
  })  : _getChatListUseCase = chatListUseCase,
        _deleteChatUseCase = deleteChatUseCase;

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late List<ChatEntity> _chatList = [];
  late final _colorScheme = Theme.of(context).colorScheme;

  @override
  void initState() {
    super.initState();
    _query();
  }

  void _query() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    setState(() {
      _chatList = chatProvider.getChatList;
    });
    List<ChatEntity> chatList = await widget._getChatListUseCase
        .call(ChatListInput(pageSize: 20, pageNum: 1));
    // log("conversationList ----$conversationList");
    if (chatList.isNotEmpty) {
      setState(() {
        _chatList = chatList;
        chatProvider.setChatList(_chatList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            const SizedBox(height: 18),
            ...List.generate(
              _chatList.length,
              (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      ChatEntity chat = _chatList[index];
                      widget._deleteChatUseCase
                          .call(ChatDeleteInput(chatId: chat.id));
                      setState(() {
                        _chatList.removeAt(index);
                      });
                    },
                    background: Container(
                      color: _colorScheme.error,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child:
                              Icon(Icons.delete, color: _colorScheme.onError),
                        ),
                      ),
                    ),
                    child: ChatCardWidget(
                      chatEntity: _chatList[index],
                      id: _chatList[index].id,
                      index: index,
                      onSelected: () {
                        _navigateToConversationScreen(_chatList[index]);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "newConversation",
        onPressed: () {
          _navigateToCreateNewConversation();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToCreateNewConversation() {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.setCurrentChatInfo(defaultChatEntity);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => newConversationScreen(defaultChatEntity),
      ),
    );
  }

  void _navigateToConversationScreen(ChatEntity conv) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.setCurrentChatInfo(conv);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => newConversationScreen(conv),
      ),
    );
  }
}
