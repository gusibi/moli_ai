import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:moli_ai/constants/constants.dart';

import '../../destinations.dart';
import '../../providers/palm_priovider.dart';
import '../../screens/conversation/conversation_screen.dart';

class DisappearingNavigationRail extends StatefulWidget {
  const DisappearingNavigationRail({
    super.key,
    required this.selectedIndex,
    this.onDestinationSelected,
  });

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
    return NavigationRail(
      selectedIndex: widget.selectedIndex,
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
            onPressed: () {
              _navigateToCreateNewConversation();
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
