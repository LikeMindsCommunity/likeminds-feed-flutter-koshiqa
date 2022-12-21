import 'package:feed_sx/src/data/models/branding/branding.dart';
import 'package:flutter/material.dart';

const Color kprimaryColor = Color(0xff5046E5);
const Color kwhiteColor = Color(0xffFFFFFF);
const Color kgreyColor = Color(0xff666666);
const Color kgrey1Color = Color(0xff222020);
const Color kgrey2Color = Color(0xff504B4B);
const Color kgrey3Color = Color(0xff9B9B9B);
const double kFontSmall = 12;
const double kButtonFontSize = 12;
const double kFontXSmall = 11;
const double kFontMedium = 16;
const double kPaddingXSmall = 2;
const double kPaddingSmall = 4;
const double kPaddingMedium = 8;
const double kPaddingLarge = 16;
const double kPaddingXLarge = 20;
const double kBorderRadiusXSmall = 2;
const SizedBox kHorizontalPaddingXLarge = SizedBox(width: kPaddingXLarge);
const SizedBox kHorizontalPaddingSmall = SizedBox(width: kPaddingSmall);
const SizedBox kHorizontalPaddingXSmall = SizedBox(width: kPaddingXSmall);
const SizedBox kHorizontalPaddingLarge = SizedBox(width: kPaddingLarge);
const SizedBox kHorizontalPaddingMedium = SizedBox(width: kPaddingMedium);
const SizedBox kVerticalPaddingXLarge = SizedBox(height: kPaddingXLarge);
const SizedBox kVerticalPaddingSmall = SizedBox(height: kPaddingSmall);
const SizedBox kVerticalPaddingXSmall = SizedBox(height: kPaddingXSmall);
const SizedBox kVerticalPaddingLarge = SizedBox(height: kPaddingLarge);
const SizedBox kVerticalPaddingMedium = SizedBox(height: kPaddingMedium);

ThemeData getThemeDataFromBrandingData(Branding? branding) {
  final ThemeData lightTheme = ThemeData.light();
  final ThemeData brandedTheme = lightTheme.copyWith(
    primaryColor: branding?.basic?.primaryColor,
    indicatorColor: const Color(0xFF807A6B),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    primaryIconTheme: lightTheme.primaryIconTheme.copyWith(
      color: Colors.white,
      size: 20,
    ),
    iconTheme: lightTheme.iconTheme.copyWith(
      color: Colors.white,
    ),
    backgroundColor: Colors.white,
    tabBarTheme: lightTheme.tabBarTheme.copyWith(
      labelColor: branding?.advanced?.textLinksColor,
      unselectedLabelColor: kgreyColor,
    ),
    buttonTheme: lightTheme.buttonTheme
        .copyWith(buttonColor: branding?.advanced?.buttonIconsColor),
    errorColor: Colors.red,
  );
  return brandedTheme;
}
