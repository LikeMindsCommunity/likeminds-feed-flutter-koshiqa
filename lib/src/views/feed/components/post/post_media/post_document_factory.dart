import 'package:feed_sx/src/views/feed/components/post/post_media/post_document.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_helper.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

Widget postDocumentFactory(List<Attachment>? attachments, double width) {
  return Align(
    alignment: Alignment.center,
    child: SizedBox(
      width: width - 32,
      child: Column(
        children: attachments!
            .map((e) => PostDocument(
                size: getFileSizeString(bytes: e.attachmentMeta.size!),
                url: e.attachmentMeta.url,
                type: e.attachmentMeta.format!))
            .toList(),
      ),
    ),
  );
}
