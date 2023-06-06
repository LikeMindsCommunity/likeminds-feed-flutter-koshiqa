import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/tagging/helpers/tagging_helper.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

class NotificationTile extends StatelessWidget {
  final NotificationFeedItem response;
  const NotificationTile({Key? key, required this.response}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text = TaggingHelper.convertRouteToTag(response.activityText);
    Size screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        MarkReadNotificationRequest request =
            (MarkReadNotificationRequestBuilder()..activityId(response.id))
                .build();
        locator<LikeMindsService>().markReadNotification(request);
      },
      child: Container(
        width: screenSize.width,
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        color: response.isRead ? notificationRedColor : kWhiteColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const CircleAvatar(
              backgroundColor: kGrey1Color,
              child: SizedBox(
                height: 40,
                width: 40,
              ),
            ),
            kHorizontalPaddingLarge,
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: kGrey1Color,
                  wordSpacing: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            kHorizontalPaddingLarge,
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
