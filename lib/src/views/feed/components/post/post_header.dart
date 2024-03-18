import 'package:likeminds_feed_flutter_koshiqa/src/widgets/profile_picture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:likeminds_feed_flutter_koshiqa/src/utils/constants/ui_constants.dart';
import 'package:likeminds_feed_flutter_koshiqa/src/utils/utils.dart';
import 'package:likeminds_feed_flutter_koshiqa/src/views/feed/components/dropdown_options.dart';
import 'package:flutter/material.dart';

class PostHeader extends StatelessWidget {
  final User user;
  final int feedRoomId;
  final Post postDetails;
  final List<PopupMenuItemModel> menuItems;
  final Function(bool) refresh;
  final Map<String, Topic> topics;
  final bool isFeed;

  const PostHeader({
    super.key,
    required this.user,
    required this.menuItems,
    required this.postDetails,
    required this.feedRoomId,
    required this.refresh,
    required this.topics,
    required this.isFeed,
  });

  void removeReportIntegration() {
    menuItems.removeWhere((element) {
      return element.title == 'Report';
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    removeReportIntegration();
    final bool isEdited = postDetails.isEdited;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        width: screenSize.width - 32,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProfilePicture(user: user),
            kHorizontalPaddingLarge,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          user.isDeleted == null || !user.isDeleted!
                              ? user.name
                              : "Deleted user",
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: kFontMedium,
                            color: kGrey1Color,
                            fontWeight: FontWeight.w500,
                            fontStyle: user.name.isNotEmpty
                                ? FontStyle.normal
                                : FontStyle.italic,
                          ),
                        ),
                      ),
                      kHorizontalPaddingMedium,
                      (user.customTitle == null || user.customTitle!.isEmpty) ||
                              (user.isDeleted != null && user.isDeleted!)
                          ? const SizedBox()
                          : Row(mainAxisSize: MainAxisSize.min, children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.0),
                                  color: kPrimaryColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    user.customTitle!.isNotEmpty
                                        ? user.customTitle!
                                        : "",
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: kFontSmall,
                                      color: kWhiteColor,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: user.name.isNotEmpty
                                          ? FontStyle.normal
                                          : FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
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
            ),
            kHorizontalPaddingLarge,
            Row(
              children: [
                postDetails.isPinned
                    ? SvgPicture.asset(
                        "packages/likeminds_feed_flutter_koshiqa/assets/icons/pin.svg",
                        color: kGrey3Color,
                        height: 20,
                        width: 20,
                        fit: BoxFit.cover,
                      )
                    : const SizedBox(),
                kHorizontalPaddingLarge,
                menuItems.isNotEmpty
                    ? DropdownOptions(
                        menuItems: menuItems,
                        postDetails: postDetails,
                        refresh: refresh,
                        feedRoomId: feedRoomId,
                        topics: topics,
                        isFeed: isFeed,
                      )
                    : const SizedBox()
              ],
            )
          ],
        ),
      ),
    );
  }
}
