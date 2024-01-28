import 'package:moli_ai/core/usecases/usecase.dart';
import 'package:moli_ai/domain/entities/conversation_entity.dart';
import 'package:moli_ai/domain/inputs/ai_service_input.dart';
import 'package:moli_ai/domain/inputs/chat_info_input.dart';
import 'package:moli_ai/domain/repositories/config_repo.dart';

class AIServiceGetUseCase implements UseCase<ChatEntity, AIServiceInput> {
  final ConfigRepository repository;

  AIServiceGetUseCase(this.repository);

  @override
  Future<ChatEntity> call(AIServiceInput input) async {
    return repository.chatList(listInput);
  }
}
