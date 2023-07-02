import 'package:flutter/material.dart';

import '../../destinations.dart';

class DisappearingBottomNavigationBar extends StatefulWidget {
  const DisappearingBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  @override
  State<DisappearingBottomNavigationBar> createState() =>
      _DisappearingBottomNavigationBarState();
}

class _DisappearingBottomNavigationBarState
    extends State<DisappearingBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      elevation: 0,
      destinations: destinations.map<NavigationDestination>((d) {
        return NavigationDestination(
          icon: Icon(d.icon),
          label: d.label,
        );
      }).toList(),
      selectedIndex: widget.selectedIndex,
      onDestinationSelected: widget.onDestinationSelected,
    );
  }
}
