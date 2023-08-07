import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/utils/expandable_text/expandable_text.dart';
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
              horizontal: 16,
              vertical: kPaddingMedium,
            ),
            child: ExpandableText(
              text,
              expandText: 'show more',
            ),
          );
  }
}
