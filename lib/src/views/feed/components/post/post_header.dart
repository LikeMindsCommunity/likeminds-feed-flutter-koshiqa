import 'package:feed_sdk/feed_sdk.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/utils/utils.dart';
import 'package:feed_sx/src/views/comments/all_comments_screen.dart';
import 'package:feed_sx/src/views/feed/components/dropdown_options.dart';
import 'package:feed_sx/src/views/report_post/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostHeader extends StatelessWidget {
  final PostUser user;
  final Post postDetails;
  final List<PopupMenuItemModel> menuItems;
  // final
  const PostHeader(
      {super.key,
      required this.user,
      required this.menuItems,
      required this.postDetails});

  @override
  Widget build(BuildContext context) {
    final bool isEdited = postDetails.createdAt != postDetails.updatedAt;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
            child: user.imageUrl.isEmpty
                ? Image.asset('packages/feed_sx/assets/images/avatar.png')
                : Image.network(user.imageUrl),
          ),
          kHorizontalPaddingLarge,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                        fontSize: kFontMedium,
                        color: kGrey1Color,
                        fontWeight: FontWeight.w500),
                  ),
                  kHorizontalPaddingLarge,
                  // )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    postDetails.createdAt.timeAgo(),
                    style: TextStyle(fontSize: kFontSmall, color: kGrey3Color),
                  ),
                  kHorizontalPaddingXSmall,
                  Text(
                    isEdited ? '·' : '',
                    style: TextStyle(fontSize: kFontSmall, color: kGrey3Color),
                  ),
                  kHorizontalPaddingXSmall,
                  Text(
                    isEdited ? 'Edited' : '',
                    style: TextStyle(fontSize: kFontSmall, color: kGrey3Color),
                  ),
                ],
              )
            ],
          ),
          const Spacer(),
          DropdownOptions(
            menuItems: menuItems,
            postDetails: postDetails,
          )
        ],
      ),
    );
  }
}
