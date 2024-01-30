import 'package:moli_ai/domain/entities/conversation_entity.dart';

class ChatMessageOutput {
  int id;
  String message;
  final int conversationId;
  final String role;
  final int replyId;
  final int vote;
  final String ctime;

  ChatMessageOutput({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.replyId,
    required this.vote,
    required this.ctime,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversationId': conversationId,
      'role': role,
      "message": message,
      "replyId": replyId,
      "vote": vote,
      "ctime": ctime
    };
  }

  ChatMessageOutput copy() {
    return ChatMessageOutput(
      id: id,
      conversationId: conversationId,
      role: role,
      message: message,
      replyId: replyId,
      vote: vote,
      ctime: ctime,
    );
  }

  static ChatMessageOutput fromChatMessageEntity(ChatMessageEntity message) {
    return ChatMessageOutput(
        id: message.id,
        conversationId: message.conversationId,
        role: message.role,
        replyId: message.replyId,
        vote: message.vote,
        ctime: message.ctime,
        message: message.message);
  }
}

class ChatCompletionMessageOutput {
  final ChatMessageOutput message;

  ChatCompletionMessageOutput({required this.message});
}
