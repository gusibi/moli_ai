// 一个 usecase 是一个单独的业务操作
import 'package:moli_ai/core/constants/constants.dart';
import 'package:moli_ai/core/usecases/usecase.dart';
import 'package:moli_ai/domain/entities/conversation_entity.dart';
import 'package:moli_ai/domain/inputs/ai_chat_input.dart';
import 'package:moli_ai/domain/inputs/chat_completion_input.dart';
import 'package:moli_ai/domain/outputs.dart/ai_chat_output.dart';
import 'package:moli_ai/domain/repositories/ai_chat_repo.dart';

class AiChatCompletionUseCase
    implements UseCase<AIChatCompletionOutput, ChatCompletionInput> {
  final AiChatRepository repository;

  AiChatCompletionUseCase(this.repository);

  @override
  Future<AIChatCompletionOutput> call(ChatCompletionInput input) async {
    List<AIChatCompletionMessage> messages = getLastNContents(input);
    AIChatCompletionInput aiInput = AIChatCompletionInput(
        model: input.chatInfo.modelName, messages: messages);
    return repository.completion(aiInput);
  }

  List<AIChatCompletionMessage> getLastNContents(ChatCompletionInput input) {
    List<ChatMessageEntity> chatMessageList = input.messageList;
    AIChatCompletionMessage? lastMessage;
    List<AIChatCompletionMessage> messages = [];
    int count = 0;
    for (var i = chatMessageList.length - 1; i >= 0; i--) {
      ChatMessageEntity chatMessage = chatMessageList[i].copy();
      if (chatMessage.role == roleContext) {
        break;
      }
      if (chatMessageList[i].role != roleSys) {
        String role = chatMessageList[i].role;
        if (lastMessage != null && role == lastMessage.role) {
          lastMessage.content =
              "${chatMessage.message}\n${lastMessage.content}";
          messages[0] = lastMessage;
        } else {
          AIChatCompletionMessage aiMessage = AIChatCompletionMessage(
              content: chatMessage.message, role: chatMessage.role);
          lastMessage = aiMessage;
          messages.insert(0, aiMessage); // add new content for new role
        }
        count += 1;
      }
      if (count >= input.chatInfo.memeoryCount &&
          messages[0].role == roleUser) {
        break;
      }
    }
    return messages;
  }
}
