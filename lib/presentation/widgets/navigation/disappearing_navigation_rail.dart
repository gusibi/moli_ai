import 'package:flutter/material.dart';
import 'package:moli_ai/core/animations/bar_animations.dart';
import 'package:moli_ai/core/animations/transitions/nav_rail_transition.dart';
import 'package:moli_ai/data/providers/conversation_privider.dart';
import 'package:moli_ai/domain/entities/constants.dart';
import 'package:provider/provider.dart';

import 'package:moli_ai/core/constants/constants.dart';

import '../../../destinations.dart';
import '../../../core/providers/palm_priovider.dart';
import '../../conversation/conversation_screen.dart';

class DisappearingNavigationRail extends StatefulWidget {
  const DisappearingNavigationRail({
    super.key,
    required this.railAnimation,
    required this.railFabAnimation,
    required this.selectedIndex,
    this.onDestinationSelected,
  });

  final RailAnimation railAnimation;
  final RailFabAnimation railFabAnimation;

  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  @override
  State<DisappearingNavigationRail> createState() =>
      _DisappearingNavigationRailState();
}

class _DisappearingNavigationRailState
    extends State<DisappearingNavigationRail> {
  late final _colorScheme = Theme.of(context).colorScheme;
  @override
  Widget build(BuildContext context) {
    return NavRailTransition(
      animation: widget.railAnimation,
      backgroundColor: _colorScheme.background,
      child: NavigationRail(
        selectedIndex: widget.selectedIndex,
        onDestinationSelected: widget.onDestinationSelected,
        leading: Column(
          children: [
            const SizedBox(height: 40),
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
      ),
    );
  }

  void _navigateToCreateNewConversation() {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.setCurrentChatInfo(defaultChatEntity);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => newConversationScreen(defaultChatEntity),
      ),
    );
  }
}
