import 'package:moli_ai/models/config_model.dart';

// ignore: non_constant_identifier_names
String PALM_BASE_URL = "https://generativelanguage.googleapis.com/v1beta2";
// ignore: non_constant_identifier_names
String PALM_API_KEY = "YOUR API KEY";
// ignore: non_constant_identifier_names
String PALM_DEFAULT_MODEL = "text-bison-001";

final PalmConfig defaultPalmConfig = PalmConfig(
  basicUrl: PALM_BASE_URL,
  apiKey: PALM_API_KEY,
  modelName: PALM_DEFAULT_MODEL,
);

// ignore: non_constant_identifier_names
String AZURE_BASE_URL = "https://docs-test-001.openai.azure.com";
// ignore: non_constant_identifier_names
String AZURE_API_KEY = "YOUR API KEY";
// ignore: non_constant_identifier_names
String AZURE_DEFAULT_API_VERSION = "2023-03-15-preview";
// ignore: non_constant_identifier_names
String AZURE_DEFAULT_MODEL_NAME = "GPT35";

final AzureOpenAIConfig defaultAzureOpenAIConfig = AzureOpenAIConfig(
  basicUrl: AZURE_BASE_URL,
  apiKey: AZURE_API_KEY,
  modelName: AZURE_DEFAULT_MODEL_NAME,
  apiVersion: AZURE_DEFAULT_API_VERSION,
);
