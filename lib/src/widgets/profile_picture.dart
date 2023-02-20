import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    Key? key,
    required this.user,
  }) : super(key: key);

  final PostUser user;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: user.name.isNotEmpty ? kPrimaryColor : kGrey3Color,
        image: user.imageUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(user.imageUrl),
              )
            : null,
      ),
      child: user.imageUrl.isEmpty
          ? Center(
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }
}
