import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_widget/markdown_widget.dart';

// 有问题不能使用
class MarkdownPage extends StatelessWidget {
  const MarkdownPage({
    Key? key,
    required this.markdown,
    this.textScaleFactor = 1,
  }) : super(key: key);

  final String markdown;
  final double textScaleFactor;

  @override
  Widget build(BuildContext context) => Scaffold(body: buildMarkdown());

  Widget buildMarkdown() => MarkdownWidget(data: markdown);
}
