import 'package:feed_sx/src/utils/constants/assets_constants.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/feed/components/dropdown_options.dart';
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
                  padding: EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(230, 235, 245, 0.5),
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hridesh Shrotiya'),
                      kVerticalPaddingSmall,
                      Text('sorry crude down to 95 usd.')
                    ],
                  ),
                ),
                SizedBox(
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
                        Text(
                          'Like',
                          style: TextStyle(
                              fontSize: kFontSmall, color: kGrey3Color),
                        ),
                      ],
                    ),
                    kHorizontalPaddingSmall,
                    Text(
                      '|',
                      style:
                          TextStyle(fontSize: kFontSmall, color: kGrey3Color),
                    ),
                    kHorizontalPaddingSmall,
                    Text(
                      'Reply',
                      style:
                          TextStyle(fontSize: kFontSmall, color: kGrey3Color),
                    ),
                    Spacer(),
                    Text(
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
                    Text(
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
          DropdownOptions(
            menuItems: [],
          )
        ],
      ),
    );
  }
}
