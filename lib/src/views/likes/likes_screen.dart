import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';

class LikesScreen extends StatelessWidget {
  static const String route = "/likes_screen";
  const LikesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == 4) {
          return LikesTile(isDeleted: true);
        }
        return LikesTile(
          isDeleted: false,
        );
      },
      itemCount: 5,
    );
  }
}

class LikesTile extends StatelessWidget {
  final bool isDeleted;
  const LikesTile({super.key, required this.isDeleted});

  @override
  Widget build(BuildContext context) {
    return isDeleted
        ? DeletedLikesTile()
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(27),
                  ),
                  height: 54,
                  width: 54,
                  child:
                      Image.asset('packages/feed_sx/assets/images/avatar2.png'),
                ),
                kHorizontalPaddingSmall,
                kHorizontalPaddingMedium,
                Text(
                  'Theresa Webb',
                  style: TextStyle(
                      fontSize: kFontMedium, fontWeight: FontWeight.w500),
                )
              ],
            ),
          );
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
