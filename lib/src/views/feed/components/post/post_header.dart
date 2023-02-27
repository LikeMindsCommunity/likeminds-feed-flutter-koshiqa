import 'package:feed_sx/src/widgets/profile_picture.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/utils/utils.dart';
import 'package:feed_sx/src/views/feed/components/dropdown_options.dart';
import 'package:flutter/material.dart';

class PostHeader extends StatelessWidget {
  final PostUser user;
  final Post postDetails;
  final List<PopupMenuItemModel> menuItems;
  final Function() refresh;

  const PostHeader(
      {super.key,
      required this.user,
      required this.menuItems,
      required this.postDetails,
      required this.refresh});

  void removeReportIntegration() {
    menuItems.removeWhere((element) {
      return element.title == 'Report';
    });
  }

  @override
  Widget build(BuildContext context) {
    removeReportIntegration();
    final bool isEdited = postDetails.createdAt != postDetails.updatedAt;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ProfilePicture(user: user),
          kHorizontalPaddingLarge,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    user.name.isNotEmpty ? user.name : "Deleted user",
                    style: TextStyle(
                      fontSize: kFontMedium,
                      color: kGrey1Color,
                      fontWeight: FontWeight.w500,
                      fontStyle: user.name.isNotEmpty
                          ? FontStyle.normal
                          : FontStyle.italic,
                    ),
                  ),
                  kHorizontalPaddingLarge,
                ],
              ),
              kVerticalPaddingSmall,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    postDetails.createdAt.timeAgo(),
                    style: const TextStyle(
                      fontSize: kFontSmall,
                      color: kGrey3Color,
                    ),
                  ),
                  kHorizontalPaddingXSmall,
                  Text(
                    isEdited ? '·' : '',
                    style: const TextStyle(
                      fontSize: kFontSmall,
                      color: kGrey3Color,
                    ),
                  ),
                  kHorizontalPaddingXSmall,
                  Text(
                    isEdited ? 'Edited' : '',
                    style: const TextStyle(
                      fontSize: kFontSmall,
                      color: kGrey3Color,
                    ),
                  ),
                ],
              )
            ],
          ),
          const Spacer(),
          menuItems.isNotEmpty
              ? DropdownOptions(
                  menuItems: menuItems,
                  postDetails: postDetails,
                  refresh: refresh,
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
