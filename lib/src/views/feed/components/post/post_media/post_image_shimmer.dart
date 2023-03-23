import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget getPostShimmer(double width) {
  return SizedBox(
    child: Shimmer.fromColors(
      baseColor: Colors.black26,
      highlightColor: Colors.black12,
      child: Container(
        color: Colors.white,
        width: width,
        height: width,
      ),
    ),
  );
}

class PostShimmer extends StatelessWidget {
  const PostShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Shimmer.fromColors(
      baseColor: Colors.black26,
      highlightColor: Colors.black12,
      child: Container(
        color: Colors.white,
        width: screenSize.width,
        height: screenSize.width,
      ),
    );
  }
}

Widget getDocumentTileShimmer() {
  return Container(
    height: 78,
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
        border: Border.all(color: kGreyWebBGColor, width: 1),
        borderRadius: BorderRadius.circular(kBorderRadiusMedium)),
    padding: const EdgeInsets.all(kPaddingLarge),
    child: Shimmer.fromColors(
      baseColor: Colors.black26,
      highlightColor: Colors.black12,
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        Container(
          height: 40,
          width: 35,
          color: kWhiteColor,
        ),
        kHorizontalPaddingLarge,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 8,
              width: 150,
              color: kWhiteColor,
            ),
            kVerticalPaddingMedium,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 6,
                  width: 50,
                  color: kWhiteColor,
                ),
                kHorizontalPaddingXSmall,
                const Text(
                  '·',
                  style: TextStyle(fontSize: kFontSmall, color: kGrey3Color),
                ),
                kHorizontalPaddingXSmall,
                Container(
                  height: 6,
                  width: 50,
                  color: kWhiteColor,
                ),
              ],
            )
          ],
        )
      ]),
    ),
  );
}
