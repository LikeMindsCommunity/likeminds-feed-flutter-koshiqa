import 'package:collection/collection.dart';
import 'package:feed_sdk/feed_sdk.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/report_post/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:feed_sdk/feed_sdk.dart' as sdk;

class DropdownOptions extends StatelessWidget {
  final Post postDetails;
  final List<PopupMenuItemModel> menuItems;

  DropdownOptions({
    super.key,
    required this.menuItems,
    required this.postDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (ctx) {
      return PopupMenuButton<int>(
        itemBuilder: (context) => menuItems
            .mapIndexed((index, element) => PopupMenuItem(
                  value: index,
                  child: Text(element.title),
                  onTap: () async {
                    if (element.title.split(' ').first == "Delete") {
                      final response =
                          await locator<LikeMindsService>().deletePost(
                        DeletePostRequest(
                            postId: postDetails.id,
                            deleteReason: "deleteReason"),
                      );
                      print(response.toString());
                    } else if (element.title.split(' ').first == "Pin") {
                      print("Pinning functionality");
                    }
                  },
                ))
            .toList(),
        color: kWhiteColor,
      );
    });
  }
}
