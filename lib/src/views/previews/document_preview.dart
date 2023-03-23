import 'package:flutter/material.dart';

import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocumentPreview extends StatelessWidget {
  static const route = '/document_preview';
  final String docURL;

  const DocumentPreview({
    super.key,
    required this.docURL,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        locator<NavigationService>().goBack();
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          elevation: 0,
          title: const Text(
            'Post Preview',
            style: TextStyle(fontSize: kFontMedium, color: kGrey1Color),
          ),
          leading: BackButton(
            color: kGrey1Color,
            onPressed: () {
              locator<NavigationService>().goBack();
            },
          ),
        ),
        body: Center(
          child: SizedBox(
            height: screenSize.width,
            width: screenSize.width,
            child: SfPdfViewer.network(
              docURL,
              scrollDirection: PdfScrollDirection.horizontal,
              canShowPaginationDialog: false,
            ),
          ),
        ),
      ),
    );
  }
}
