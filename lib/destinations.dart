import 'package:flutter/material.dart';

class Destination {
  const Destination(this.icon, this.label);
  final IconData icon;
  final String label;
}

const List<Destination> destinations = <Destination>[
  Destination(Icons.quickreply, 'Chat'),
  Destination(Icons.speaker_notes, 'Diary'),
  Destination(Icons.tune, 'Settings'),
];
