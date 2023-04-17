import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_document.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_helper.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

class PostDocumentFactory extends StatefulWidget {
  final List<Attachment>? attachments;
  final double width;
  const PostDocumentFactory({
    super.key,
    required this.attachments,
    required this.width,
  });

  @override
  State<PostDocumentFactory> createState() => _PostDocumentFactoryState();
}

class _PostDocumentFactoryState extends State<PostDocumentFactory> {
  List<PostDocument>? postDocData;
  bool isCollapsed = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.attachments != null) {
      postDocData = widget.attachments!
          .map((e) => PostDocument(
              size: getFileSizeString(bytes: e.attachmentMeta.size!),
              url: e.attachmentMeta.url,
              type: e.attachmentMeta.format!))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: widget.width - 32,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children:
                  postDocData != null && postDocData!.length > 3 && isCollapsed
                      ? postDocData!.sublist(0, 3)
                      : postDocData!,
            ),
            postDocData != null && postDocData!.length > 3 && isCollapsed
                ? GestureDetector(
                    onTap: () => setState(() {
                          isCollapsed = false;
                        }),
                    child: Text(
                      '+ ${postDocData!.length - 3} more',
                      style: const TextStyle(
                        color: kLinkColor,
                      ),
                    ))
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
