// 一个 usecase 是一个单独的业务操作
import 'package:moli_ai/core/usecases/usecase.dart';
import 'package:moli_ai/domain/entities/conversation_entity.dart';
import 'package:moli_ai/domain/inputs/chat_info_input.dart';
import 'package:moli_ai/domain/repositories/chat_repo.dart';

class ChatCreateUseCase implements UseCase<ChatEntity, ChatCreateInput> {
  final ChatRepository repository;

  ChatCreateUseCase(this.repository);

  @override
  Future<ChatEntity> call(ChatCreateInput input) async {
    return repository.chatCreate(input);
  }
}
