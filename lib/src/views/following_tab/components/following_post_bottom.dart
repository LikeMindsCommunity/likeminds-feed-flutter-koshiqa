import 'package:feed_sx/src/utils/constants/assets_constants.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FollowingTabBottom extends StatelessWidget {
  const FollowingTabBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
            child: Image.asset(
              'packages/feed_sx/assets/images/avatar.png',
              height: 40,
              width: 40,
            ),
          ),
          kHorizontalPaddingLarge,
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(230, 235, 245, 0.5),
                      borderRadius: BorderRadius.circular(16)),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hridesh Shrotiya'),
                      kVerticalPaddingSmall,
                      Text('sorry crude down to 95 usd.')
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          kAssetLikeIcon,
                          color: kGrey3Color,
                          height: 12,
                        ),
                        kHorizontalPaddingSmall,
                        const Text(
                          'Like',
                          style: TextStyle(
                              fontSize: kFontSmall, color: kGrey3Color),
                        ),
                      ],
                    ),
                    kHorizontalPaddingSmall,
                    const Text(
                      '|',
                      style:
                          TextStyle(fontSize: kFontSmall, color: kGrey3Color),
                    ),
                    kHorizontalPaddingSmall,
                    const Text(
                      'Reply',
                      style:
                          TextStyle(fontSize: kFontSmall, color: kGrey3Color),
                    ),
                    const Spacer(),
                    const Text(
                      '20m',
                      style:
                          TextStyle(fontSize: kFontSmall, color: kGrey3Color),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(kAssetReplyIcon),
                    kHorizontalPaddingSmall,
                    const Text(
                      '3 Replies',
                      style:
                          TextStyle(fontSize: kFontSmall, color: kPrimaryColor),
                    ),
                  ],
                )
              ],
            ),
          ),
          // const Spacer(),
          // DropdownOptions(
          //   menuItems: [],
          //   postDetails: ,
          // )
        ],
      ),
    );
  }
}
