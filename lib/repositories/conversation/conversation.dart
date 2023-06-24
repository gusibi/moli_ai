import 'package:moli_ai_box/repositories/datebase/client.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/conversation_model.dart';

class ConversationReop {
  final tableName = "conversation_tab";
  // Define a function that inserts dogs into the database
  Future<int> createConversation(ConversationModel conv) async {
    final Database db = dbClient.get();
    DateTime now = DateTime.now();
    int timestamp = now.second;
    return await db.insert(
      tableName,
      {
        'title': conv.title,
        'prompt': conv.prompt,
        "desc": conv.desc,
        "icon": conv.icon,
        "rank": 0,
        "modelName": conv.modelName,
        "lastTime": timestamp
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<ConversationModel>> convs() async {
    // Get a reference to the database.
    final Database db = dbClient.get();

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return ConversationModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        prompt: maps[i]['prompt'],
        desc: maps[i]['desc'],
        icon: maps[i]['icon'],
        rank: maps[i]['rank'],
        modelName: maps[i]['modelName'],
        lastTime: maps[i]['lastTime'],
      );
    });
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<ConversationModel?> getConversationById(int id) async {
    final Database db = dbClient.get();

    final List<Map<String, dynamic>> maps =
        await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    if (maps.length == 1) {
      return ConversationModel(
        id: maps[0]['id'],
        title: maps[0]['title'],
        prompt: maps[0]['prompt'],
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
      'conversation_tab',
      conv.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [conv.id],
    );
  }
}
