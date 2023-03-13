import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget getPostShimmer(Size screenSize) {
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
