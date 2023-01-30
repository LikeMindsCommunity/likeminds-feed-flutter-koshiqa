import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/report_post/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:feed_sdk/feed_sdk.dart' as sdk;

class DropdownOptions extends StatelessWidget {
  final List<sdk.MenuItem> menuItems;

  const DropdownOptions({
    super.key,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (ctx) {
      return PopupMenuButton<int>(
        itemBuilder: (context) => menuItems
            .map((e) => PopupMenuItem(
                value: menuItems.indexOf(e), child: Text(e.title)))
            .toList(),
        // [
        //   PopupMenuItem(
        //     value: 0,
        //     child: Text("Follow Theresa Webb"),
        //   ),
        //   PopupMenuItem(value: 1, child: Text("Edit")),
        //   PopupMenuItem(
        //       value: 1,
        //       child: Text("Report"),
        //       onTap: () async {
        //         await Future.delayed(Duration.zero);
        //         Navigator.pushNamed(ctx, AllCommentsScreen.route);
        //       }),
        //   PopupMenuItem(value: 2, child: Text("Delete")),
        // ],
        // offset: Offset(0, 100),
        color: kWhiteColor,
        // elevation: 2,
      );
    });
  }
}
