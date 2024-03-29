import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moli_ai/data/datasources/sqlite_chat_source.dart';
import 'package:provider/provider.dart';

import '../../core/constants/constants.dart';
import '../../data/models/conversation_model.dart';
import '../../core/providers/diary_privider.dart';
import '../../data/repositories/chat/chat_repo_impl.dart';
import '../widgets/conversation_card_widget.dart';
import 'diary_screen.dart';

class DiaryistScreen extends StatefulWidget {
  const DiaryistScreen({
    super.key,
    this.onSelected,
  });
  final ValueChanged<ChatModel>? onSelected;

  @override
  State<DiaryistScreen> createState() => _DiaryListScreenState();
}

class _DiaryListScreenState extends State<DiaryistScreen> {
  late List<ChatModel> _diaryList = [];
  late final _colorScheme = Theme.of(context).colorScheme;
  bool wideScreen = false;

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
    List<ChatModel> diaryList =
        await ConversationDBSource().getAllDiaryConversations();
    // log("conversationList---: $diaryList");
    if (diaryList.isNotEmpty) {
      setState(() {
        _diaryList = diaryList;
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
              _diaryList.length,
              (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      ChatModel conv = _diaryList[index];
                      ConversationDBSource().deleteConversationById(conv.id);
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
                          child:
                              Icon(Icons.delete, color: _colorScheme.onError),
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
      ),
      floatingActionButton: wideScreen
          ? null
          : FloatingActionButton(
              heroTag: "newDiary",
              onPressed: () {
                _navigateToCreateNewDiary();
              },
              child: const Icon(Icons.note_add),
            ),
    );
  }

  void _navigateToCreateNewDiary() {
    final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
    diaryProvider.setCurrentDiaryInfo(newDiaryConversation);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DiaryScreen(
          diaryData: newDiaryConversation,
        ),
      ),
    );
  }

  void _navigateToDiaryScreen(ChatModel diary) {
    final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
    diaryProvider.setCurrentDiaryInfo(diary);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DiaryScreen(diaryData: diary),
      ),
    );
  }
}
