import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/navigation/router.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/utils/expandable_text/expandable_text.dart';
import 'package:feed_sx/src/utils/utils.dart';
import 'package:feed_sx/src/views/tagging/helpers/tagging_helper.dart';
import 'package:feed_sx/src/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

class NotificationTile extends StatelessWidget {
  final NotificationFeedItem response;
  final Map<String, User> users;

  const NotificationTile({
    Key? key,
    required this.response,
    required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    DateTime createdAt =
        DateTime.fromMillisecondsSinceEpoch(response.createdAt);
    return GestureDetector(
      onTap: () {
        MarkReadNotificationRequest request =
            (MarkReadNotificationRequestBuilder()..activityId(response.id))
                .build();
        locator<LikeMindsService>().markReadNotification(request);
        if (response.cta != null) routeNotification(response.cta!);
      },
      child: Container(
        width: screenSize.width,
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        color: response.isRead ? notificationRedColor : kWhiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                users[response.actionBy.last] != null
                    ? ProfilePicture(user: users[response.actionBy.last]!)
                    : const SizedBox(),
                kHorizontalPaddingLarge,
                Expanded(
                  child: RichText(
                    text: TextSpan(
                        children: TaggingHelper.extractNotificationTags(
                            response.activityText)),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                kHorizontalPaddingLarge,
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 63),
              child: Text(
                createdAt.timeAgo(),
                style: const TextStyle(color: kGrey3Color, fontSize: 12),
              ),
            ),

            // PopupMenuButton(
            //   padding: EdgeInsets.zero,
            //   itemBuilder: (context) => const <PopupMenuEntry>[
            //     PopupMenuItem(
            //       child: Text(
            //         'Remove this notification',
            //       ),
            //     ),
            //     PopupMenuItem(
            //       child: Text(
            //         'Mute notification for this post',
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
