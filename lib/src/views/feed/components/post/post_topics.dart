import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_feed_ui_fl/likeminds_feed_ui_fl.dart';

class PostTopics extends StatelessWidget {
  final List<TopicViewModel> postTopics;
  const PostTopics({Key? key, required this.postTopics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: postTopics.length,
        itemBuilder: (context, index) => LMTopicChip(
          topic: postTopics[index],
          textColor: kWhiteColor,
        ),
      ),
    );
  }
}
