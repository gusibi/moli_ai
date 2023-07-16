import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/api_constants.dart';
import '../constants/color_constants.dart';
import '../constants/constants.dart';
import '../models/config_model.dart';
import '../repositories/configretion/config_repo.dart';
import '../widgets/form/models_choice_widget.dart';
import '../widgets/form/form_widget.dart';
import '../widgets/form/themes_choice_widget.dart';
import '../widgets/setting_widget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late final _colorScheme = Theme.of(context).colorScheme;
  late final _backgroundColor = _colorScheme.background;
  late final _buttonColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.primary);
  late final _buttonTextColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.onPrimary);

  final _formKey = GlobalKey<FormState>();

  String basicUrl = BASE_URL;
  String apiKey = API_KEY;
  String modelName = DEFAULT_MODEL;
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
    basicUrlController = TextEditingController(text: BASE_URL);
    apiKeyController = TextEditingController(text: API_KEY);
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
          "Setting",
        ),
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: _backgroundColor,
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GestureDetector(
            onTap: () => _hideKeyboard(context),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
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
                  SingleSection(title: "主题选择", children: [
                    DarkModeDropDownWidget(
                        onOptionSelected: handleDarkModeSelected,
                        selectedOption: selectedDarkMode),
                    ThemesDropDownWidget(
                      onOptionSelected: handleThemeSelected,
                      selectedOption: selectedTheme,
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
                          log(themeDarkMode.value.name);
                          log(selectedTheme);
                          _saveConfig(
                              PalmConfig(
                                  basicUrl: basicUrlController.text,
                                  apiKey: apiKeyController.text,
                                  modelName: palmModelsMap[palmModel.value]!),
                              ThemeConfig(
                                darkMode: selectedDarkMode,
                                themeName: selectedTheme,
                              ));
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

  _saveConfig(PalmConfig palmConf, ThemeConfig themeConfig) async {
    await ConfigReop().createOrUpdatePalmConfig(palmConf);
    await ConfigReop().createOrUpdateThemeConfig(themeConfig);
  }
}
