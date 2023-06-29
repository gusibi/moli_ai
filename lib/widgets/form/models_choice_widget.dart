import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../providers/palm_priovider.dart';
import '../../services/palm_api_service.dart';
import '../text_widget.dart';

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
    currentModel = modelsProvider.getCurrentModel;
    return DropdownButton(
        dropdownColor: scaffoldBackgroundColor,
        iconEnabledColor: Colors.white,
        items: getModelsItem,
        value: currentModel,
        onChanged: (value) {
          setState(() {
            currentModel = value.toString();
          });
          modelsProvider.setCurrentModel(value.toString());
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
    var currentModel = modelsProvider.getCurrentModel;
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
        modelsProvider.setCurrentModel(value.toString());
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
        modelsProvider.setCurrentModel(value.toString());
        log("currentModel: $currentModel");
      },
    );
  }
}

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
