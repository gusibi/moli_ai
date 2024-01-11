import 'dart:developer';

import 'package:moli_ai/data/repositories/datebase/client.dart';
import 'package:moli_ai/domain/entities/conversation_entity.dart';
import 'package:moli_ai/domain/inputs/conversation_input.dart';
import 'package:moli_ai/domain/repositories/conversation_repo.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/conversation_model.dart';

class ConversationReop {
  final tableName = "conversation_tab";
  Future<int> createConversation(ChatModel conv) async {
    final Database db = dbClient.get();
    DateTime now = DateTime.now();
    int timestamp = now.second;
    return await db.insert(
      tableName,
      {
        'title': conv.title,
        'prompt': conv.prompt,
        'convType': conv.convType,
        "desc": conv.desc,
        "icon": conv.icon,
        "rank": 0,
        "modelName": conv.modelName,
        "lastTime": timestamp
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ChatModel>> getAllChatConversations() async {
    // Get a reference to the database.
    final Database db = dbClient.get();

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'convType = ?',
      whereArgs: ["chat"],
      orderBy: 'id DESC',
    );

    return List.generate(maps.length, (i) {
      // log("getAllChatConversations: $maps[i]");
      return ChatModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        prompt: maps[i]['prompt'],
        convType: maps[i]['convType'],
        desc: maps[i]['desc'],
        icon: maps[i]['icon'],
        rank: maps[i]['rank'],
        modelName: maps[i]['modelName'],
        lastTime: maps[i]['lastTime'],
      );
    });
  }

  Future<List<ChatModel>> getAllDiaryConversations() async {
    // Get a reference to the database.
    final Database db = dbClient.get();

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'convType = ?',
      whereArgs: ["diary"],
      orderBy: 'id DESC',
    );

    return List.generate(maps.length, (i) {
      // log("dairy conversation: $maps[i]");
      return ChatModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        prompt: maps[i]['prompt'],
        convType: maps[i]['convType'],
        desc: maps[i]['desc'],
        icon: maps[i]['icon'],
        rank: maps[i]['rank'],
        modelName: maps[i]['modelName'],
        lastTime: maps[i]['lastTime'],
      );
    });
  }

  Future<ChatModel?> getConversationById(int id) async {
    final Database db = dbClient.get();

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.length == 1) {
      return ChatModel(
        id: maps[0]['id'],
        title: maps[0]['title'],
        prompt: maps[0]['prompt'],
        convType: maps[0]["convType"],
        desc: maps[0]['desc'],
        icon: maps[0]['icon'],
        rank: maps[0]['rank'],
        modelName: maps[0]['modelName'],
        lastTime: maps[0]['lastTime'],
      );
    }
    return null;
  }

  Future<void> updateConversation(ChatModel conv) async {
    // Get a reference to the database.
    final Database db = dbClient.get();

    // Update the given Dog.
    await db.update(
      tableName,
      conv.toMap(),
      where: 'id = ?',
      whereArgs: [conv.id],
    );
  }

  Future<int> deleteConversationById(int id) async {
    final Database db = dbClient.get();

    // Remove the conversation from the database.
    return await db.delete(
      tableName,
      // Use a `where` clause to delete a specific conversation.
      where: 'id = ?',
      // Pass the conversation's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}

class ChatRepoImpl implements ChatRepository {
  final ConversationReop _sqliteStorage;

  ChatRepoImpl(this._sqliteStorage);

  @override
  Future<List<ChatEntity>> chatList(ChatListInput input) async {
    List<ChatModel> list = await _sqliteStorage.getAllChatConversations();
    return List.generate(list.length, (i) {
      return ChatEntity(
        id: list[i].id,
        title: list[i].title,
        prompt: list[i].prompt,
        convType: list[i].convType,
        desc: list[i].desc,
        icon: list[i].icon,
        rank: list[i].rank,
        modelName: list[i].modelName,
        lastTime: list[i].lastTime,
      );
    });
  }

  @override
  Future<ChatEntity> chatDetail(int cid) async {
    ChatModel? detail = await _sqliteStorage.getConversationById(cid);
    return ChatEntity(
        id: detail!.id,
        title: detail.title,
        prompt: detail.prompt,
        convType: detail.convType,
        desc: detail.desc,
        icon: detail.icon,
        rank: detail.rank,
        modelName: detail.modelName,
        lastTime: detail.lastTime);
  }

  @override
  Future<int> chatDelete(ChatDeleteInput input) async {
    return await _sqliteStorage.deleteConversationById(input.chatId);
  }
}
