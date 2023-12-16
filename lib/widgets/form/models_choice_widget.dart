import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moli_ai/constants/color_constants.dart';

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
          value: PalmModels.geminiProModel,
          groupValue: _notifier.value,
          onChanged: (PalmModels? value) {
            widget.notifier.value = value!;
            setState(() {
              _notifier = widget.notifier;
              log("model: $value");
            });
          },
          title: Text(geminiProModel.modelName),
          // subtitle: Text(textModel.modelDesc),
        ),
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

class DefaultAIDropDownWidget extends StatefulWidget {
  final ValueChanged<String> onOptionSelected;
  String selectedOption;
  String labelText;
  List<String> options;
  DefaultAIDropDownWidget(
      {super.key,
      required this.labelText,
      required this.onOptionSelected,
      required this.options,
      required this.selectedOption});

  @override
  State<DefaultAIDropDownWidget> createState() =>
      _DefaultAIDropDownWidgetState();
}

class _DefaultAIDropDownWidgetState extends State<DefaultAIDropDownWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: widget.labelText,
              border: const OutlineInputBorder(),
            ),
            value: widget.selectedOption,
            items: widget.options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                widget.selectedOption = value as String;
              });
              widget.onOptionSelected(value!);
            },
          ),
        ],
      ),
    );
  }
}
