import 'package:flutter/material.dart';

import '../widgets/drop_down.dart';
import '../widgets/form_widget.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late final _colorScheme = Theme.of(context).colorScheme;
  late final _backgroundColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.14), _colorScheme.surface);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
      ),
      body: Container(
        color: _backgroundColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const BaseURLFormWidget(),
                      const ApiKeyFormWidget(),
                      const ModelsDropdownFormWidget(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              // do something with _baseUrl and _apiKey
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ),
                    ])),
          ),
        ),
      ),
    );
  }
}
