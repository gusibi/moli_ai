import 'package:flutter/material.dart';
import 'package:moli_ai/constants/color_constants.dart';
import 'package:provider/provider.dart';

import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'package:moli_ai/constants/constants.dart';

import 'models/config_model.dart';
import 'repositories/configretion/config_repo.dart';
import 'repositories/datebase/client.dart';
import 'providers/palm_priovider.dart';
import 'screens/conversation_screen.dart';
import 'screens/conversation_list_screen.dart';
import 'screens/setting_screen.dart';
import 'widgets/navigation/disappearing_bottom_navigation_bar.dart';
import 'widgets/navigation/disappearing_navigation_rail.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize the database
  await dbClient.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

  void _initConfig() async {
    _configMap = await ConfigReop().getAllConfigsMap();

    ConfigModel? themeConf = _configMap[themeConfigname];
    if (themeConf != null) {
      final themeConfig = themeConf.toThemeConfig();
      themeName = themeConfig.themeName;
      darkMode = themeConfig.darkMode;
      Map<String, ThemeData>? theme = themesMap[themeName];
      if (theme != null) {
        lightTheme = theme[darkModeLight]!;
        darkTheme = theme[darkModeDark]!;
      }
      setState(() {
        themeName = themeConfig.themeName;
        darkMode = themeConfig.darkMode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    if (darkMode != "" && darkMode == darkModeDark) {
      isDarkMode = true;
    }
    // dbClient.q();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PalmSettingProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: const RootPage(),
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ConversationListScreen(),
    SettingScreen(),
  ];

  bool wideScreen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    wideScreen = width > 600;
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
          if (wideScreen)
            DisappearingNavigationRail(
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
      floatingActionButton: wideScreen
          ? null
          : FloatingActionButton(
              heroTag: "newConversation",
              onPressed: () {
                _navigateToCreateNewConversation();
              },
              child: const Icon(Icons.add),
            ),
      bottomNavigationBar: wideScreen
          ? null
          : DisappearingBottomNavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
    );
  }

  void _navigateToCreateNewConversation() {
    final palmProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    palmProvider.setCurrentConversationInfo(newConversation);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ConversationScreen(
          conversationData: newConversation,
        ),
      ),
    );
  }
}
