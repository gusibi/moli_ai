import 'package:dartz/dartz.dart';
import 'package:moli_ai/data/models/error_resp.dart';
import 'package:moli_ai/data/services/azure_openai_service.dart';
import 'package:moli_ai/domain/dto/azure_openai_dto.dart';
import 'package:moli_ai/domain/inputs/ai_chat_input.dart';
import 'package:moli_ai/domain/inputs/ai_config_input.dart';
import 'package:moli_ai/domain/outputs/ai_chat_output.dart';
import 'package:moli_ai/domain/repositories/ai_chat_repo.dart';

AIChatRepository newAzureGPTRepoImpl(AIApiConfigInput config) =>
    AzureGPTRepoImpl(AzureOpenAIApiService(apiConfig: config));

class AzureGPTRepoImpl implements AIChatRepository {
  final AzureOpenAIApiService _azureOpenAIApi;

  AzureGPTRepoImpl(this._azureOpenAIApi);

  @override
  Future<AIChatCompletionOutput> completion(AIChatCompletionInput input) async {
    AzureOpenAIMessageReq req = azureOpenAIApiMessageReqFromReq(input);
    final response = await _azureOpenAIApi.completions(req);
    return azureOpenAIRespToAIChatCompletionOutput(response);
  }
}
