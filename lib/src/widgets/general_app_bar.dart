import 'package:likeminds_feed_flutter_koshiqa/src/utils/constants/assets_constants.dart';
import 'package:likeminds_feed_flutter_koshiqa/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GeneralAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final bool autoImplyEnd;
  final double elevation;
  final Function()? backTap;
  final Color? backgroundColor;
  const GeneralAppBar({
    Key? key,
    this.title,
    this.autoImplyEnd = true,
    this.elevation = 0,
    this.backTap,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: BackButton(
        onPressed: backTap ??
            () {
              Navigator.pop(context);
            },
        color: backgroundColor == null ? null : kWhiteColor,
      ),
      actions: [
        autoImplyEnd
            ? GestureDetector(
                child: SvgPicture.asset(kAssetCrossIcon,
                    color: backgroundColor == null ? null : kWhiteColor),
                onTap: () {
                  Navigator.pop(context);
                })
            : const SizedBox.shrink(),
        kHorizontalPaddingLarge,
      ],
      iconTheme: const IconThemeData(color: kHeadingColor),
      elevation: elevation,
      backgroundColor: backgroundColor ?? kWhiteColor,
      title: title,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}
