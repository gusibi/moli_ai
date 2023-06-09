import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../widgets/drop_down.dart';
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
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: const [
                Flexible(
                  child: TextWidget(
                    message: "Chosen Model: ",
                    fontSize: 16,
                  ),
                ),
                Spacer(), // 占位
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
