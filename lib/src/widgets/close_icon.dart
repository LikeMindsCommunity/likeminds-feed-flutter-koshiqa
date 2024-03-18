import 'package:likeminds_feed_flutter_koshiqa/src/utils/constants/ui_constants.dart';
import 'package:flutter/cupertino.dart';

class CloseIcon extends StatelessWidget {
  const CloseIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: kWhiteColor,
        border: Border.all(
          color: kGrey1Color,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Icon(
        CupertinoIcons.xmark,
        color: kGrey1Color,
        size: 14,
      ),
    );
  }
}
