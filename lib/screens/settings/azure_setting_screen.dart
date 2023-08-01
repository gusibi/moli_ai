import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../constants/api_constants.dart';
import '../../constants/constants.dart';
import '../../models/config_model.dart';
import '../../providers/palm_priovider.dart';
import '../../repositories/configretion/config_repo.dart';
import '../../widgets/form/form_widget.dart';
import '../../widgets/list/setting_widget.dart';

class AzureOpenAISettingScreen extends StatefulWidget {
  const AzureOpenAISettingScreen({super.key});

  @override
  State<AzureOpenAISettingScreen> createState() =>
      _AzureOpenAISettingScreenState();
}

class _AzureOpenAISettingScreenState extends State<AzureOpenAISettingScreen> {
  late final _colorScheme = Theme.of(context).colorScheme;
  late final _buttonColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.primary);
  late final _buttonTextColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.onPrimary);

  final _formKey = GlobalKey<FormState>();

  String endPoint = PALM_BASE_URL;
  String apiKey = PALM_API_KEY;
  String apiVersion = AZURE_DEFAULT_API_VERSION;
  String modelName = AZURE_DEFAULT_MODEL_NAME;

  late TextEditingController basicUrlController;
  late TextEditingController apiKeyController;
  late TextEditingController modelNameController;
  late TextEditingController apiVersionController;

  Map<String, ConfigModel> _configMap = {};

  void _hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  void initState() {
    basicUrlController = TextEditingController(text: AZURE_BASE_URL);
    apiKeyController = TextEditingController(text: AZURE_API_KEY);
    apiVersionController =
        TextEditingController(text: AZURE_DEFAULT_API_VERSION);
    modelNameController = TextEditingController(text: AZURE_DEFAULT_MODEL_NAME);
    super.initState();
    _initConfig();
  }

  @override
  void dispose() {
    basicUrlController.dispose();
    apiKeyController.dispose();
    super.dispose();
  }

  void _initConfig() async {
    _configMap = await ConfigReop().getAllConfigsMap();
    ConfigModel? azureConf = _configMap[azureConfigname];

    log(azureConf.toString());
    if (azureConf != null) {
      final azureConfig = azureConf.toAzureConfig();
      endPoint = azureConfig.basicUrl;
      apiKey = azureConfig.apiKey;
      apiVersion = azureConfig.apiVersion;
      modelName = azureConfig.modelName;
    }
    setState(() {
      basicUrlController = TextEditingController(text: endPoint);
      apiKeyController = TextEditingController(text: apiKey);
      apiVersionController = TextEditingController(text: apiVersion);
      modelNameController = TextEditingController(text: modelName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Azure OpenAI 模型设置",
        ),
        centerTitle: true,
        elevation: 4,
      ),
      // backgroundColor: _backgroundColor,
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GestureDetector(
            onTap: () => _hideKeyboard(context),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  FormSection(title: "自定义配置", children: [
                    TextFormWidget(
                      controller: basicUrlController,
                      label: "Endpoint",
                      onSaved: (value) {
                        endPoint = value.toString();
                      },
                    ),
                    TextFormWidget(
                      controller: apiKeyController,
                      label: "API Key",
                      onSaved: (value) {
                        apiKey = value.toString();
                      },
                    ),
                  ]),
                  FormSection(title: "模型配置", children: [
                    TextFormWidget(
                      controller: modelNameController,
                      label: "模型部署名",
                      onSaved: (value) {
                        modelName = value.toString();
                      },
                    ),
                    TextFormWidget(
                      controller: apiVersionController,
                      label: "API版本",
                      onSaved: (value) {
                        apiVersion = value.toString();
                      },
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(_buttonColor),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(_buttonTextColor),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          var azureConfig = AzureOpenAIConfig(
                            basicUrl: basicUrlController.text,
                            apiKey: apiKeyController.text,
                            apiVersion: apiVersionController.text,
                            modelName: modelNameController.text,
                          );
                          _saveConfig(azureConfig);
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _saveConfig(AzureOpenAIConfig azureConf) async {
    final modelSettingProvider =
        Provider.of<AISettingProvider>(context, listen: false);
    modelSettingProvider.setAzureOpenAIConfig(azureConf);
    await ConfigReop().createOrUpdateAzureOpenAIConfig(azureConf);
  }
}
