import 'package:moli_ai/core/constants/constants.dart';
import 'package:moli_ai/core/usecases/usecase.dart';
import 'package:moli_ai/domain/entities/conversation_entity.dart';
import 'package:moli_ai/domain/inputs/chat_completion_input.dart';
import 'package:moli_ai/domain/inputs/chat_messages_input.dart';
import 'package:moli_ai/domain/outputs/ai_chat_output.dart';
import 'package:moli_ai/domain/outputs/chat_message_output.dart';
import 'package:moli_ai/domain/repositories/chat_messages_repo.dart';
import 'package:moli_ai/domain/usecases/ai_chat_completion_usecase.dart';

// 一个 usecase 是一个单独的业务操作
class ChatCompletionUseCase
    implements UseCase<ChatCompletionMessageOutput, ChatCompletionInput> {
  final ChatMessagesRepository repository;
  final AiChatCompletionUseCase _aiChatCompletionUseCase;

  ChatCompletionUseCase(this.repository, this._aiChatCompletionUseCase);

  @override
  Future<ChatCompletionMessageOutput> call(ChatCompletionInput input) async {
    AIChatCompletionOutput result = await _aiChatCompletionUseCase.call(input);
    late ChatMessageEntity message;
    if (result.choices.isNotEmpty) {
      message = await repository.messageCreate(ChatMessageCreateInput(
          chatId: input.chatInfo.id,
          message: result.choices[0].message.content,
          role: result.choices[0].message.role));
    } else {
      message = await repository.messageCreate(ChatMessageCreateInput(
          chatId: input.chatInfo.id, message: "no response", role: roleSys));
    }
    return ChatCompletionMessageOutput(
        message: ChatMessageOutput(
            conversationId: message.conversationId,
            id: message.id,
            role: message.role,
            replyId: message.replyId,
            vote: message.vote,
            ctime: message.ctime,
            message: message.message));
  }
}
