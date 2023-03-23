import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/navigation/arguments.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_document.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_helper.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:feed_sx/src/views/previews/document_preview.dart';

Widget postDocumentFactory(List<Attachment>? attachments, double width) {
  if (attachments!.length == 1) {
    return SizedBox(
      height: width,
      width: width,
      child: Stack(
        children: [
          SfPdfViewer.network(
            attachments.first.attachmentMeta.url!,
            scrollDirection: PdfScrollDirection.horizontal,
            canShowPaginationDialog: false,
            enableDoubleTapZooming: false,
          ),
          GestureDetector(
            onTap: () {
              locator<NavigationService>().navigateTo(
                DocumentPreview.route,
                arguments: DocumentPreviewArguments(
                  docUrl: attachments.first.attachmentMeta.url!,
                ),
              );
            },
            behavior: HitTestBehavior.translucent,
            child: SizedBox(
              height: width,
              width: width,
            ),
          )
        ],
      ),
    );
  } else {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: width - 32,
        child: Column(
          children: attachments
              .map((e) => PostDocument(
                  size: getFileSizeString(bytes: e.attachmentMeta.size!),
                  url: e.attachmentMeta.url,
                  type: e.attachmentMeta.format!))
              .toList(),
        ),
      ),
    );
  }
}
