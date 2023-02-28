import 'package:feed_sx/src/utils/constants/string_constants.dart';
import 'package:feed_sx/src/views/tagging/helpers/tagging_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TextWithLinks extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextStyle? linkStyle;
  const TextWithLinks({
    super.key,
    required this.text,
    this.linkStyle,
    this.style,
  });

  @override
  State<TextWithLinks> createState() => _TextWithLinksState();
}

class _TextWithLinksState extends State<TextWithLinks> {
  RegExp regExp = RegExp(kRegexLinksAndTags);
  late final List<TextSpan> textSpans;

  @override
  void initState() {
    super.initState();
    textSpans = extractLinksAndTags(widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: textSpans,
      ),
    );
  }

  List<TextSpan> extractLinksAndTags(String text) {
    List<TextSpan> textSpans = [];
    int lastIndex = 0;
    for (Match match in regExp.allMatches(text)) {
      int startIndex = match.start;
      int endIndex = match.end;
      String? link = match.group(0);

      if (lastIndex != startIndex) {
        // Add a TextSpan for the preceding text
        textSpans.add(TextSpan(
          text: text.substring(lastIndex, startIndex),
          style: widget.style,
        ));
      }
      bool isTag = link != null && link[0] == '<';
      // Add a TextSpan for the URL
      textSpans.add(TextSpan(
        text: isTag ? TaggingHelper.decodeString(link).keys.first : link,
        style: widget.linkStyle ?? const TextStyle(color: Colors.blue),
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            if (!isTag) {
              if (await canLaunchUrlString(link ?? '')) {
                launchUrlString(link.toString());
              }
            } else {
              TaggingHelper.routeToProfile(
                TaggingHelper.decodeString(link).values.first,
              );
            }
          },
      ));

      lastIndex = endIndex;
    }

    if (lastIndex != text.length) {
      // Add a TextSpan for the remaining text
      textSpans.add(TextSpan(
        text: text.substring(lastIndex),
        style: widget.style,
      ));
    }
    return textSpans;
  }
}
