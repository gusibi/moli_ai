import 'dart:developer';

import 'package:moli_ai/repositories/datebase/client.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/conversation_model.dart';

class ConversationReop {
  final tableName = "conversation_tab";
  Future<int> createConversation(ConversationModel conv) async {
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

  Future<List<ConversationModel>> getAllChatConversations() async {
    // Get a reference to the database.
    final Database db = dbClient.get();

    final List<Map<String, dynamic>> maps =
        await db.query(tableName, where: 'convType = ?', whereArgs: ["chat"]);

    return List.generate(maps.length, (i) {
      // log("getAllChatConversations: $maps[i]");
      return ConversationModel(
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

  Future<List<ConversationModel>> getAllDiaryConversations() async {
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
      return ConversationModel(
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

  Future<ConversationModel?> getConversationById(int id) async {
    final Database db = dbClient.get();

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.length == 1) {
      return ConversationModel(
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

  Future<void> updateConversation(ConversationModel conv) async {
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

  Future<void> deleteConversationById(int id) async {
    final Database db = dbClient.get();

    // Remove the conversation from the database.
    await db.delete(
      tableName,
      // Use a `where` clause to delete a specific conversation.
      where: 'id = ?',
      // Pass the conversation's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
