// 一个 usecase 是一个单独的业务操作
import 'package:moli_ai/core/usecases/usecase.dart';
import 'package:moli_ai/domain/entities/conversation_entity.dart';
import 'package:moli_ai/domain/inputs/chat_messages_input.dart';
import 'package:moli_ai/domain/repositories/chat_messages_repo.dart';

class GetChatMessagesUseCase
    implements UseCase<List<ChatMessageEntity>, ChatMessageListInput> {
  final ChatMessagesRepository repository;

  GetChatMessagesUseCase(this.repository);

  @override
  Future<List<ChatMessageEntity>> call(ChatMessageListInput listInput) async {
    return repository.messageList(listInput);
  }
}
