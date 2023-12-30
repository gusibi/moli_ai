import 'package:flutter/material.dart';

class Destination {
  const Destination(this.icon, this.label);
  final IconData icon;
  final String label;
}

const List<Destination> destinations = <Destination>[
  Destination(Icons.emoji_objects_outlined, 'Chat'),
  Destination(Icons.note_alt, 'Diary'),
  Destination(Icons.tune, 'Settings'),
];
