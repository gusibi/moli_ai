import 'package:dartz/dartz.dart';
import 'package:moli_ai/core/usecases/usecase.dart';
import 'package:moli_ai/domain/entities/conversation_entity.dart';
import 'package:moli_ai/domain/inputs/conversation_input.dart';
import 'package:moli_ai/domain/repositories/conversation_repo.dart';

// 一个 usecase 是一个单独的业务操作
class GetChatListUseCase implements UseCase<List<ChatEntity>, ChatListInput> {
  final ChatRepository repository;

  GetChatListUseCase(this.repository);

  @override
  Future<List<ChatEntity>> call(ChatListInput listInput) async {
    return repository.chatList(listInput);
  }
}
