import 'package:moli_ai/data/datasources/sqlite_chat_message_source.dart';
import 'package:moli_ai/data/models/conversation_model.dart';
import 'package:moli_ai/domain/entities/conversation_entity.dart';
import 'package:moli_ai/domain/inputs/chat_messages_input.dart';
import 'package:moli_ai/domain/repositories/chat_messages_repo.dart';

class ChatMessageRepoImpl implements ChatMessagesRepository {
  final ConversationMessageDBSource _sqliteStorage;

  ChatMessageRepoImpl(this._sqliteStorage);

  @override
  Future<List<ChatMessageEntity>> messageList(
      ChatMessageListInput input) async {
    List<ConversationMessageModel> list =
        await _sqliteStorage.getMessages(input.chatId, 0);
    return List.generate(list.length, (i) {
      ConversationMessageModel message = list[i];
      return ChatMessageEntity(
          id: message.id,
          conversationId: message.conversationId,
          role: message.role,
          replyId: message.replyId,
          vote: message.vote,
          ctime: message.ctime,
          message: message.message);
    });
  }

  @override
  Future<ChatMessageEntity> messageCreate(ChatMessageCreateInput input) async {
    ConversationMessageModel messageModel = await _sqliteStorage
        .createMessageWithRole(input.role, input.message, input.chatId, 0);
    return ChatMessageEntity(
        id: messageModel.id,
        conversationId: messageModel.conversationId,
        role: messageModel.role,
        replyId: messageModel.replyId,
        vote: messageModel.vote,
        ctime: messageModel.ctime,
        message: messageModel.message);
  }
}
