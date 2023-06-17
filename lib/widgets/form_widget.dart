import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/palm_priovider.dart';

class BaseURLFormWidget extends StatefulWidget {
  const BaseURLFormWidget({super.key});

  @override
  State<BaseURLFormWidget> createState() => _BaseURLFormWidgetState();
}

class _BaseURLFormWidgetState extends State<BaseURLFormWidget> {
  @override
  Widget build(BuildContext context) {
    final palmProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    var baseURL = palmProvider.getBaseURL;
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Base URL",
        border: OutlineInputBorder(),
      ),

      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter base URL';
        }
        return null;
      },
      // style: TextStyle(),
      initialValue: baseURL,
      onChanged: (value) {
        setState(() {
          baseURL = value.toString();
        });
        palmProvider.setBaseURL(value.toString());
      },
      onSaved: (value) {
        baseURL = value.toString();
        palmProvider.setBaseURL(value.toString());
        print("baseURL: $baseURL");
      },
    );
  }
}

class ApiKeyFormWidget extends StatefulWidget {
  const ApiKeyFormWidget({super.key});

  @override
  State<ApiKeyFormWidget> createState() => _ApiKeyFormWidgetState();
}

class _ApiKeyFormWidgetState extends State<ApiKeyFormWidget> {
  @override
  Widget build(BuildContext context) {
    final palmProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    var apiKey = palmProvider.getApiKey;
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "API Key",
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter API Key';
        }
        return null;
      },
      initialValue: apiKey,
      onChanged: (value) {
        setState(() {
          apiKey = value.toString();
        });
        palmProvider.setApiKey(value.toString());
      },
      onSaved: (value) {
        apiKey = value.toString();
        palmProvider.setApiKey(value.toString());
        print("apiKey: $apiKey");
      },
    );
  }
}
