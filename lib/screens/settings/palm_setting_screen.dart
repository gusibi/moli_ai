import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/api_constants.dart';
import '../../constants/color_constants.dart';
import '../../constants/constants.dart';
import '../../models/config_model.dart';
import '../../repositories/configretion/config_repo.dart';
import '../../widgets/form/models_choice_widget.dart';
import '../../widgets/form/form_widget.dart';
import '../../widgets/list/setting_widget.dart';

class PalmSettingScreen extends StatefulWidget {
  const PalmSettingScreen({super.key});

  @override
  State<PalmSettingScreen> createState() => _PlamSettingScreenState();
}

class _PlamSettingScreenState extends State<PalmSettingScreen> {
  late final _colorScheme = Theme.of(context).colorScheme;
  late final _buttonColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.primary);
  late final _buttonTextColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.onPrimary);

  final _formKey = GlobalKey<FormState>();

  String basicUrl = PALM_BASE_URL;
  String apiKey = PALM_API_KEY;
  String modelName = PALM_DEFAULT_MODEL;
  String selectedTheme = defaultTheme;
  String selectedDarkMode = defaultDarkMode;

  late TextEditingController basicUrlController;
  late TextEditingController apiKeyController;
  final palmModel = ValueNotifier<PalmModels>(PalmModels.textModel);
  final themeDarkMode = ValueNotifier<DarkModes>(DarkModes.darkModeSystem);

  Map<String, ConfigModel> _configMap = {};

  void _hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  void initState() {
    basicUrlController = TextEditingController(text: PALM_BASE_URL);
    apiKeyController = TextEditingController(text: PALM_API_KEY);
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
    ConfigModel? palmConf = _configMap[palmConfigname];

    if (palmConf != null) {
      final palmConfig = palmConf.toPalmConfig();
      basicUrl = palmConfig.basicUrl;
      apiKey = palmConfig.apiKey;
      modelName = palmConfig.modelName;
    }
    setState(() {
      basicUrlController = TextEditingController(text: basicUrl);
      apiKeyController = TextEditingController(text: apiKey);
    });

    ConfigModel? themeConf = _configMap[themeConfigname];
    if (themeConf != null) {
      final themeConfig = themeConf.toThemeConfig();
      setState(() {
        selectedTheme = themeConfig.themeName;
        selectedDarkMode = themeConfig.darkMode;
      });
    }
  }

  void handleDarkModeSelected(String value) {
    setState(() {
      selectedDarkMode = value;
    });
  }

  void handleThemeSelected(String value) {
    setState(() {
      selectedTheme = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Palm 模型设置",
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
                    BaseURLFormWidget(
                      controller: basicUrlController,
                    ),
                    ApiKeyFormWidget(
                      controller: apiKeyController,
                    ),
                  ]),
                  FormSection(title: "选择模型", children: [
                    PalmModelRadioListTile(notifier: palmModel),
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
                          log(selectedDarkMode);
                          log(selectedTheme);
                          _saveConfig(
                            PalmConfig(
                                basicUrl: basicUrlController.text,
                                apiKey: apiKeyController.text,
                                modelName: palmModelsMap[palmModel.value]!),
                          );
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

  _saveConfig(PalmConfig palmConf) async {
    await ConfigReop().createOrUpdatePalmConfig(palmConf);
  }
}
