import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

class ProfilePicture extends StatelessWidget {
  final double size;
  const ProfilePicture({Key? key, required this.user, this.size = 48})
      : super(key: key);

  final PostUser user;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size / 2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }
}
