import 'package:moli_ai/domain/inputs/ai_chat_input.dart';
import 'package:moli_ai/domain/outputs.dart/ai_chat_output.dart';

abstract class AiChatRepository {
  Future<AIChatCompletionOutput> completion(AIChatCompletionInput input) async {
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
