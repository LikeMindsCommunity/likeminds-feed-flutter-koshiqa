import 'package:feed_sdk/feed_sdk.dart';
import 'package:feed_sx/src/packages/expandable_text/expandable_text.dart';
import 'package:feed_sx/src/utils/constants/assets_constants.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/utils/utils.dart';
import 'package:feed_sx/src/views/comments/blocs/bloc/toggle_like_comment_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommentTile extends StatefulWidget {
  final String postId;
  final Reply reply;
  final PostUser user;
  const CommentTile(
      {super.key,
      required this.reply,
      required this.user,
      required this.postId});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  late final ToggleLikeCommentBloc _toggleLikeCommentBloc;
  late final Reply reply;
  late final PostUser user;
  late final String postId;
  bool isLiked = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reply = widget.reply;
    user = widget.user;
    postId = widget.postId;
    isLiked = reply.isLiked;
    FeedApi feedApi = RepositoryProvider.of<FeedApi>(context);
    _toggleLikeCommentBloc = ToggleLikeCommentBloc(feedApi: feedApi);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: kWhiteColor),
      padding: EdgeInsets.all(kPaddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.user.name,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              )
            ],
          ),
          kVerticalPaddingSmall,
          ExpandableText(widget.reply.text,
              expandText: 'show more', collapseText: 'show less'),
          kVerticalPaddingLarge,
          Row(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isLiked = !isLiked;
                      });

                      _toggleLikeCommentBloc.add(ToggleLikeComment(
                          toggleLikeCommentRequest: ToggleLikeCommentRequest(
                        commentId: reply.id,
                        postId: postId,
                      )));
                    },
                    child: Builder(builder: ((context) {
                      return isLiked
                          ? SvgPicture.asset(
                              kAssetLikeFilledIcon,
                              // color: kPrimaryColor,
                              height: 12,
                            )
                          : SvgPicture.asset(
                              kAssetLikeIcon,
                              color: kGrey3Color,
                              height: 12,
                            );
                    })),
                  ),
                  kHorizontalPaddingSmall,
                  Text(
                    'Like',
                    style: TextStyle(fontSize: kFontSmall, color: kGrey3Color),
                  ),
                ],
              ),
              kHorizontalPaddingMedium,
              Text(
                '|',
                style: TextStyle(fontSize: kFontSmall, color: kGrey3Color),
              ),
              kHorizontalPaddingMedium,
              Text(
                'Reply',
                style: TextStyle(fontSize: kFontSmall, color: kGrey3Color),
              ),
              kHorizontalPaddingMedium,
              Text(
                '·',
                style: TextStyle(fontSize: kFontSmall, color: kGrey3Color),
              ),
              kHorizontalPaddingMedium,
              Text(
                "${widget.reply.repliesCount}  replies",
                style: TextStyle(fontSize: kFontSmall, color: kPrimaryColor),
              ),
              Spacer(),
              Text(
                reply.createdAt.timeAgo(),
                style: TextStyle(fontSize: kFontSmall, color: kGrey3Color),
              ),
            ],
          )
        ],
      ),
    );
  }
}
