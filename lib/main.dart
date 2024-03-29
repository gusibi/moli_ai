import 'dart:developer';
import 'dart:io';
import 'package:moli_ai/data/datasources/sqlite_chat_source.dart';
import 'package:moli_ai/data/providers/conversation_privider.dart';
import 'package:moli_ai/data/repositories/chat/chat_repo_impl.dart';
import 'package:moli_ai/domain/usecases/chat_delete_usecase.dart';
import 'package:moli_ai/domain/usecases/chat_get_usecase.dart';
import 'package:window_manager/window_manager.dart';
// import 'package:window_size/window_size.dart';

import 'package:flutter/material.dart';
import 'package:moli_ai/core/animations/bar_animations.dart';
import 'package:moli_ai/core/constants/color_constants.dart';
import 'package:moli_ai/core/providers/default_privider.dart';
import 'package:moli_ai/core/providers/diary_privider.dart';
import 'package:moli_ai/presentation/diary/diary_list_screen.dart';
import 'package:provider/provider.dart';

import 'package:moli_ai/core/constants/constants.dart';

import 'data/models/config_model.dart';
import 'data/datasources/sqlite_config_source.dart';
import 'data/repositories/datebase/client.dart';
import 'core/providers/palm_priovider.dart';
import 'presentation/conversation/conversation_list_screen.dart';
import 'presentation/settings/setting_screen.dart';
import 'presentation/widgets/navigation/disappearing_bottom_navigation_bar.dart';
import 'presentation/widgets/navigation/disappearing_navigation_rail.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!Platform.isAndroid) {
    // Must add this line.
    await windowManager.ensureInitialized();
  }

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    WindowOptions windowOptions = const WindowOptions(
      size: Size(800, 1000),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
    WindowManager.instance.setMinimumSize(const Size(650, 700));
    WindowManager.instance.setMaximumSize(const Size(12000, 6000));
  }
  await dbClient.init();
  runApp(const MoliAIApp());
}

class MoliAIApp extends StatefulWidget {
  const MoliAIApp({super.key});

  @override
  State<MoliAIApp> createState() => _MoliAIAppState();
}

class _MoliAIAppState extends State<MoliAIApp> {
  Map<String, ConfigModel> _configMap = {};
  String themeName = "";
  String darkMode = "";
  ThemeData lightTheme = blumineBlueLight;
  ThemeData darkTheme = blumineBlueDark;

  @override
  void initState() {
    super.initState();
    _initConfig();
  }

  ThemeMode _getThemeDarkMode(
      DefaultSettingProvider defaultProvider, String selectedDarkMode) {
    var isDarkMode = defaultProvider.isDark;
    if (defaultProvider.darkMode != "") {
      selectedDarkMode = defaultProvider.darkMode;
    }
    if (selectedDarkMode == darkModeDark) {
      isDarkMode = true;
    } else if (selectedDarkMode == darkModeLight) {
      isDarkMode = false;
    } else {
      isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  Map<String, ThemeData> _getThemeInfo(
      DefaultSettingProvider defaultProvider, String themeName) {
    if (defaultProvider.themeName != "") {
      themeName = defaultProvider.themeName;
    }
    Map<String, ThemeData>? theme = themesMap[themeName];
    if (theme != null) {
      return theme;
    }
    return <String, ThemeData>{
      darkModeLight: blumineBlueLight,
      darkModeDark: blumineBlueDark
    };
  }

  void _initConfig() async {
    _configMap = await ConfigDBSource().getAllConfigsMap();

    ConfigModel? themeConf = _configMap[themeConfigname];
    if (themeConf != null) {
      final themeConfig = themeConf.toThemeConfig();
      themeName = themeConfig.themeName;
      darkMode = themeConfig.darkMode;
      log("themeConfig: $themeName, $darkMode");
      setState(() {
        themeName = themeConfig.themeName;
        darkMode = themeConfig.darkMode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // dbClient.q();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AISettingProvider(),
        ),
        ChangeNotifierProvider(create: (context) => DiaryProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => DefaultSettingProvider()),
      ],
      child: Consumer<DefaultSettingProvider>(
        builder: (context, defaultProvider, child) {
          var themeMode = _getThemeDarkMode(defaultProvider, darkMode);
          var themeData = _getThemeInfo(defaultProvider, themeName);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeData[darkModeLight],
            darkTheme: themeData[darkModeDark],
            themeMode: themeMode,
            home: const RootPage(),
          );
        },
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  late final _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      reverseDuration: const Duration(milliseconds: 1250),
      value: 0,
      vsync: this);

  late final _railAnimation = RailAnimation(parent: _controller);
  late final _railFabAnimation = RailFabAnimation(parent: _controller);
  late final _barAnimation = BarAnimation(parent: _controller);

  static final List<Widget> _widgetOptions = <Widget>[
    const DiaryistScreen(),
    ChatListScreen(
        chatListUseCase:
            GetChatListUseCase(ChatRepoImpl(ConversationDBSource())),
        deleteChatUseCase:
            ChatDeleteUseCase(ChatRepoImpl(ConversationDBSource()))),
    // PalmSettingScreen(),
    const SettingScreen(),
  ];

  bool wideScreen = false;
  bool controllerInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    final AnimationStatus status = _controller.status;
    if (width > 600) {
      if (status != AnimationStatus.forward &&
          status != AnimationStatus.completed) {
        _controller.forward();
      }
    } else {
      if (status != AnimationStatus.reverse &&
          status != AnimationStatus.dismissed) {
        _controller.reverse();
      }
    }
    if (!controllerInitialized) {
      controllerInitialized = true;
      _controller.value = width > 600 ? 1 : 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          DisappearingNavigationRail(
            railAnimation: _railAnimation,
            railFabAnimation: _railFabAnimation,
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: Container(
              child: _widgetOptions.elementAt(selectedIndex),
            ),
          ),
        ],
      ),
      bottomNavigationBar: wideScreen
          ? null
          : DisappearingBottomNavigationBar(
              barAnimation: _barAnimation,
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
    );
  }

  // void _navigateToCreateNewConversation() {
  //   final chatProvider = Provider.of<ChatProvider>(context, listen: false);
  //   chatProvider.setCurrentChatInfo(defaultChatEntity);
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => ConversationScreen(
  //         conversationData: defaultChatEntity,
  //       ),
  //     ),
  //   );
  // }
}
