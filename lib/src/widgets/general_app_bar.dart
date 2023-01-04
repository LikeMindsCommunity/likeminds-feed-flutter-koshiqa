import 'package:feed_sx/src/utils/constants/assets_constants.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GeneralAppBar extends StatelessWidget with PreferredSizeWidget {
  final Widget? title;
  const GeneralAppBar({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        SvgPicture.asset(kAssetCrossIcon),
        kHorizontalPaddingLarge,
      ],
      elevation: 0,
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
