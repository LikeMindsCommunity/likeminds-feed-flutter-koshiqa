import 'package:feed_sx/src/data/models/branding/branding.dart';
import 'package:flutter/material.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';

ThemeData getThemeDataFromBrandingData(Branding? branding) {
  final ThemeData lightTheme = ThemeData.light();
  final ThemeData brandedTheme = lightTheme.copyWith(
    primaryColor: branding?.basic?.primaryColor,
    tabBarTheme: lightTheme.tabBarTheme.copyWith(
      labelColor: branding?.advanced?.textLinksColor,
      unselectedLabelColor: kGreyColor,
    ),
    buttonTheme: lightTheme.buttonTheme
        .copyWith(buttonColor: branding?.advanced?.buttonIconsColor),
    errorColor: Colors.red,
  );
  return brandedTheme;
}
