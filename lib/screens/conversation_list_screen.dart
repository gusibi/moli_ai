import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/conversation_model.dart';
import '../providers/palm_priovider.dart';
import '../repositories/conversation/conversation.dart';
import '../widgets/chat_card_widget.dart';
import 'conversation_screen.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({
    super.key,
    this.onSelected,
  });
  final ValueChanged<ConversationModel>? onSelected;

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  // late final _colorScheme = Theme.of(context).colorScheme;
  // late final _backgroundColor = Color.alphaBlend(
  //     _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);

  late List<ConversationModel> _conversationList = [];

  @override
  void initState() {
    super.initState();
    _query();
  }

  void _query() async {
    final palmProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    setState(() {
      _conversationList = palmProvider.getConversationList;
    });
    List<ConversationModel> conversationList =
        await ConversationReop().getAllConversations();
    print("conversationList $conversationList");
    if (conversationList.isNotEmpty) {
      setState(() {
        _conversationList = conversationList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // List<ConversationModel> chatList = palmProvider.getChatList;
    // List<ConversationModel> chatList =
    //     ConversationReop().convs() as List<ConversationModel>;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView(
        children: [
          const SizedBox(height: 18),
          ...List.generate(
            _conversationList.length,
            (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ConversationCardWidget(
                  conversation: _conversationList[index],
                  id: _conversationList[index].id,
                  index: index,
                  onSelected: () {
                    _navigateToConversationScreen(_conversationList[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _navigateToConversationScreen(ConversationModel conv) {
    final palmProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    palmProvider.setCurrentConversationInfo(conv);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ConversationScreen(conversationData: conv),
      ),
    );
  }
}
