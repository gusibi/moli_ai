import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../providers/palm_priovider.dart';
import '../services/palm_api_service.dart';
import 'text_widget.dart';

List<DropdownMenuItem<String>>? get getModelsItem {
  var models = PalmApiService.getModels();
  List<DropdownMenuItem<String>>? items =
      List<DropdownMenuItem<String>>.generate(
          models.length,
          (index) => DropdownMenuItem(
                value: modelsList[index],
                child: TextWidget(
                  message: modelsList[index],
                  fontSize: 15,
                ),
              ));
  return items;
}

class ModelsDrowDownWidget extends StatefulWidget {
  const ModelsDrowDownWidget({super.key});

  @override
  State<ModelsDrowDownWidget> createState() => _ModelsDrowDownWidgetState();
}

class _ModelsDrowDownWidgetState extends State<ModelsDrowDownWidget> {
  //您可以尝试更改ModelsDrowDownWidget小部件的currentModel变量，将其初始值设置为modelsList的第一个值，以确保它是一个有效的下拉菜单选项
  String? currentModel;

  @override
  Widget build(BuildContext context) {
    final modelsProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    currentModel = modelsProvider.getDefaultModel;
    return DropdownButton(
        dropdownColor: scaffoldBackgroundColor,
        iconEnabledColor: Colors.white,
        items: getModelsItem,
        value: currentModel,
        onChanged: (value) {
          setState(() {
            currentModel = value.toString();
          });
          modelsProvider.setDefaultModel(value.toString());
        });
  }
}

class ModelsDropdownFormWidget extends StatefulWidget {
  const ModelsDropdownFormWidget({super.key});

  @override
  State<ModelsDropdownFormWidget> createState() =>
      _ModelsDropdownFormWidgetState();
}

class _ModelsDropdownFormWidgetState extends State<ModelsDropdownFormWidget> {
  @override
  Widget build(BuildContext context) {
    final modelsProvider =
        Provider.of<PalmSettingProvider>(context, listen: false);
    var currentModel = modelsProvider.getDefaultModel;
    return DropdownButtonFormField<String>(
      value: currentModel,
      items: modelsProvider
          .getAllPalmModels()
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          currentModel = value.toString();
        });
        modelsProvider.setDefaultModel(value.toString());
      },
      decoration: const InputDecoration(
        labelText: 'Select an option',
      ),
      validator: (value) {
        if (value == null) {
          return 'Please select an option';
        }
        return null;
      },
      onSaved: (value) {
        currentModel = value.toString();
        modelsProvider.setDefaultModel(value.toString());
        print("currentModel: $currentModel");
      },
    );
  }
}
