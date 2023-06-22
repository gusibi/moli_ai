import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chat_list_model.dart';
import '../models/conversation_model.dart';
import '../providers/palm_priovider.dart';
import '../repositories/conversation/conversation.dart';
import '../widgets/chat_card_widget.dart';
import 'palm_chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({
    super.key,
    this.onSelected,
  });
  final ValueChanged<ConversationCardDto>? onSelected;

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  // late final _colorScheme = Theme.of(context).colorScheme;
  // late final _backgroundColor = Color.alphaBlend(
  //     _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);

  late List<ConversationCardDto> _chatList = [];

  @override
  void initState() {
    super.initState();
    _query();
  }

  void _query() async {
    final palmProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    setState(() {
      _chatList = palmProvider.getChatList;
    });
    List<ConversationModel> chatList = await ConversationReop().convs();
    print("chatList $chatList");
    if (chatList.isNotEmpty) {
      _chatList = List.generate(chatList.length, (index) {
        final iconData =
            IconData(chatList[index].icon, fontFamily: 'MaterialIcons');
        return ConversationCardDto(
          id: chatList[index].id,
          title: chatList[index].title,
          prompt: chatList[index].prompt,
          modelName: chatList[index].modelName,
          icon: iconData,
        );
      });
      setState(() {
        _chatList = _chatList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // List<ConversationCardDto> chatList = palmProvider.getChatList;
    // List<ConversationModel> chatList =
    //     ConversationReop().convs() as List<ConversationModel>;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView(
        children: [
          const SizedBox(height: 18),
          ...List.generate(
            _chatList.length,
            (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ChatCardWidget(
                  chatInfo: _chatList[index],
                  id: _chatList[index].id,
                  index: index,
                  onSelected: () {
                    _navigateToChatDetailPage(_chatList[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _navigateToChatDetailPage(ConversationCardDto chat) {
    final palmProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    palmProvider.setCurrentChatInfo(chat);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PalmChatScreen(conversationData: chat),
      ),
    );
  }
}
