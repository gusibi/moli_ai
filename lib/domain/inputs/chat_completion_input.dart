import 'package:moli_ai/domain/entities/conversation_entity.dart';
import 'package:moli_ai/domain/outputs/chat_message_output.dart';

class ChatCompletionInput {
  final ChatEntity chatInfo;
  final List<ChatMessageOutput> messageList;

  ChatCompletionInput({required this.chatInfo, required this.messageList});
}
