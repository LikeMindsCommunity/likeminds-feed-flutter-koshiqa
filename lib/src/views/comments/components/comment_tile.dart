import 'package:feed_sx/src/packages/expandable_text/expandable_text.dart';
import 'package:feed_sx/src/utils/constants/assets_constants.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kPaddingLarge),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Mark Jelenzsky',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              )
            ],
          ),
          kVerticalPaddingSmall,
          ExpandableText(
              'Reliance Retail Ltd has signed a long-term franchise agreement with American fashion brand Gap Inc to bring its products to India, a statement issued on July 6 read. The pact makes Reliance Retail the "official retailer for Gap across all channels in India"',
              expandText: 'show more',
              collapseText: 'show less'),
          kVerticalPaddingLarge,
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
                    style: TextStyle(fontSize: kFontSmall, color: kGrey3Color),
                  ),
                ],
              ),
              kHorizontalPaddingSmall,
              Text(
                '|',
                style: TextStyle(fontSize: kFontSmall, color: kGrey3Color),
              ),
              kHorizontalPaddingSmall,
              Text(
                'Reply',
                style: TextStyle(fontSize: kFontSmall, color: kGrey3Color),
              ),
              kHorizontalPaddingSmall,
              Text(
                '·',
                style: TextStyle(fontSize: kFontSmall, color: kGrey3Color),
              ),
              kHorizontalPaddingSmall,
              Text(
                '3 Replies',
                style: TextStyle(fontSize: kFontSmall, color: kPrimaryColor),
              ),
              Spacer(),
              Text(
                '20m',
                style: TextStyle(fontSize: kFontSmall, color: kGrey3Color),
              ),
            ],
          )
        ],
      ),
    );
  }
}
