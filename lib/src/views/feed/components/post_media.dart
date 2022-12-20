import 'package:feed_sx/src/theme.dart';
import 'package:flutter/material.dart';

class PostImage extends StatelessWidget {
  const PostImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(top: kPaddingMedium),
      child: Image.asset(
        'packages/feed_sx/assets/images/post.png',
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
