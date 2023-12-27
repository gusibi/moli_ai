import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_widget/markdown_widget.dart';

class MarkdownPage extends StatelessWidget {
  const MarkdownPage({
    Key? key,
    required this.markdown,
  }) : super(key: key);

  final String markdown;
  @override
  Widget build(BuildContext context) => Scaffold(body: buildMarkdown());

  Widget buildMarkdown() =>
      SingleChildScrollView(child: MarkdownBlock(data: markdown));
}
