// 一个 usecase 是一个单独的业务操作
import 'package:dartz/dartz.dart';
import 'package:moli_ai/core/constants/constants.dart';
import 'package:moli_ai/core/usecases/usecase.dart';
import 'package:moli_ai/core/utils/time.dart';
import 'package:moli_ai/data/models/config_model.dart';
import 'package:moli_ai/data/models/error_resp.dart';
import 'package:moli_ai/data/repositories/ai_chat/azure_gpt_repo_impl.dart';
import 'package:moli_ai/data/repositories/ai_chat/google_gemini_repo_impl.dart';
import 'package:moli_ai/domain/entities/conversation_entity.dart';
import 'package:moli_ai/domain/inputs/ai_chat_input.dart';
import 'package:moli_ai/domain/inputs/ai_config_input.dart';
import 'package:moli_ai/domain/inputs/chat_completion_input.dart';
import 'package:moli_ai/domain/outputs/ai_chat_output.dart';
import 'package:moli_ai/domain/outputs/chat_message_output.dart';
import 'package:moli_ai/domain/outputs/config_output.dart';
import 'package:moli_ai/domain/repositories/ai_chat_repo.dart';
import 'package:moli_ai/domain/repositories/config_repo.dart';

class AiChatCompletionUseCase
    implements UseCase<AIChatCompletionOutput, ChatCompletionInput> {
  final ConfigRepository configRepository;
  AIChatRepository? _aiServiceRepo;

  AiChatCompletionUseCase(this.configRepository);

  Future<Either<ErrorResp, AIChatRepository>> initAIServiceRepo(
      ChatCompletionInput input) async {
    if (_aiServiceRepo != null) {
      return Right(_aiServiceRepo!);
    }
    ConfigsOutput configs = await configRepository.getAllConfigsMap();

    if (isGemini(input.chatInfo.modelName) ||
        isPalmGPT(input.chatInfo.modelName)) {
      ConfigModel? conf = configs.configMap[palmConfigname];
      if (conf != null) {
        final palmConfig = conf.toPalmConfig();
        AIChatRepository aiServiceRepo =
            newGoogleGeminiRepoImpl(AIApiConfigInput(
          basicUrl: palmConfig.basicUrl,
          apiKey: palmConfig.apiKey,
          prompt: input.chatInfo.prompt,
          modelName: palmConfig.modelName,
        ));
        return Right(aiServiceRepo);
      }
    }
    if (isAzureGPT(input.chatInfo.modelName)) {
      ConfigModel? conf = configs.configMap[azureConfigname];
      if (conf != null) {
        final azureConfig = conf.toAzureConfig();
        AIChatRepository aiServiceRepo = newAzureGPTRepoImpl(AIApiConfigInput(
          basicUrl: azureConfig.basicUrl,
          apiKey: azureConfig.apiKey,
          prompt: input.chatInfo.prompt,
          modelName: azureConfig.modelName,
        ));
        return Right(aiServiceRepo);
      }
    }
    return Left(
        ErrorResp(code: -1, message: "ai api not support", status: "error"));
  }

  @override
  Future<AIChatCompletionOutput> call(ChatCompletionInput input) async {
    List<AIChatCompletionMessage> messages = getLastNContents(input);
    AIChatCompletionInput aiInput = AIChatCompletionInput(
        model: input.chatInfo.modelName, messages: messages);
    Either<ErrorResp, AIChatRepository> result = await initAIServiceRepo(input);
    bool initSuccess = false;
    late AIChatRepository aiChatRepo;
    result.fold((error) {
      // pass
    }, (repo) {
      initSuccess = true;
      aiChatRepo = repo;
    });
    if (initSuccess) {
      return aiChatRepo.completion(aiInput);
    }

    List<ChoiceOutput> choices = [
      ChoiceOutput(
          index: 2,
          message: MessageOutput(role: roleSys, content: "unknow error"),
          finishReason: "sysError")
    ];
    return AIChatCompletionOutput(
        id: "sysError",
        object: "sysError",
        created: timestampNow(),
        model: input.chatInfo.modelName,
        systemFingerprint: "sysError",
        choices: choices);
  }

  List<AIChatCompletionMessage> getLastNContents(ChatCompletionInput input) {
    List<ChatMessageOutput> chatMessageList = input.messageList;
    AIChatCompletionMessage? lastMessage;
    List<AIChatCompletionMessage> messages = [];
    int count = 0;
    for (var i = chatMessageList.length - 1; i >= 0; i--) {
      ChatMessageOutput chatMessage = chatMessageList[i].copy();
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
