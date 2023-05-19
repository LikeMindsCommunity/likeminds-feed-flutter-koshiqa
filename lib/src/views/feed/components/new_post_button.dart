import 'package:feed_sx/src/utils/constants/assets_constants.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/utils/local_preference/user_local_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:overlay_support/overlay_support.dart';

class NewPostButton extends StatelessWidget {
  final Function() onTap;
  const NewPostButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = UserLocalPreference.instance.fetchMemberRight(9);
    return GestureDetector(
      onTap: enabled
          ? onTap
          : () => toast("You do not have permission to create a post"),
      child: Container(
        height: 42,
        width: 142,
        decoration: BoxDecoration(
          color: enabled ? kPrimaryColor : kGrey3Color,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                kAssetNewPostIcon,
                height: 18,
                width: 18,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                'New Post'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
