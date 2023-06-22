import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:moli_ai_box/constants/constants.dart';

import '../destinations.dart';
import '../providers/palm_priovider.dart';
import '../screens/palm_chat_screen.dart';

class DisappearingNavigationRail extends StatefulWidget {
  const DisappearingNavigationRail({
    super.key,
    required this.backgroundColor,
    required this.selectedIndex,
    this.onDestinationSelected,
  });

  final Color backgroundColor;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  @override
  State<DisappearingNavigationRail> createState() =>
      _DisappearingNavigationRailState();
}

class _DisappearingNavigationRailState
    extends State<DisappearingNavigationRail> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return NavigationRail(
      selectedIndex: widget.selectedIndex,
      backgroundColor: widget.backgroundColor,
      onDestinationSelected: widget.onDestinationSelected,
      leading: Column(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            backgroundColor: colorScheme.tertiaryContainer,
            foregroundColor: colorScheme.onTertiaryContainer,
            onPressed: () {
              _navigateToCreateNewChat();
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      groupAlignment: -0.85,
      destinations: destinations.map((d) {
        return NavigationRailDestination(
          icon: Icon(d.icon),
          label: Text(d.label),
        );
      }).toList(),
    );
  }

  void _navigateToCreateNewChat() {
    final palmProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    palmProvider.setCurrentChatInfo(newChat);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PalmChatScreen(
          conversationData: newChat,
        ),
      ),
    );
  }
}
