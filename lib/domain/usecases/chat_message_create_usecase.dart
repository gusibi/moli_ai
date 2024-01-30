// 一个 usecase 是一个单独的业务操作
import 'package:moli_ai/core/usecases/usecase.dart';
import 'package:moli_ai/domain/entities/conversation_entity.dart';
import 'package:moli_ai/domain/inputs/chat_messages_input.dart';
import 'package:moli_ai/domain/outputs/chat_message_output.dart';
import 'package:moli_ai/domain/repositories/chat_messages_repo.dart';

class ChatMessageCreateUseCase
    implements UseCase<ChatMessageOutput, ChatMessageCreateInput> {
  final ChatMessagesRepository repository;

  ChatMessageCreateUseCase(this.repository);

  @override
  Future<ChatMessageOutput> call(ChatMessageCreateInput input) async {
    ChatMessageEntity message = await repository.messageCreate(input);
    return ChatMessageOutput.fromChatMessageEntity(message);
  }
}
