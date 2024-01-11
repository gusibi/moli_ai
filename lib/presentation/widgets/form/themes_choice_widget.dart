import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';

class DarkModeRadioListTile extends StatefulWidget {
  const DarkModeRadioListTile({super.key, required this.notifier});

  final ValueNotifier<DarkModes> notifier;

  @override
  State<DarkModeRadioListTile> createState() => _DarkModeRadioListTileState();
}

class _DarkModeRadioListTileState extends State<DarkModeRadioListTile> {
  late ValueNotifier<DarkModes> _notifier;

  @override
  Widget build(BuildContext context) {
    _notifier = widget.notifier;
    return Row(
      children: <Widget>[
        Expanded(
          child: RadioListTile<DarkModes>(
            value: DarkModes.darkModeLight,
            groupValue: _notifier.value,
            onChanged: (DarkModes? value) {
              widget.notifier.value = value!;
              setState(() {
                _notifier = widget.notifier;
              });
            },
            title: const Text(darkModeLight),
            //subtitle: Text(textModel.modelDesc),
          ),
        ),
        Expanded(
          child: RadioListTile<DarkModes>(
            value: DarkModes.darkModeDark,
            groupValue: _notifier.value,
            onChanged: (DarkModes? value) {
              widget.notifier.value = value!;
              setState(() {
                _notifier = widget.notifier;
              });
            },
            title: const Text(darkModeDark),
            // subtitle: Text(textModel.modelDesc),
          ),
        ),
        Expanded(
          child: RadioListTile<DarkModes>(
            value: DarkModes.darkModeSystem,
            groupValue: _notifier.value,
            onChanged: (DarkModes? value) {
              widget.notifier.value = value!;
              setState(() {
                _notifier = widget.notifier;
              });
            },
            title: const Text(darkModeSystem),
            // subtitle: Text(textModel.modelDesc),
          ),
        ),
      ],
    );
  }
}

class DarkModeDropDownWidget extends StatefulWidget {
  final ValueChanged<String> onOptionSelected;
  String selectedOption;
  DarkModeDropDownWidget(
      {super.key,
      required this.onOptionSelected,
      this.selectedOption = darkModeSystem});

  @override
  State<DarkModeDropDownWidget> createState() => _DarkModeDropDownWidgetState();
}

class _DarkModeDropDownWidgetState extends State<DarkModeDropDownWidget> {
  final List<String> _options = [darkModeLight, darkModeDark, darkModeSystem];
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: '选择主题样式',
              border: OutlineInputBorder(),
            ),
            value: widget.selectedOption,
            items: _options.map((option) {
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

class ThemesDropDownWidget extends StatefulWidget {
  final ValueChanged<String> onOptionSelected;
  String selectedOption;
  ThemesDropDownWidget(
      {super.key,
      required this.onOptionSelected,
      this.selectedOption = blumineBlue});

  @override
  State<ThemesDropDownWidget> createState() => _ThemesDropDownWidgetState();
}

class _ThemesDropDownWidgetState extends State<ThemesDropDownWidget> {
  final List<String> _options = themesMap.keys.toList();
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: '选择一个主题',
              border: OutlineInputBorder(),
            ),
            value: widget.selectedOption,
            items: _options.map((option) {
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
