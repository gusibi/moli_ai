import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../../core/constants/constants.dart';
import '../../models/config_model.dart';
import '../datebase/client.dart';

class ConfigReop {
  Future<int> createConfig(ConfigModel config) async {
    final Database db = dbClient.get();
    return await db.insert(
      'config_tab',
      {
        'configName': config.configName,
        'value': config.value,
        'createTime': DateTime.now().second,
        'updateTime': DateTime.now().second,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> createOrUpdatePalmConfig(PalmConfig config) async {
    final Database db = dbClient.get();

    ConfigModel? conf = await getConfigByName(palmConfigname);
    if (conf == null) {
      return await db.insert(
        'config_tab',
        {
          'configName': palmConfigname,
          'value': jsonEncode(config.toMap()),
          'createTime': DateTime.now().second,
          'updateTime': DateTime.now().second,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      // Update the given Dog.
      return await db.update(
        'config_tab',
        {
          'value': jsonEncode(config.toMap()),
          'updateTime': DateTime.now().second,
        },
        // Ensure that the Dog has a matching id.
        where: 'id = ?',
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [conf.id],
      );
    }
  }

  Future<int> createOrUpdateAzureOpenAIConfig(AzureOpenAIConfig config) async {
    final Database db = dbClient.get();

    ConfigModel? conf = await getConfigByName(azureConfigname);
    if (conf == null) {
      return await db.insert(
        'config_tab',
        {
          'configName': azureConfigname,
          'value': jsonEncode(config.toMap()),
          'createTime': DateTime.now().second,
          'updateTime': DateTime.now().second,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      // Update the given Dog.
      return await db.update(
        'config_tab',
        {
          'value': jsonEncode(config.toMap()),
          'updateTime': DateTime.now().second,
        },
        // Ensure that the Dog has a matching id.
        where: 'id = ?',
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [conf.id],
      );
    }
  }

  Future<int> createOrUpdateThemeConfig(ThemeConfig config) async {
    final Database db = dbClient.get();
    var configName = themeConfigname;

    ConfigModel? conf = await getConfigByName(configName);
    if (conf == null) {
      return await db.insert(
        'config_tab',
        {
          'configName': configName,
          'value': jsonEncode(config.toMap()),
          'createTime': DateTime.now().second,
          'updateTime': DateTime.now().second,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      // Update the given Dog.
      return await db.update(
        'config_tab',
        {
          'value': jsonEncode(config.toMap()),
          'updateTime': DateTime.now().second,
        },
        // Ensure that the Dog has a matching id.
        where: 'id = ?',
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [conf.id],
      );
    }
  }

  Future<int> createOrUpdateDefaultAIConfig(DefaultAIConfig config) async {
    var configName = defaultAIConfigname;
    return _createOrUpdate(configName, jsonEncode(config.toMap()));
  }

  Future<int> _createOrUpdate(String configName, String value) async {
    final Database db = dbClient.get();
    ConfigModel? conf = await getConfigByName(configName);
    if (conf == null) {
      return await db.insert(
        'config_tab',
        {
          'configName': configName,
          'value': value,
          'createTime': DateTime.now().second,
          'updateTime': DateTime.now().second,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      // Update the given Dog.
      return await db.update(
        'config_tab',
        {
          'value': value,
          'updateTime': DateTime.now().second,
        },
        // Ensure that the Dog has a matching id.
        where: 'id = ?',
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [conf.id],
      );
    }
  }

  Future<ConfigModel?> getConfigByName(String name) async {
    final Database db = dbClient.get();

    final List<Map<String, dynamic>> maps = await db
        .query('config_tab', where: 'configName = ?', whereArgs: [name]);
    if (maps.length == 1) {
      return ConfigModel(
        id: maps[0]['id'],
        configName: maps[0]['configName'],
        value: maps[0]['value'],
        createTime: maps[0]['createTime'],
        updateTime: maps[0]['updateTime'],
      );
    }
    return null;
  }

  Future<List<ConfigModel>> getAllConfigs() async {
    final Database db = dbClient.get();

    final List<Map<String, dynamic>> maps = await db.query('config_tab');
    return List.generate(maps.length, (i) {
      return ConfigModel(
        id: maps[i]['id'],
        configName: maps[i]['configName'],
        value: maps[i]['value'],
        createTime: maps[i]['createTime'],
        updateTime: maps[i]['updateTime'],
      );
    });
  }

  Future<Map<String, ConfigModel>> getAllConfigsMap() async {
    List<ConfigModel> configList = await getAllConfigs();
    Map<String, ConfigModel> configMap = {};
    for (var c in configList) {
      configMap[c.configName] = c;
    }
    return configMap;
  }
}
