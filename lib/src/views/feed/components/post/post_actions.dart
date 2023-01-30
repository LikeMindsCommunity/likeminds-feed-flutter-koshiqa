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
  const PostActions({
    super.key,
    required this.postDetails,
  });

  get getPostDetails => postDetails;

  @override
  State<PostActions> createState() => _PostActionsState();
}

class _PostActionsState extends State<PostActions> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    final postDetails = widget.postDetails;

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
                    postDetails.likeCount > 0
                        ? "${postDetails.likeCount} ${postDetails.likeCount > 1 ? kStringLikes : kStringLike}"
                        : kStringLike,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            kHorizontalPaddingSmall,
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AllCommentsScreen.route);
                  },
                  icon: const Icon(Icons.comment_outlined),
                  color: kGrey2Color,
                ),
                const Text(
                  kStringAddComment,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
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
