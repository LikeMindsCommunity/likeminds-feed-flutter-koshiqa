import 'package:feed_sx/src/utils/share/share_post.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/navigation/arguments.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/utils/constants/assets_constants.dart';
import 'package:feed_sx/src/utils/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:overlay_support/overlay_support.dart';

class PostActions extends StatefulWidget {
  final Post postDetails;
  final Function(bool) refresh;
  final bool isFeed;

  const PostActions({
    super.key,
    required this.postDetails,
    required this.refresh,
    required this.isFeed,
  });

  get getPostDetails => postDetails;

  @override
  State<PostActions> createState() => _PostActionsState();
}

class _PostActionsState extends State<PostActions> {
  int postLikes = 0;
  int comments = 0;
  Post? postDetails;
  late bool isLiked, isFeed;
  late Function(bool) refresh;
  ValueNotifier<bool> rebuildLikeWidget = ValueNotifier(false);

  setPostDetails() {
    postDetails = widget.postDetails;
    postLikes = postDetails!.likeCount;
    comments = postDetails!.commentCount;
    isLiked = postDetails!.isLiked;
    refresh = widget.refresh;
    isFeed = widget.isFeed;
  }

  @override
  Widget build(BuildContext context) {
    setPostDetails();
    return Row(
      children: [
        Row(
          children: [
            kHorizontalPaddingSmall,
            Row(
              children: [
                IconButton(
                  enableFeedback: false,
                  splashColor: Colors.transparent,
                  onPressed: () async {
                    if (isLiked) {
                      postLikes--;
                    } else {
                      postLikes++;
                    }
                    isLiked = !isLiked;
                    rebuildLikeWidget.value = !rebuildLikeWidget.value;

                    final response = await locator<LikeMindsService>().likePost(
                        (LikePostRequestBuilder()..postId(postDetails!.id))
                            .build());
                    if (!response.success) {
                      toast(
                        response.errorMessage ??
                            "There was an error liking the post",
                        duration: Toast.LENGTH_LONG,
                      );
                      if (isLiked) {
                        postLikes--;
                      } else {
                        postLikes++;
                      }
                      isLiked = !isLiked;
                      rebuildLikeWidget.value = !rebuildLikeWidget.value;
                    } else {
                      await refresh(false);
                    }
                  },
                  icon: ValueListenableBuilder(
                      valueListenable: rebuildLikeWidget,
                      builder: (context, _, __) {
                        return isLiked
                            ? SvgPicture.asset(kAssetLikeFilledIcon,
                                height: 28, width: 28)
                            : SvgPicture.asset(kAssetLikeIcon,
                                height: 21.5, width: 21.5);
                      }),
                  color: isLiked ? Colors.red : kGrey2Color,
                ),
                GestureDetector(
                  onTap: () async {
                    locator<NavigationService>().navigateTo(LikesScreen.route,
                        arguments: LikesScreenArguments(
                            postId: widget.postDetails.id));
                  },
                  child: ValueListenableBuilder(
                      valueListenable: rebuildLikeWidget,
                      builder: (context, _, __) {
                        return Text(
                          postLikes > 0
                              ? "$postLikes ${postLikes > 1 ? kStringLikes : kStringLike}"
                              : kStringLike,
                          style: const TextStyle(fontSize: 14),
                        );
                      }),
                ),
              ],
            ),
            kHorizontalPaddingMedium,
            //kHorizontalPaddingSmall,
            TextButton.icon(
              onPressed: isFeed
                  ? () {
                      LMAnalytics.get().logEvent(
                        AnalyticsKeys.commentListOpen,
                        {
                          "post_id": postDetails!.id,
                          "comment_count": postDetails!.commentCount.toString(),
                        },
                      );
                      locator<NavigationService>()
                          .navigateTo(
                        AllCommentsScreen.route,
                        arguments: AllCommentsScreenArguments(
                          post: postDetails!,
                          feedroomId: locator<LikeMindsService>().getFeedroomId,
                        ),
                      )
                          .then((result) {
                        if (result != null && result['isBack'] != null) {
                          refresh(result['isBack']);
                        }
                      });
                    }
                  : () {},
              icon: SvgPicture.asset(kAssetCommentIcon,
                  width: 21.5, height: 21.5),
              label: Text(
                comments > 0
                    ? "$comments ${comments > 1 ? " Comments" : " Comment"}"
                    : "Add Comment",
                style: const TextStyle(fontSize: 14),
              ),
              style: ButtonStyle(
                  splashFactory:
                      isFeed ? InkSplash.splashFactory : NoSplash.splashFactory,
                  textStyle: MaterialStateProperty.all(
                      const TextStyle(fontSize: kButtonFontSize)),
                  foregroundColor: MaterialStateProperty.all(kGrey2Color)),
            )
          ],
        ),
        // TODO: Add bookmark and share icons
        const Spacer(),
        Row(
          children: [
            // IconButton(
            //   onPressed: () {},
            //   icon: SvgPicture.asset(kAssetBookmarkIcon),
            // ),
            IconButton(
              onPressed: () {
                SharePost().sharePost(postDetails!.id);
              },
              icon: SvgPicture.asset(kAssetShareIcon),
            ),
          ],
        ),
        kHorizontalPaddingSmall,
      ],
    );
  }
}
