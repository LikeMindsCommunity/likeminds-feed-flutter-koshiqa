import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DropdownOptions extends StatelessWidget {
  DropdownOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        // popupmenu item 0
        PopupMenuItem(
          value: 0,
          // row has two child icon and text.
          child: Text("Follow Theresa Webb"),
        ),
        PopupMenuItem(
            value: 1,
            // row has two child icon and text.
            child: Text("Edit")),
        // popupmenu item 2
        PopupMenuItem(
            value: 2,
            // row has two child icon and text
            child: Text("Delete")),
      ],
      // offset: Offset(0, 100),
      color: kWhiteColor,
      // elevation: 2,
    );
  }
}
