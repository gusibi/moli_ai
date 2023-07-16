import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/conversation_model.dart';
import '../providers/diary_privider.dart';
import '../repositories/conversation/conversation.dart';
import '../widgets/chat_card_widget.dart';
import 'diary_screen.dart';

class DiaryistScreen extends StatefulWidget {
  const DiaryistScreen({
    super.key,
    this.onSelected,
  });
  final ValueChanged<ConversationModel>? onSelected;

  @override
  State<DiaryistScreen> createState() => _DiaryListScreenState();
}

class _DiaryListScreenState extends State<DiaryistScreen> {
  late List<ConversationModel> _diaryList = [];
  late final _colorScheme = Theme.of(context).colorScheme;

  @override
  void initState() {
    super.initState();
    _query();
  }

  void _query() async {
    final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
    setState(() {
      _diaryList = diaryProvider.getDiaryList;
    });
    List<ConversationModel> diaryList =
        await ConversationReop().getAllDiaryConversations();
    log("conversationList $diaryList");
    if (diaryList.isNotEmpty) {
      setState(() {
        _diaryList = diaryList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView(
        children: [
          const SizedBox(height: 18),
          ...List.generate(
            _diaryList.length,
            (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 1.0),
                child: Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    ConversationModel conv = _diaryList[index];
                    ConversationReop().deleteConversationById(conv.id);
                    setState(() {
                      _diaryList.removeAt(index);
                    });
                  },
                  background: Container(
                    color: _colorScheme.error,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.delete, color: _colorScheme.onError),
                      ),
                    ),
                  ),
                  child: ConversationCardWidget(
                    conversation: _diaryList[index],
                    id: _diaryList[index].id,
                    index: index,
                    onSelected: () {
                      _navigateToDiaryScreen(_diaryList[index]);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _navigateToDiaryScreen(ConversationModel diary) {
    final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
    diaryProvider.setCurrentDiaryInfo(diary);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DiaryScreen(diaryData: diary),
      ),
    );
  }
}
