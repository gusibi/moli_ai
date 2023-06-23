import 'dart:async';
import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteClient {
  late Database _db;

  void _createConversationMessageTab(Database db) async {
    db.execute('''
    CREATE TABLE conversation_message_tab (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      conversationId INTEGER NOT NULL,
      role TEXT NOT NULL,
      message TEXT NOT NULL,
      replyId INTEGER NOT NULL,
      vote INTEGER NOT NULL,
      ctime TEXT NOT NULL
    );
    ''');
  }

  void _createConversationTab(Database db) async {
    db.execute('''
        CREATE TABLE conversation_tab (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          prompt TEXT NOT NULL,
          desc TEXT NOT NULL,
          icon INTEGER NOT NULL,
          rank INTEGER NOT NULL,
          modelName TEXT NOT NULL,
          lastTime INTEGER NOT NULL
        );
        ''');
  }

  void _createConfigTab(Database db) async {
    await db.execute('''
        CREATE TABLE config_tab (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          configName TEXT NOT NULL,
          value TEXT NOT NULL,
          createTime INTEGER NOT NULL,
          updateTime INTEGER NOT NULL
        );
        ''');
  }

  // this opens the database (and creates it if it doesn't exist)
  Future<void> init() async {
    log(await getDatabasesPath());
    final database = openDatabase(
        // Set the path to the database. Note: Using the `join` function from the
        // `path` package is best practice to ensure the path is correctly
        // constructed for each platform.
        join(await getDatabasesPath(), 'conversation.db'),
        // When the database is first created, create a table to store dogs.
        onCreate: (db, version) async {
          // Run the CREATE TABLE statement on the database.
          _createConfigTab(db);
          _createConversationTab(db);
          _createConversationMessageTab(db);
        },
        // Set the version. This executes the onCreate function and provides a
        // path to perform database upgrades and downgrades.
        version: 5,
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 5) {
            _createConfigTab(db); // 创建 config_tab 表
          }
        });
    _db = await database;
  }

  Database get() {
    return _db;
  }

  void q() async {
    print("_db-----<<<<<<<< $_db");
    List<Map<String, dynamic>> tables = await _db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;");
    print("Tables:--->>>>>> $tables");

    List<Map<String, dynamic>> columns =
        await _db.rawQuery("PRAGMA table_info(conversation_tab);");
    print("Columns-----: $columns");
  }
}

final dbClient = SqliteClient();
