import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/utils/constants/assets_constants.dart';
import 'package:feed_sx/src/utils/constants/string_constants.dart';
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
            kHorizontalPaddingSmall,
            TextButton.icon(
              onPressed: () {},
              icon: SvgPicture.asset(kAssetLikeIcon),
              label: const Text(
                kStringLike,
                style: TextStyle(fontSize: 14),
              ),
              style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(
                      const TextStyle(fontSize: kButtonFontSize)),
                  foregroundColor: MaterialStateProperty.all(kGrey2Color)),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AllCommentsScreen.route);
              },
              icon: SvgPicture.asset(kAssetCommentIcon),
              label: const Text(
                kStringAddComment,
                style: TextStyle(fontSize: 14),
              ),
              style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(
                      const TextStyle(fontSize: kButtonFontSize)),
                  foregroundColor: MaterialStateProperty.all(kGrey2Color)),
            )
          ],
        ),
        const Spacer(),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(kAssetBookmarkIcon),
            ),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(kAssetShareIcon),
            ),
          ],
        ),
      ],
    );
  }
}
