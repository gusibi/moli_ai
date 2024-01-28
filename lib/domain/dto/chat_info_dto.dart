import 'package:moli_ai/domain/entities/conversation_entity.dart';
import 'package:moli_ai/domain/outputs/chat_info_output.dart';

class ChatDetailDto {
  final ChatEntity chatInfo;
  final List<ChatMessageEntity> messageList;

  ChatDetailDto({required this.chatInfo, required this.messageList});
}

ChatInfoOutput chatInfoOutputFromEntity(ChatEntity entity) {
  return ChatInfoOutput(
      id: entity.id,
      title: entity.title,
      prompt: entity.prompt,
      convType: entity.convType,
      desc: entity.desc,
      icon: entity.icon,
      rank: entity.rank,
      modelName: entity.modelName,
      lastTime: entity.lastTime);
}
