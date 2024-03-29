// 一个 usecase 是一个单独的业务操作
import 'package:moli_ai/core/usecases/usecase.dart';
import 'package:moli_ai/domain/inputs/chat_info_input.dart';
import 'package:moli_ai/domain/repositories/chat_repo.dart';

class ChatDeleteUseCase implements UseCase<int, ChatDeleteInput> {
  final ChatRepository repository;

  ChatDeleteUseCase(this.repository);

  @override
  Future<int> call(ChatDeleteInput input) async {
    return repository.chatDelete(input);
  }
}
