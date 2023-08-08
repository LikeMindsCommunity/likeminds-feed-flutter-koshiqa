import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:likeminds_feed_ui_fl/likeminds_feed_ui_fl.dart';

class PostTopic extends StatelessWidget {
  final List<TopicViewModel> postTopics;
  const PostTopic({
    Key? key,
    required this.postTopics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (postTopics.isEmpty) {
      return const SizedBox();
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TopicFeedGrid(
        showDivider: false,
        height: 22,
        chipPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        selectedTopics: postTopics,
        backgroundColor: kPrimaryColor.withOpacity(0.1),
        onTap: () {},
        textColor: kPrimaryColor,
        textStyle: const TextStyle(color: kPrimaryColor, fontSize: 14),
      ),
    );
  }
}
