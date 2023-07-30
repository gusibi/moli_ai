import 'package:flutter/material.dart';

import '../../utils/color.dart';

class FormSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const FormSection({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final ColorScheme colorScheme = Theme.of(context).colorScheme;
    late final Color background = colorScheme.surfaceVariant;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title.toUpperCase(),
          ),
        ),
        // const SizedBox(height: 8),
        Container(
          padding:
              const EdgeInsets.only(left: 14, right: 14, top: 20, bottom: 2),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: background,
            boxShadow: [
              BoxShadow(
                color: getShadowColor(colorScheme),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: List.generate(
              children.length,
              (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: children[index],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
