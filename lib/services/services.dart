import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../widgets/form/models_choice_widget.dart';
import '../widgets/text_widget.dart';

class Services {
  static Future<void> showModalSheet(BuildContext context) async {
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        backgroundColor: scaffoldBackgroundColor,
        context: context,
        builder: (context) {
          return const Padding(
            padding: EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: TextWidget(
                    message: "Chosen Model: ",
                    fontSize: 16,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: ModelsDrowDownWidget(),
                ),
              ],
            ),
          );
        });
  }
}
