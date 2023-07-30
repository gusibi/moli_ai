import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moli_ai/screens/settings/palm_screen.dart';
import 'package:provider/provider.dart';

import '../../constants/api_constants.dart';
import '../../constants/color_constants.dart';
import '../../constants/constants.dart';
import '../../models/config_model.dart';
import '../../providers/default_privider.dart';
import '../../repositories/configretion/config_repo.dart';
import '../../widgets/form/themes_choice_widget.dart';
import '../../widgets/list/setting_list_widget.dart';
import '../../widgets/list/setting_widget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
    _saveConfig();
  }

  void handleThemeSelected(String value) {
    setState(() {
      selectedTheme = value;
    });
    _saveConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "设置",
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
                shrinkWrap: false,
                children: [
                  ListTileSection(title: "模型配置", children: [
                    SettingListTile(
                      title: "Google Palm",
                      icon: Icons.park_outlined,
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        _navigateToPalmSettingScreen();
                      },
                    ),
                    // Divider(),
                    SettingListTile(
                      title: "OpenAI",
                      icon: Icons.chat_bubble_outline,
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                    // Divider(),
                    SettingListTile(
                      title: "Auzre OpenAI",
                      icon: Icons.api_outlined,
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: 8),
                  FormSection(title: "主题选择", children: [
                    DarkModeDropDownWidget(
                        onOptionSelected: handleDarkModeSelected,
                        selectedOption: selectedDarkMode),
                    ThemesDropDownWidget(
                      onOptionSelected: handleThemeSelected,
                      selectedOption: selectedTheme,
                    ),
                  ]),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToPalmSettingScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PalmSettingScreen(),
      ),
    );
  }

  _saveConfig() async {
    await ConfigReop().createOrUpdateThemeConfig(ThemeConfig(
      darkMode: selectedDarkMode,
      themeName: selectedTheme,
    ));
    _updateThem(selectedDarkMode, selectedTheme);
  }

  _updateThem(String selectedDarkMode, selectedTheme) {
    final defaultProvider =
        Provider.of<DefaultSettingProvider>(context, listen: false);
    var isDarkMode = defaultProvider.isDark;
    if (selectedDarkMode == darkModeDark) {
      isDarkMode = true;
    } else if (selectedDarkMode == darkModeLight) {
      isDarkMode = false;
    } else {
      isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    defaultProvider.setIsDark(isDarkMode);
    defaultProvider.setDarkMode(selectedDarkMode);
    defaultProvider.setThemeName(selectedTheme);
  }
}