import 'package:moli_ai/data/datasources/sqlite_config_source.dart';
import 'package:moli_ai/data/models/config_model.dart';
import 'package:moli_ai/domain/repositories/config_repo.dart';
import 'package:moli_ai/domain/outputs/config_output.dart';

class ConfigRepoImpl implements ConfigRepository {
  final ConfigDBSource _sqliteStorage;
  ConfigRepoImpl(this._sqliteStorage);

  @override
  Future<ConfigsOutput> getAllConfigsMap() async {
    Map<String, ConfigModel> configMap =
        await _sqliteStorage.getAllConfigsMap();
    return ConfigsOutput(configMap: configMap);
  }
}
