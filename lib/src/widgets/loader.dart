import 'package:likeminds_feed_flutter_koshiqa/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final bool isPrimary;

  const Loader({super.key, this.isPrimary = true});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: isPrimary ? kPrimaryColor : Colors.white,
    );
  }
}
