import 'package:flutter/material.dart';
import 'package:moli_ai/animations/bar_animations.dart';
import 'package:moli_ai/animations/transitions/bottom_bar_transition.dart';

import '../../destinations.dart';

class DisappearingBottomNavigationBar extends StatefulWidget {
  const DisappearingBottomNavigationBar({
    super.key,
    required this.barAnimation,
    required this.selectedIndex,
    this.onDestinationSelected,
  });

  final BarAnimation barAnimation;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  @override
  State<DisappearingBottomNavigationBar> createState() =>
      _DisappearingBottomNavigationBarState();
}

class _DisappearingBottomNavigationBarState
    extends State<DisappearingBottomNavigationBar> {
  late final _colorScheme = Theme.of(context).colorScheme;
  @override
  Widget build(BuildContext context) {
    return BottomBarTransition(
      animation: widget.barAnimation,
      backgroundColor: _colorScheme.background,
      child: NavigationBar(
        elevation: 0,
        destinations: destinations.map<NavigationDestination>((d) {
          return NavigationDestination(
            icon: Icon(d.icon),
            label: d.label,
          );
        }).toList(),
        selectedIndex: widget.selectedIndex,
        onDestinationSelected: widget.onDestinationSelected,
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return NavigationBar(
  //     elevation: 0,
  //     destinations: destinations.map<NavigationDestination>((d) {
  //       return NavigationDestination(
  //         icon: Icon(d.icon),
  //         label: d.label,
  //       );
  //     }).toList(),
  //     selectedIndex: widget.selectedIndex,
  //     onDestinationSelected: widget.onDestinationSelected,
  //   );
  // }
}
