import 'package:collection/collection.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/report_post/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:likeminds_feed/likeminds_feed.dart' as sdk;

class DropdownOptions extends StatelessWidget {
  final Post postDetails;
  final List<PopupMenuItemModel> menuItems;
  final Function(bool) refresh;

  DropdownOptions({
    super.key,
    required this.menuItems,
    required this.postDetails,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (ctx) {
      return PopupMenuButton<int>(
        itemBuilder: (context) => menuItems
            .mapIndexed((index, element) => PopupMenuItem(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  height: 42,
                  value: index,
                  child: Text(element.title),
                  onTap: () async {
                    if (element.title.split(' ').first == "Delete") {
                      final res =
                          await locator<LikeMindsService>().getMemberState();
                      //Implement delete post analytics tracking
                      LMAnalytics.get().track(
                        AnalyticsKeys.postDeleted,
                        {
                          "user_state": res ? "CM" : "member",
                          "post_id": postDetails.id,
                          "user_id": postDetails.userId,
                        },
                      );
                      final response =
                          await locator<LikeMindsService>().deletePost(
                        DeletePostRequest(
                          postId: postDetails.id,
                          deleteReason: "deleteReason",
                        ),
                      );
                      print(response.toString());
                      refresh(true);
                    } else if (element.title.split(' ').first == "Pin") {
                      print("Pinning functionality");
                    }
                  },
                ))
            .toList(),
        color: kWhiteColor,
        child: const SizedBox(
          height: 24,
          width: 24,
          child: Icon(
            Icons.more_horiz,
            color: kGrey1Color,
            size: 24,
          ),
        ),
      );
    });
  }
}
