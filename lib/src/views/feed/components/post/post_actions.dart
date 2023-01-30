import 'package:feed_sdk/feed_sdk.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/navigation/arguments.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/utils/constants/assets_constants.dart';
import 'package:feed_sx/src/utils/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostActions extends StatefulWidget {
  final Post postDetails;
  final Function refresh;

  const PostActions({
    super.key,
    required this.postDetails,
    required this.refresh,
  });

  get getPostDetails => postDetails;

  @override
  State<PostActions> createState() => _PostActionsState();
}

class _PostActionsState extends State<PostActions> {
  bool isLiked = false;
  int postLikes = 0;

  isLikedByMe(Post postDetails) async {
    final response = await locator<LikeMindsService>().getPostLikes(
      GetPostLikesRequest(postId: postDetails.id),
    );
    if (response.users!.keys.contains("5d428e4d-984d-4ab5-8d2b-0adcdbab2ad8")) {
      setState(() {
        isLiked = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final postDetails = widget.postDetails;
    postLikes = postDetails.likeCount;
    final refresh = widget.refresh;

    return Row(
      children: [
        Row(
          children: [
            kHorizontalPaddingSmall,
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    final response = await locator<LikeMindsService>()
                        .likePost(LikePostRequest(postId: postDetails.id));
                    if (response.success) {
                      setState(() {
                        isLiked = !isLiked;
                        postLikes = response.likes!;

                        refresh();
                      });
                    }
                  },
                  icon: isLiked
                      ? const Icon(Icons.favorite)
                      : const Icon(Icons.favorite_border),
                  color: isLiked ? Colors.red : kGrey2Color,
                ),
                GestureDetector(
                  onTap: () async {
                    final response = await locator<LikeMindsService>()
                        .getPostLikes(
                            GetPostLikesRequest(postId: postDetails.id));
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return LikesScreen(response: response);
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
              onPressed: () {
                Navigator.pushNamed(context, AllCommentsScreen.route,
                    arguments:
                        AllCommentsScreenArguments(postId: postDetails.id));
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
