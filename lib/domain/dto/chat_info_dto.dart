import 'package:moli_ai/domain/entities/conversation_entity.dart';

class ChatDetailDto {
  final ChatEntity chatInfo;
  final List<ChatMessageEntity> messageList;

  ChatDetailDto({required this.chatInfo, required this.messageList});
}
