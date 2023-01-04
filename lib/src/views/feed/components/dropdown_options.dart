import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DropdownOptions extends StatelessWidget {
  DropdownOptions({super.key});
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  String dropdownvalue = 'Item 1';
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        // popupmenu item 1
        PopupMenuItem(
          value: 1,
          // row has two child icon and text.
          child: Row(
            children: [
              Icon(Icons.star),
              SizedBox(
                // sized box with width 10
                width: 10,
              ),
              Text("Get The App")
            ],
          ),
        ),
        // popupmenu item 2
        PopupMenuItem(
          value: 2,
          // row has two child icon and text
          child: Row(
            children: [
              Icon(Icons.chrome_reader_mode),
              SizedBox(
                // sized box with width 10
                width: 10,
              ),
              Text("About")
            ],
          ),
        ),
      ],
      offset: Offset(0, 100),
      color: Colors.grey,
      elevation: 2,
    );
  }
}
