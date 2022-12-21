import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';

class PostHeader extends StatelessWidget {
  const PostHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
            child: Image.asset('packages/feed_sx/assets/images/avatar.png'),
          ),
          kHorizontalPaddingLarge,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Theresa Webb',
                    style: TextStyle(
                        fontSize: kFontMedium,
                        color: kGrey1Color,
                        fontWeight: FontWeight.w500),
                  ),
                  kHorizontalPaddingLarge,
                  Container(
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius:
                            BorderRadius.circular(kBorderRadiusXSmall)),
                    padding: const EdgeInsets.symmetric(
                        vertical: kPaddingSmall, horizontal: kPaddingMedium),
                    child: const Text(
                      'Admin',
                      style: TextStyle(
                        fontSize: kFontXSmall,
                        color: kWhiteColor,
                        fontWeight: FontWeight.w500,
                        // height: 1.45,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    '2d',
                    style: TextStyle(fontSize: kFontSmall, color: kGrey3Color),
                  ),
                  kHorizontalPaddingXSmall,
                  Text(
                    '·',
                    style: TextStyle(fontSize: kFontSmall, color: kGrey3Color),
                  ),
                  kHorizontalPaddingXSmall,
                  Text(
                    'Edited',
                    style: TextStyle(fontSize: kFontSmall, color: kGrey3Color),
                  ),
                ],
              )
            ],
          ),
          const Spacer(),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.more_horiz_outlined))
        ],
      ),
    );
  }
}
