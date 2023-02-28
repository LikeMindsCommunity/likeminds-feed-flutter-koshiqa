import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/feed/feedroom_screen.dart';
import 'package:feed_sx/src/views/tagging/helpers/tagging_helper.dart';
import 'package:feed_sx/src/views/tagging/tagging_textfield_ta.dart';
import 'package:feed_sx/src/widgets/text_with_links.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

class TaggingTestView extends StatefulWidget {
  const TaggingTestView({super.key});

  @override
  State<TaggingTestView> createState() => _TaggingTestViewState();
}

class _TaggingTestViewState extends State<TaggingTestView> {
  TextEditingController? controller;

  List<UserTag> userTags = [];
  String? result;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // leading: BackButton(),
          title: const Text('Tagging Test'),
          backgroundColor: kPrimaryColor,
          leading: IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              setState(() {
                userTags = TaggingHelper.matchTags(controller!.text, userTags);
                result = TaggingHelper.encodeString(controller!.text, userTags);
              });
            },
          )),
      body: Column(
        children: [
          kVerticalPaddingLarge,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  TaggingAheadTextField(
                    feedroomId: DUMMY_FEEDROOM,
                    isDown: true,
                    onTagSelected: (tag) {
                      print(tag);
                      userTags.add(tag);
                    },
                    getController: (controller) {
                      this.controller = controller;
                    },
                  ),
                  kVerticalPaddingLarge,
                  Expanded(
                    child: Visibility(
                      visible: result != null,
                      child: TextWithLinks(
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        text: result != null
                            ? TaggingHelper.decodeString(result!).toString()
                            : '',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
