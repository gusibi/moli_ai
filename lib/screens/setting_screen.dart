import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/api_constants.dart';
import '../constants/constants.dart';
import '../models/config_model.dart';
import '../repositories/configretion/config_repo.dart';
import '../widgets/form/models_choice_widget.dart';
import '../widgets/form/form_widget.dart';
import '../widgets/setting_widget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late final _colorScheme = Theme.of(context).colorScheme;

  late final _backgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);

  final _formKey = GlobalKey<FormState>();

  String basicUrl = BASE_URL;
  String apiKey = API_KEY;
  String modelName = DEFAULT_MODEL;

  late TextEditingController basicUrlController;
  late TextEditingController apiKeyController;
  final palmModel = ValueNotifier<PalmModels>(PalmModels.textModel);

  Map<String, ConfigModel> _configMap = {};

  void _hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  void initState() {
    basicUrlController = TextEditingController(text: BASE_URL);
    apiKeyController = TextEditingController(text: API_KEY);
    super.initState();
    _initPalmConfig();
  }

  @override
  void dispose() {
    basicUrlController.dispose();
    apiKeyController.dispose();
    super.dispose();
  }

  void _initPalmConfig() async {
    _configMap = await ConfigReop().getAllConfigsMap();
    ConfigModel? conf = _configMap[palmConfigname];

    if (conf != null) {
      final palmConfig = conf.toPalmConfig();
      basicUrl = palmConfig.basicUrl;
      apiKey = palmConfig.apiKey;
      modelName = palmConfig.modelName;
    }
    setState(() {
      basicUrlController = TextEditingController(text: basicUrl);
      apiKeyController = TextEditingController(text: apiKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Setting",
          style: TextStyle(color: _colorScheme.onSecondary),
        ),
        centerTitle: true,
        backgroundColor: _colorScheme.primary,
        shadowColor: Colors.white,
        elevation: 4,
      ),
      backgroundColor: _backgroundColor,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: GestureDetector(
            onTap: () => _hideKeyboard(context),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 8),
                  SingleSection(title: "自定义配置", children: [
                    BaseURLFormWidget(
                      controller: basicUrlController,
                    ),
                    ApiKeyFormWidget(
                      controller: apiKeyController,
                    ),
                  ]),
                  SingleSection(title: "选择模型", children: [
                    PalmModelRadioListTile(notifier: palmModel),
                  ]),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          _saveConfig(PalmConfig(
                              basicUrl: basicUrlController.text,
                              apiKey: apiKeyController.text,
                              modelName: palmModelsMap[palmModel.value]!));
                          // do something with _baseUrl and _apiKey
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

  _saveConfig(PalmConfig conf) async {
    await ConfigReop().createOrUpdatePalmConfig(conf);
  }
}
