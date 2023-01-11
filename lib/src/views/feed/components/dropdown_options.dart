import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/report_post/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DropdownOptions extends StatelessWidget {
  DropdownOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (ctx) {
      return PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 0,
            child: Text("Follow Theresa Webb"),
          ),
          PopupMenuItem(value: 1, child: Text("Edit")),
          PopupMenuItem(
              value: 1,
              child: Text("Report"),
              onTap: () async {
                await Future.delayed(Duration.zero);
                Navigator.pushNamed(ctx, AllCommentsScreen.route);
              }),
          PopupMenuItem(value: 2, child: Text("Delete")),
        ],
        // offset: Offset(0, 100),
        color: kWhiteColor,
        // elevation: 2,
      );
    });
  }
}
