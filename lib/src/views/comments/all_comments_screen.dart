// ignore_for_file: prefer_const_constructors

import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/comments/components/comment_tile.dart';
import 'package:feed_sx/src/views/feed/components/post/post_widget.dart';
import 'package:feed_sx/src/widgets/general_app_bar.dart';
import 'package:flutter/material.dart';

class AllCommentsScreen extends StatelessWidget {
  static const String route = "/all_comments_screen";
  const AllCommentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: GeneralAppBar(
        autoImplyEnd: false,
        title: const Text(
          'Post',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: kHeadingColor),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // SliverToBoxAdapter(
          //   child: PostWidget(
          //     postType: 1,
          //     showActions: false,
          //   ),
          // ),
          SliverPadding(
              padding: EdgeInsets.only(
            top: kPaddingLarge + kPaddingMedium,
          )),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingLarge),
              child: Text(
                '13 comments',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SliverPadding(padding: EdgeInsets.only(bottom: kPaddingSmall)),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return CommentTile();
            }, childCount: 5),
          )
        ],
      ),
    );
  }
}
