import 'package:feed_sx/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: Image.asset('packages/feed_sx/assets/images/hamburger.png'),
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark),
      backgroundColor: kwhiteColor,
      title: const Text(
        'SCALIX',
        style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black),
      ),
      actions: const [
        Icon(
          Icons.search,
          color: Colors.black,
        ),
        kHorizontalLargeP,
        CircleAvatar(
          backgroundColor: Color(0xff5046E5),
          radius: 20,
          child: Center(
            child: Text(
              'KA',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: kwhiteColor,
                  fontSize: kFontSmall),
            ),
          ),
        ),
        kHorizontalLargeP,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}
