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
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              // popupmenu item 1
              PopupMenuItem(
                value: 1,
                // row has two child icon and text.
                child: Row(
                  children: [
                    Icon(Icons.star),
                    SizedBox(
                      // sized box with width 10
                      width: 10,
                    ),
                    Text("Get The App")
                  ],
                ),
              ),
              // popupmenu item 2
              PopupMenuItem(
                value: 2,
                // row has two child icon and text
                child: Row(
                  children: [
                    Icon(Icons.chrome_reader_mode),
                    SizedBox(
                      // sized box with width 10
                      width: 10,
                    ),
                    Text("About")
                  ],
                ),
              ),
            ],
            offset: Offset(0, 100),
            color: Colors.grey,
            elevation: 2,
          ),
        ],
      ),
    );
  }
}
