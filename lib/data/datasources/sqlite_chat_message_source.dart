import 'package:moli_ai/core/constants/constants.dart';
import 'package:sqflite/sqflite.dart';

import '../models/conversation_model.dart';
import '../repositories/datebase/client.dart';

class ConversationMessageDBSource {
  final tableName = "conversation_message_tab";
  Future<int> insert(ConversationMessageModel message) async {
    final Database db = dbClient.get();
    return await db.insert(
      tableName,
      {
        'conversationId': message.conversationId,
        'role': message.role,
        "message": message.message,
        "replyId": message.replyId,
        "vote": message.vote,
        "ctime": message.ctime
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<ConversationMessageModel> createMessageWithRole(
      String role, String message, int conversationId, int replyId) async {
    ConversationMessageModel messageTab = ConversationMessageModel(
      id: 0,
      role: role,
      conversationId: conversationId,
      message: message,
      replyId: replyId,
      vote: 0,
      ctime: DateTime.now().toString(),
    );
    int id = await insert(messageTab);
    messageTab.id = id;
    return messageTab;
  }

  Future<ConversationMessageModel> createUserMessage(
      String message, int conversationId) async {
    return createMessageWithRole(roleUser, message, conversationId, 0);
  }

  Future<ConversationMessageModel> createSysMessage(
      String message, int conversationId) async {
    return createMessageWithRole(roleSys, message, conversationId, 0);
  }

  Future<ConversationMessageModel> createContextMessage(
      String message, int conversationId) async {
    return createMessageWithRole(roleContext, message, conversationId, 0);
  }

  Future<ConversationMessageModel> createAIMessage(
      String message, int conversationId, int replyId) async {
    return createMessageWithRole(roleUser, message, conversationId, replyId);
  }

  Future<List<ConversationMessageModel>> getMessages(
      int conversationId, int lastId) async {
    if (lastId == 0) {
      lastId = maxInt;
    }
    // 倒序查最后的数据
    final Database db = dbClient.get();
    final List<Map<String, dynamic>> maps = await db.query(tableName,
        where: 'id < ? AND conversationId = ?',
        whereArgs: [lastId, conversationId],
        orderBy: 'id DESC',
        limit: queyMessageLimit);
    // 将message 转成正序
    final List<ConversationMessageModel> messageList =
        List.generate(maps.length, (i) {
      return ConversationMessageModel(
        id: maps[i]['id'],
        role: maps[i]['role'],
        conversationId: maps[i]['conversationId'],
        message: maps[i]['message'],
        replyId: maps[i]['replyId'],
        vote: maps[i]['vote'],
        ctime: maps[i]['ctime'],
      );
    });
    return messageList.reversed.toList();
  }
}
