import 'package:feed_sx/src/utils/constants/assets_constants.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GeneralAppBar extends StatelessWidget with PreferredSizeWidget {
  final Widget? title;
  final bool autoImplyEnd;
  final double elevation;
  final Function()? backTap;
  const GeneralAppBar({
    Key? key,
    this.title,
    this.autoImplyEnd = true,
    this.elevation = 0,
    this.backTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: BackButton(
        onPressed: backTap ??
            () {
              Navigator.pop(context);
            },
      ),
      actions: [
        autoImplyEnd
            ? GestureDetector(
                child: SvgPicture.asset(kAssetCrossIcon),
                onTap: () {
                  Navigator.pop(context);
                })
            : SizedBox.shrink(),
        kHorizontalPaddingLarge,
      ],
      iconTheme: IconThemeData(color: kHeadingColor),
      elevation: elevation,
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark),
      backgroundColor: kWhiteColor,
      title: title,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}
