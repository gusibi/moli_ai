import 'package:flutter/material.dart';
import 'package:moli_ai_box/screens/setting_screen.dart';
import 'package:provider/provider.dart';

import 'package:moli_ai_box/constants/constants.dart';

import 'providers/palm_priovider.dart';
import 'screens/palm_chat_screen.dart';
import 'screens/chat_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ChatListScreen(),
    SettingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PalmSettingProvider(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData.light(useMaterial3: true),
        home: Scaffold(
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: "Setting"),
            ],
            backgroundColor: Colors.white,
            // backgroundColor: cardColor,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
