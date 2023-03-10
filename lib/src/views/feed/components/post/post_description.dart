import 'package:feed_sx/src/packages/expandable_text/expandable_text.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';

class PostDescription extends StatelessWidget {
  final String text;
  const PostDescription({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return text.isEmpty
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: kPaddingMedium),
            child: ExpandableText(text,
                expandText: 'show more',
                collapseText: 'show less',
                prefixStyle:
                    const TextStyle(fontSize: kFontMedium, color: kGreyColor),
                linkStyle:
                    const TextStyle(fontSize: kFontMedium, color: kLinkColor)));
  }
}
