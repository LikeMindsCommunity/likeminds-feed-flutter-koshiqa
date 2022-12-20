import 'package:feed_sx/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostActions extends StatelessWidget {
  const PostActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            kHorizontalSmallP,
            TextButton.icon(
              onPressed: () {},
              icon: SvgPicture.asset('packages/feed_sx/assets/icons/like.svg'),
              label: const Text(
                'Like',
                style: TextStyle(fontSize: 14),
              ),
              style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(
                      const TextStyle(fontSize: kButtonFontSize)),
                  foregroundColor: MaterialStateProperty.all(kgrey2Color)),
            ),
            TextButton.icon(
              onPressed: () {},
              icon:
                  SvgPicture.asset('packages/feed_sx/assets/icons/comment.svg'),
              label: const Text(
                'Comment',
                style: TextStyle(fontSize: 14),
              ),
              style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(
                      const TextStyle(fontSize: kButtonFontSize)),
                  foregroundColor: MaterialStateProperty.all(kgrey2Color)),
            )
          ],
        ),
        const Spacer(),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                  'packages/feed_sx/assets/icons/bookmark.svg'),
            ),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('packages/feed_sx/assets/icons/share.svg'),
            ),
          ],
        ),
      ],
    );
  }
}
