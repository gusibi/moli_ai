import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:moli_ai_box/constants/constants.dart';

import 'repositories/datebase/client.dart';
import 'providers/palm_priovider.dart';
import 'screens/conversation_screen.dart';
import 'screens/conversation_list_screen.dart';
import 'screens/setting_screen.dart';
import 'widgets/disappearing_bottom_navigation_bar.dart';
import 'widgets/disappearing_navigation_rail.dart';

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
  @override
  Widget build(BuildContext context) {
    // dbClient.q();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PalmSettingProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //   useMaterial3: true,
        //   colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
        // ),
        theme: ThemeData.light(useMaterial3: true),
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
  late final _colorScheme = Theme.of(context).colorScheme;
  late final _backgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);

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
              backgroundColor: _backgroundColor,
              onDestinationSelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
          Expanded(
            child: Container(
              color: _backgroundColor,
              child: _widgetOptions.elementAt(selectedIndex),
            ),
          ),
        ],
      ),
      floatingActionButton: wideScreen
          ? null
          : FloatingActionButton(
              heroTag: "newConversation",
              backgroundColor: _colorScheme.tertiaryContainer,
              foregroundColor: _colorScheme.onTertiaryContainer,
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
