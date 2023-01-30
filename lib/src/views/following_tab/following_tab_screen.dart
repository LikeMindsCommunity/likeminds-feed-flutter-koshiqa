import 'package:feed_sx/src/utils/constants/assets_constants.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/feed/components/custom_feed_app_bar.dart';
import 'package:feed_sx/src/views/feed/components/dropdown_options.dart';
import 'package:feed_sx/src/views/feed/components/post/post_actions.dart';
import 'package:feed_sx/src/views/feed/components/post/post_description.dart';
import 'package:feed_sx/src/views/feed/components/post/post_header.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_media_factory.dart';
import 'package:feed_sx/src/views/following_tab/components/following_post_bottom.dart';
import 'package:feed_sx/src/views/following_tab/components/following_post_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FollowingTabScreen extends StatelessWidget {
  const FollowingTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: CustomFeedAppBar(),
      body: ListView(
        children: const [
          FollowingTabPost(postType: 1),
          FollowingTabPost(postType: 1),
          FollowingTabPost(postType: 1),
          FollowingTabPost(postType: 1),
          FollowingTabPost(postType: 1),
        ],
      ),
    );
  }
}

class FollowingTabPost extends StatelessWidget {
  final int postType;
  final bool showActions;
  const FollowingTabPost(
      {super.key, required this.postType, this.showActions = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        color: kWhiteColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FollowingPostInfo(),
            // PostHeader(),
            PostDescription(
              text:
                  'This text contains tags and links : https://likeminds.community/  and @Suryansh',
            ),
            // PostMediaFactory(postType: postType),
            showActions
                ? PostActions(
                    postId: '',
                  )
                : SizedBox.shrink(),
            FollowingTabBottom()
          ],
        ),
      ),
    );
  }
}
