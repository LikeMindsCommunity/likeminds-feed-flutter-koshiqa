import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';

class PostDescription extends StatelessWidget {
  const PostDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
          horizontal: kPaddingLarge, vertical: kPaddingMedium),
      child: Text(
        'Here is a list of social media tools to help you get started with your marketing initiatives.',
        style: TextStyle(fontSize: kFontMedium, color: kGreyColor),
      ),
    );
  }
}
