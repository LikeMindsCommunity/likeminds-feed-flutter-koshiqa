import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/navigation/router.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/utils/utils.dart';
import 'package:feed_sx/src/views/tagging/helpers/tagging_helper.dart';
import 'package:feed_sx/src/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

class NotificationTile extends StatelessWidget {
  final NotificationFeedItem response;
  final ValueNotifier<bool> rebuildNotificationTile = ValueNotifier(false);
  final Map<String, User> users;

  NotificationTile({
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
        response.isRead = true;
        rebuildNotificationTile.value = !rebuildNotificationTile.value;
      },
      child: ValueListenableBuilder(
        valueListenable: rebuildNotificationTile,
        builder: (context, _, __) => Container(
          width: screenSize.width,
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          color: response.isRead ? kWhiteColor : notificationRedColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  users[response.actionBy.last] != null
                      ? Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ProfilePicture(
                                user: users[response.actionBy.last]!),
                            getNotificationAttachmentTag(),
                          ],
                        )
                      : const SizedBox(),
                  kHorizontalPaddingLarge,
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                          children: TaggingHelper.extractNotificationTags(
                        response.activityText,
                      )),
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
      ),
    );
  }

  Widget getNotificationAttachmentTag() {
    if (response.activityEntityData.attachments == null ||
        response.activityEntityData.attachments!.isEmpty ||
        response.activityEntityData.attachments!.first.attachmentType == 4) {
      return const SizedBox();
    }

    int getAttachmentType =
        response.activityEntityData.attachments!.first.attachmentType;
    String getSvgURL = '';
    switch (getAttachmentType) {
      case 1:
        getSvgURL = assetButtonData[1]['svg_icon'];
        break;
      case 2:
        getSvgURL = assetButtonData[1]['svg_icon'];
        break;
      case 3:
        getSvgURL = 'packages/feed_sx/assets/icons/doc_pdf.svg';
        break;
      default:
    }

    return Positioned(
      bottom: -2.5,
      right: 3,
      child: Container(
        width: 18,
        height: 18,
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kWhiteColor,
            boxShadow: [
              BoxShadow(
                color: kGrey1Color.withOpacity(0.25),
                blurRadius: 10.0,
                spreadRadius: 0.0,
                offset: const Offset(0.0, 0.0),
              ),
            ]),
        child: Center(
          child: SvgPicture.asset(
            getSvgURL,
            color: kPrimaryColor,
            height: 28,
          ),
        ),
      ),
    );
  }
}
