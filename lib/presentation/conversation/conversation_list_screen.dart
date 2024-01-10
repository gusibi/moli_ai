import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moli_ai/core/constants/constants.dart';
import 'package:moli_ai/data/providers/conversation_privider.dart';
import 'package:moli_ai/domain/entities/conversation_entity.dart';
import 'package:moli_ai/domain/inputs/conversation_input.dart';
import 'package:moli_ai/domain/usecases/get_conversations_usecase.dart';
import 'package:provider/provider.dart';

import '../../data/models/conversation_model.dart';
import '../../core/providers/palm_priovider.dart';
import '../../data/repositories/conversation/conversation_repo_impl.dart';
import '../../core/widgets/chat_card_widget.dart';
import 'conversation_screen.dart';

class ConversationListScreen extends StatefulWidget {
  final ValueChanged<ConversationModel>? onSelected;
  final GetConversationListUseCase _getConversationListUseCase;

  const ConversationListScreen({
    super.key,
    this.onSelected,
    required GetConversationListUseCase conversationUseCase,
  }) : _getConversationListUseCase = conversationUseCase;

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  late List<ConversationEntity> _conversationList = [];
  late final _colorScheme = Theme.of(context).colorScheme;

  @override
  void initState() {
    super.initState();
    _query();
  }

  void _query() async {
    final convProvider =
        Provider.of<ConversationProvider>(context, listen: false);
    setState(() {
      _conversationList = convProvider.getConversationList;
    });
    List<ConversationEntity> conversationList = await widget
        ._getConversationListUseCase
        .call(ConversationListInput(pageSize: 20, pageNum: 1));
    // log("conversationList ----$conversationList");
    if (conversationList.isNotEmpty) {
      setState(() {
        _conversationList = conversationList;
        convProvider.setConversationList(_conversationList);
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
              _conversationList.length,
              (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      ConversationModel conv = _conversationList[index];
                      ConversationReop().deleteConversationById(conv.id);
                      setState(() {
                        _conversationList.removeAt(index);
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
                    child: ConversationCardWidget(
                      conversation: _conversationList[index],
                      id: _conversationList[index].id,
                      index: index,
                      onSelected: () {
                        _navigateToConversationScreen(_conversationList[index]);
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
    final palmProvider = Provider.of<AISettingProvider>(context, listen: false);
    palmProvider.setCurrentConversationInfo(newConversation);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ConversationScreen(
          conversationData: newConversation,
        ),
      ),
    );
  }

  void _navigateToConversationScreen(ConversationModel conv) {
    final palmProvider = Provider.of<AISettingProvider>(context, listen: false);
    palmProvider.setCurrentConversationInfo(conv);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ConversationScreen(conversationData: conv),
      ),
    );
  }
}
