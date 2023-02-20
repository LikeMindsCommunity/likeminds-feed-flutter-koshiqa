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
  final Function() refresh;
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
  late final Post postDetails;
  late bool isLiked, isFeed;
  late Function() refresh;

  @override
  void initState() {
    super.initState();
    postDetails = widget.postDetails;
    postLikes = postDetails.likeCount;
    comments = postDetails.commentCount;
    isLiked = postDetails.isLiked;
    refresh = widget.refresh;
    isFeed = widget.isFeed;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            kHorizontalPaddingSmall,
            Row(
              children: [
                IconButton(
                  enableFeedback: false,
                  onPressed: () async {
                    setState(() {
                      if (isLiked) {
                        postLikes--;
                      } else {
                        postLikes++;
                      }
                      isLiked = !isLiked;
                      // refresh();
                    });
                    final response = await locator<LikeMindsService>()
                        .likePost(LikePostRequest(postId: postDetails.id));
                    if (!response.success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            "There was an error liking the post",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          backgroundColor: Colors.grey.shade500,
                        ),
                      );
                      setState(() {
                        if (isLiked) {
                          postLikes--;
                        } else {
                          postLikes++;
                        }
                        isLiked = !isLiked;
                        // refresh();
                      });
                    }
                  },
                  icon: isLiked
                      ? SvgPicture.asset(kAssetLikeFilledIcon)
                      : SvgPicture.asset(kAssetLikeIcon),
                  color: isLiked ? Colors.red : kGrey2Color,
                ),
                GestureDetector(
                  onTap: () async {
                    final response = await locator<LikeMindsService>()
                        .getPostLikes(
                            GetPostLikesRequest(postId: postDetails.id));
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return LikesScreen(
                          response: response,
                          postId: postDetails.id,
                        );
                      },
                    ));
                  },
                  child: Text(
                    postLikes > 0
                        ? "$postLikes ${postLikes > 1 ? kStringLikes : kStringLike}"
                        : kStringLike,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            kHorizontalPaddingSmall,
            TextButton.icon(
              onPressed: isFeed
                  ? () {
                      LMAnalytics.get().logEvent(
                        AnalyticsKeys.commentListOpen,
                        {
                          "post_id": postDetails.id,
                          "comment_count": postDetails.commentCount.toString(),
                        },
                      );
                      Navigator.pushNamed(
                        context,
                        AllCommentsScreen.route,
                        arguments:
                            AllCommentsScreenArguments(post: postDetails),
                      ).then((value) => refresh());
                    }
                  : () {},
              icon: SvgPicture.asset(kAssetCommentIcon),
              label: Text(
                comments > 0
                    ? "$comments ${comments > 1 ? " Comments" : " Comment"}"
                    : "Comment",
                style: const TextStyle(fontSize: 14),
              ),
              style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(
                      const TextStyle(fontSize: kButtonFontSize)),
                  foregroundColor: MaterialStateProperty.all(kGrey2Color)),
            )
          ],
        ),
        // TODO: Add bookmark and share icons
        // const Spacer(),
        // Row(
        //   children: [
        //     IconButton(
        //       onPressed: () {},
        //       icon: SvgPicture.asset(kAssetBookmarkIcon),
        //     ),
        //     IconButton(
        //       onPressed: () {},
        //       icon: SvgPicture.asset(kAssetShareIcon),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
