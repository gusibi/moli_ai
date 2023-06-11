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
        Provider.of<PalmModelsProvider>(context, listen: false);
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
