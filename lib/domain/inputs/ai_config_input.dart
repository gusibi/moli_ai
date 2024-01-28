class AIApiConfigInput {
  final String prompt;
  final String modelName;
  final String apiKey;
  final String basicUrl;
  String? apiVersion;

  AIApiConfigInput({
    required this.apiKey,
    required this.basicUrl,
    required this.prompt,
    required this.modelName,
    this.apiVersion,
  });
}
