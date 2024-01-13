import 'package:moli_ai/domain/entities/conversation_entity.dart';

class ChatCompletionInput {
  final ChatEntity chatInfo;
  final List<ChatMessageEntity> messageList;

  ChatCompletionInput({required this.chatInfo, required this.messageList});
}
