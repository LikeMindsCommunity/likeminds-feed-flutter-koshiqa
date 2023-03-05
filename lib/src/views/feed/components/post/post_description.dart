import 'package:feed_sx/src/packages/expandable_text/expandable_text.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/widgets/text_with_links.dart';
import 'package:flutter/material.dart';

class PostDescription extends StatelessWidget {
  final String text;
  const PostDescription({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 24, vertical: kPaddingMedium),
        child: ExpandableText(text,
            expandText: 'show more',
            collapseText: 'show less',
            prefixStyle:
                const TextStyle(fontSize: kFontMedium, color: kGreyColor),
            linkStyle:
                const TextStyle(fontSize: kFontMedium, color: kLinkColor))
        // TextWithLinks(
        //   text: text,
        //   style: const TextStyle(fontSize: kFontMedium, color: kGreyColor),
        //   linkStyle: const TextStyle(fontSize: kFontMedium, color: kLinkColor),
        // )
        );
  }
}
