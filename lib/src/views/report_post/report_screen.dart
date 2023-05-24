import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/widgets/general_app_bar.dart';
import 'package:flutter/material.dart';

class ReportPostScreen extends StatefulWidget {
  static const String route = "/report_post_screen";
  const ReportPostScreen({super.key});

  @override
  State<ReportPostScreen> createState() => _ReportPostScreenState();
}

class _ReportPostScreenState extends State<ReportPostScreen> {
  List<String> reportOptions = [
    'Nudity',
    'Inappropriate Language',
    'Hate Speech',
    'Terrorism',
    'Spam',
    'Others',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: const GeneralAppBar(
        title: Text(
          'Report Abuse',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.red),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Please specify the problem to continue',
              style: TextStyle(
                  color: kGrey1Color,
                  fontWeight: FontWeight.w500,
                  fontSize: kFontMedium),
            ),
            kVerticalPaddingSmall,
            const Text(
              'You would be able to report this post after selecting a problem.',
              style: TextStyle(
                  color: kGrey2Color,
                  // fontWeight: FontWeight.w500,
                  fontSize: kFontMedium),
            ),
            kVerticalPaddingSmall,
            kVerticalPaddingMedium,
            Wrap(
              spacing: 10,
              children: reportOptions
                  .map((e) => Chip(
                        side: const BorderSide(color: kGrey2Color),
                        label: Text(
                          e,
                          style: const TextStyle(color: kGrey2Color),
                        ),
                        backgroundColor: kWhiteColor,
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
