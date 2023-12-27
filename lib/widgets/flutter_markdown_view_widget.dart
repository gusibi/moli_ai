import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:flutter_highlight/flutter_highlight.dart';

class CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var language = '';
    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      language = lg.substring(9);
    }
    var width = MediaQueryData.fromView(
            WidgetsBinding.instance.platformDispatcher.views.single)
        .size
        .width;
    if (width > 800) {
      width = 800;
    }
    return SizedBox(
      // width: width,
      child: HighlightView(
        // The original code to be highlighted
        element.textContent,
        // Specify language
        // It is recommended to give it a value for performance
        language: language,
        // Specify highlight theme
        // All available themes are listed in `themes` folder
        theme: MediaQueryData.fromView(
                        WidgetsBinding.instance.platformDispatcher.views.single)
                    .platformBrightness ==
                Brightness.light
            ? atomOneLightTheme
            : atomOneDarkTheme,
        // Specify padding
        padding: const EdgeInsets.all(8),
        // Specify text style
        textStyle: GoogleFonts.robotoMono(),
      ),
    );
  }
}

class MarkdownView extends StatelessWidget {
  const MarkdownView({
    Key? key,
    required this.markdown,
    this.textScaleFactor = 1,
  }) : super(key: key);

  final String markdown;
  final double textScaleFactor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return MarkdownBody(
      data: markdown,
      shrinkWrap: true,
      selectable: true,
      // softLineBreak: true,
      extensionSet: md.ExtensionSet(
        md.ExtensionSet.gitHubFlavored.blockSyntaxes,
        [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
      ),
      builders: {
        'code': CodeElementBuilder(),
        // 'pre': CodeElementBuilder(),
        // 'inlines': CodeElementBuilder(),
      },
      styleSheet: MarkdownStyleSheet(
          textScaleFactor: textScaleFactor,
          p: textTheme.bodyLarge!.copyWith(
            fontSize: 14,
            color: colors.onSecondaryContainer.withOpacity(0.72),
          ),
          a: TextStyle(
            decoration: TextDecoration.underline,
            color: colors.onSecondaryContainer.withOpacity(0.72),
          ),
          h1: textTheme.displaySmall!.copyWith(
            fontSize: 25,
            color: colors.onSecondaryContainer,
          ),
          h2: textTheme.headlineLarge!.copyWith(
            fontSize: 20,
            color: colors.onSecondaryContainer,
          ),
          h3: textTheme.headlineMedium!.copyWith(
            fontSize: 18,
            color: colors.onSecondaryContainer,
          ),
          h4: textTheme.headlineSmall!.copyWith(
            fontSize: 16,
            color: colors.onSecondaryContainer,
          ),
          h5: textTheme.titleLarge!.copyWith(
            fontSize: 16,
            color: colors.onSecondaryContainer,
          ),
          h6: textTheme.titleMedium!.copyWith(
            fontSize: 16,
            color: colors.onSecondaryContainer,
          ),
          listBullet: textTheme.bodyLarge!.copyWith(
            color: colors.onSecondaryContainer,
          ),
          em: const TextStyle(fontStyle: FontStyle.italic),
          strong:
              TextStyle(fontWeight: FontWeight.bold, color: colors.background),
          blockquote: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
            color: colors.onSurfaceVariant,
          ),
          blockquoteDecoration: BoxDecoration(
            color: colors.surfaceVariant,
            borderRadius: BorderRadius.circular(4),
          ),
          code: const TextStyle(fontFamily: 'monospace'),
          tableHead: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          tableBody: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          blockSpacing: 8,
          listIndent: 32,
          blockquotePadding: const EdgeInsets.all(8),
          h1Padding: const EdgeInsets.symmetric(vertical: 8),
          h2Padding: const EdgeInsets.symmetric(vertical: 8),
          h3Padding: const EdgeInsets.symmetric(vertical: 8),
          h4Padding: const EdgeInsets.symmetric(vertical: 8),
          h5Padding: const EdgeInsets.symmetric(vertical: 8),
          h6Padding: const EdgeInsets.symmetric(vertical: 8),
          codeblockPadding: const EdgeInsets.all(8),
          codeblockDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: colors.surfaceVariant,
          ),
          horizontalRuleDecoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: colors.outline.withOpacity(0.4),
                width: 1,
              ),
            ),
          )),
    );
  }
}
