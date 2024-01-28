import 'package:moli_ai/domain/outputs/config_output.dart';

abstract class ConfigRepository {
  Future<ConfigsOutput> getAllConfigsMap() async {
    // TODO: implement chatList
    throw UnimplementedError();
  }

  // Future<ChatEntity> chatDetail(ChatDetailInput input) async {
  //   // TODO: implement chatDetail
  //   throw UnimplementedError();
  // }

  // Future<int> chatDelete(ChatDeleteInput input) async {
  //   // TODO: implement chatDetail
  //   throw UnimplementedError();
  // }

  // Future<ChatEntity> chatCreate(ChatCreateInput input) async {
  //   // TODO: implement chatDetail
  //   throw UnimplementedError();
  // }
}
