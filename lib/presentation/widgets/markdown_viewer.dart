import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_prism/flutter_prism.dart';
import 'package:markdown_viewer/markdown_viewer.dart';

/// An example of creating a syntax extension.
class ExampleSyntax extends MdInlineSyntax {
  ExampleSyntax() : super(RegExp(r'#[^#]+?(?=\s+|$)'));

  @override
  MdInlineObject? parse(MdInlineParser parser, Match match) {
    final markers = [parser.consume()];
    final content = parser.consumeBy(match[0]!.length - 1);
    final children = content.map((e) => MdText.fromSpan(e)).toList();

    return MdInlineElement(
      'example',
      markers: markers,
      children: children,
      start: markers.first.start,
      end: children.last.end,
    );
  }
}

/// An example of creating a element builder.
class ExampleBuilder extends MarkdownElementBuilder {
  ExampleBuilder()
      : super(
          textStyle: const TextStyle(
            color: Colors.green,
            decoration: TextDecoration.underline,
          ),
        );

  @override
  bool isBlock(element) => false;

  @override
  List<String> matchTypes = <String>['example'];
}

// 可以用，代码可以复制，不能复制多行
class MarkdownPageViewer extends StatelessWidget {
  const MarkdownPageViewer({
    Key? key,
    required this.markdown,
    this.textScaleFactor = 1,
  }) : super(key: key);

  final String markdown;
  final double textScaleFactor;

  @override
  Widget build(BuildContext context) {
    return MarkdownViewer(
      markdown,
      enableTaskList: true,
      enableSuperscript: false,
      enableSubscript: false,
      enableFootnote: false,
      enableImageSize: false,
      enableKbd: false,
      syntaxExtensions: [ExampleSyntax()],
      highlightBuilder: (text, language, infoString) {
        final prism = Prism(
          mouseCursor: SystemMouseCursors.text,
          style: Theme.of(context).brightness == Brightness.dark
              ? const PrismStyle.dark()
              : const PrismStyle(),
        );
        return prism.render(text, language ?? 'plain');
      },
      // onTapLink: (href, title) {
      //   print({href, title});
      // },
      elementBuilders: [
        ExampleBuilder(),
      ],
      styleSheet: const MarkdownStyle(
        listItemMarkerTrailingSpace: 12,
        codeSpan: TextStyle(
          fontFamily: 'RobotoMono',
        ),
        codeBlock: TextStyle(
          fontSize: 14,
          letterSpacing: -0.3,
          fontFamily: 'RobotoMono',
        ),
      ),
    );
  }
}
