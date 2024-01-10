import 'package:dartz/dartz.dart';
import 'package:moli_ai/domain/entities/conversation_entity.dart';
import 'package:moli_ai/domain/inputs/conversation_input.dart';

abstract class ConversationRepository {
  Future<List<ConversationEntity>> conversationList(
      ConversationListInput input) async {
    // TODO: implement conversationList
    throw UnimplementedError();
  }

  Future<ConversationEntity> conversationDetail(int cid) async {
    // TODO: implement conversationList
    throw UnimplementedError();
  }
}
