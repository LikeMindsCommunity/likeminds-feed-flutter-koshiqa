import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:flutter/material.dart';

Dialog confirmationDialog(
  BuildContext context, {
  required String title,
  required String content,
  required Function() action,
  required String actionText,
}) {
  Size screenSize = MediaQuery.of(context).size;
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6.0),
    ),
    elevation: 5,
    child: Container(
      width: screenSize.width * 0.7,
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          kVerticalPaddingLarge,
          Text(content),
          kVerticalPaddingSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.zero,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: kGrey3Color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: action,
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.zero,
                  ),
                ),
                child: Text(
                  actionText,
                  style: const TextStyle(
                    color: kLinkColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}

SnackBar confirmationToast(
    {required String content, required Color backgroundColor, double? width}) {
  return SnackBar(
    backgroundColor: backgroundColor,
    width: width,
    margin: width == null ? const EdgeInsets.symmetric(horizontal: 30.0) : null,
    elevation: 5,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    content: Align(
      alignment: Alignment.center,
      child: Text(
        content,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
