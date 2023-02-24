import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';

class LikesScreen extends StatefulWidget {
  static const String route = "/likes_screen";
  final GetPostLikesResponse response;
  final String postId;
  const LikesScreen({
    super.key,
    required this.response,
    required this.postId,
  });

  @override
  State<LikesScreen> createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  @override
  Widget build(BuildContext context) {
    final GetPostLikesResponse response = widget.response;
    LMAnalytics.get().logEvent(
      AnalyticsKeys.likeListOpen,
      {
        "post_id": widget.postId,
        "total_likes": response.totalCount,
      },
    );
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 64),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              children: [
                kHorizontalPaddingSmall,
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                kHorizontalPaddingSmall,
                Text(
                  "${response.totalCount} Likes",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          kVerticalPaddingLarge,
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return LikesTile(user: response.users?.values.toList()[index]);
              },
              itemCount: response.totalCount,
            ),
          ),
        ],
      ),
    );
  }
}

class LikesTile extends StatelessWidget {
  final PostUser? user;
  const LikesTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      return user!.isDeleted
          ? DeletedLikesTile()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      color: kPrimaryColor,
                    ),
                    height: 54,
                    width: 54,
                    child: user!.imageUrl.isEmpty
                        ? Center(
                            child: Text(
                              user!.name[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : Image.network(user!.imageUrl),
                  ),
                  kHorizontalPaddingSmall,
                  kHorizontalPaddingMedium,
                  Text(
                    user!.name,
                    style: const TextStyle(
                        fontSize: kFontMedium, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            );
    } else {
      return Container(
        child: Center(
          child: Text("No likes yet"),
        ),
      );
    }
  }
}

class DeletedLikesTile extends StatelessWidget {
  const DeletedLikesTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(27), color: kGreyBGColor),
            height: 54,
            width: 54,
          ),
          kHorizontalPaddingSmall,
          kHorizontalPaddingMedium,
          Text(
            'Deleted User',
            style: TextStyle(fontSize: kFontMedium, color: kGrey3Color),
          )
        ],
      ),
    );
  }
}
