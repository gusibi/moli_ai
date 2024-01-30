// 一个 usecase 是一个单独的业务操作
import 'package:moli_ai/core/usecases/usecase.dart';
import 'package:moli_ai/domain/entities/conversation_entity.dart';
import 'package:moli_ai/domain/inputs/chat_messages_input.dart';
import 'package:moli_ai/domain/outputs/chat_message_output.dart';
import 'package:moli_ai/domain/repositories/chat_messages_repo.dart';

class GetChatMessagesUseCase
    implements UseCase<List<ChatMessageOutput>, ChatMessageListInput> {
  final ChatMessagesRepository repository;

  GetChatMessagesUseCase(this.repository);

  @override
  Future<List<ChatMessageOutput>> call(ChatMessageListInput listInput) async {
    List<ChatMessageEntity> messageList =
        await repository.messageList(listInput);
    List<ChatMessageOutput> results = [];
    for (var i = 0; i < messageList.length; i++) {
      ChatMessageEntity message = messageList[i];
      results.add(ChatMessageOutput.fromChatMessageEntity(message));
    }
    return results;
  }
}
