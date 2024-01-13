import 'package:moli_ai/data/datasources/sqlite_chat_source.dart';
import 'package:moli_ai/domain/entities/conversation_entity.dart';
import 'package:moli_ai/domain/inputs/chat_info_input.dart';
import 'package:moli_ai/domain/repositories/chat_repo.dart';

import '../../models/conversation_model.dart';

class ChatRepoImpl implements ChatRepository {
  final ConversationDBSource _sqliteStorage;

  ChatRepoImpl(this._sqliteStorage);

  @override
  Future<List<ChatEntity>> chatList(ChatListInput input) async {
    List<ChatModel> list = await _sqliteStorage.getAllChatConversations();
    return List.generate(list.length, (i) {
      return ChatEntity(
        id: list[i].id,
        title: list[i].title,
        prompt: list[i].prompt,
        convType: list[i].convType,
        desc: list[i].desc,
        icon: list[i].icon,
        rank: list[i].rank,
        modelName: list[i].modelName,
        lastTime: list[i].lastTime,
      );
    });
  }

  @override
  Future<ChatEntity> chatDetail(ChatDetailInput input) async {
    ChatModel? detail = await _sqliteStorage.getConversationById(input.chatId);
    return ChatEntity(
        id: detail!.id,
        title: detail.title,
        prompt: detail.prompt,
        convType: detail.convType,
        desc: detail.desc,
        icon: detail.icon,
        rank: detail.rank,
        modelName: detail.modelName,
        lastTime: detail.lastTime);
  }

  @override
  Future<int> chatDelete(ChatDeleteInput input) async {
    return await _sqliteStorage.deleteConversationById(input.chatId);
  }

  @override
  Future<ChatEntity> chatCreate(ChatCreateInput input) async {
    ChatModel model = ChatModel(
        id: 0,
        title: input.title,
        prompt: input.prompt,
        convType: input.convType,
        desc: input.desc,
        icon: input.icon,
        modelName: input.modelName,
        rank: 0,
        lastTime: 0);
    int id = await _sqliteStorage.createConversation(model);
    model.id = id;
    return ChatEntity(
        id: id,
        title: model.title,
        prompt: model.prompt,
        convType: model.convType,
        desc: model.desc,
        icon: model.icon,
        rank: model.rank,
        modelName: model.modelName,
        lastTime: model.lastTime);
  }
}
