import 'package:dartz/dartz.dart';
import 'package:moli_ai/domain/entities/conversation_entity.dart';
import 'package:moli_ai/domain/inputs/chat_info_input.dart';

abstract class ChatRepository {
  Future<List<ChatEntity>> chatList(ChatListInput input) async {
    // TODO: implement chatList
    throw UnimplementedError();
  }

  Future<ChatEntity> chatDetail(ChatDetailInput input) async {
    // TODO: implement chatDetail
    throw UnimplementedError();
  }

  Future<int> chatDelete(ChatDeleteInput input) async {
    // TODO: implement chatDetail
    throw UnimplementedError();
  }

  Future<ChatEntity> chatCreate(ChatCreateInput input) async {
    // TODO: implement chatDetail
    throw UnimplementedError();
  }
}
