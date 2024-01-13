import 'package:moli_ai/domain/entities/conversation_entity.dart';
import 'package:moli_ai/domain/inputs/chat_messages_input.dart';

abstract class ChatMessagesRepository {
  Future<List<ChatMessageEntity>> messageList(
      ChatMessageListInput input) async {
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

  Future<ChatMessageEntity> messageCreate(ChatMessageCreateInput input) async {
    // TODO: implement chatDetail
    throw UnimplementedError();
  }
}
