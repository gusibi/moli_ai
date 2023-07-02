import 'dart:developer';

import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class PalmModelRadioListTile extends StatefulWidget {
  const PalmModelRadioListTile({super.key, required this.notifier});

  final ValueNotifier<PalmModels> notifier;

  @override
  State<PalmModelRadioListTile> createState() => _PalmModelRadioListTileState();
}

class _PalmModelRadioListTileState extends State<PalmModelRadioListTile> {
  late ValueNotifier<PalmModels> _notifier;

  @override
  Widget build(BuildContext context) {
    _notifier = widget.notifier;
    return Column(
      children: <Widget>[
        RadioListTile<PalmModels>(
          value: PalmModels.textModel,
          groupValue: _notifier.value,
          onChanged: (PalmModels? value) {
            widget.notifier.value = value!;
            setState(() {
              _notifier = widget.notifier;
            });
          },
          title: Text(textModel.modelName),
          // subtitle: Text(textModel.modelDesc),
        ),
        RadioListTile<PalmModels>(
          value: PalmModels.chatModel,
          groupValue: _notifier.value,
          onChanged: (PalmModels? value) {
            widget.notifier.value = value!;
            setState(() {
              _notifier = widget.notifier;
            });
          },
          title: Text(chatModel.modelName),
          // subtitle: Text(textModel.modelDesc),
        ),
      ],
    );
  }
}
