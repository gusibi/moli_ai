import 'package:flutter/material.dart';

class SingleSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const SingleSection({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final ColorScheme colorScheme = Theme.of(context).colorScheme;

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
            color: colorScheme.surfaceVariant,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          // color: Colors.white,
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
