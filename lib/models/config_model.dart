import 'dart:convert';

class PalmConfig {
  String basicUrl;
  String apiKey;
  String modelName;

  PalmConfig({
    required this.basicUrl,
    required this.apiKey,
    required this.modelName,
  });

  Map<String, dynamic> toMap() {
    return {
      'basicUrl': basicUrl,
      'apiKey': apiKey,
      'modelName': modelName,
    };
  }

  factory PalmConfig.fromJson(Map<dynamic, dynamic> json) => PalmConfig(
        basicUrl: json['basicUrl'] as String,
        apiKey: json['apiKey'] as String,
        modelName: json['modelName'] as String,
      );
}

class ConfigModel {
  final int id;
  final String configName;
  final String value;
  final int createTime;
  final int updateTime;

  ConfigModel({
    required this.id,
    required this.configName,
    required this.value,
    required this.createTime,
    required this.updateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'configName': configName,
      'value': value,
      'createTime': createTime,
      'updateTime': updateTime,
    };
  }

  PalmConfig toPalmConfig() {
    Map config = jsonDecode(value);
    return PalmConfig.fromJson(config);
  }
}
