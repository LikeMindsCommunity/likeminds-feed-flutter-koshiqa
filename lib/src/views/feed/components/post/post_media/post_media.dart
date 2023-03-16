import 'dart:math';

import 'package:flutter/material.dart';

import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/navigation/arguments.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_image_shimmer.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_video.dart';
import 'package:feed_sx/src/views/previews/media_preview.dart';

import 'package:likeminds_feed/likeminds_feed.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PostMedia extends StatefulWidget {
  final String postId;
  double? height;
  List<Attachment>? attachments;
  List<Map<String, dynamic>>? mediaFiles;
  PostMedia({
    super.key,
    this.height,
    this.attachments,
    required this.postId,
    this.mediaFiles,
  });

  @override
  State<PostMedia> createState() => _PostMediaState();
}

class _PostMediaState extends State<PostMedia> {
  Size? screenSize;
  int currPosition = 0; // Current index of carousel

  bool checkIfMultipleAttachments() {
    return ((widget.attachments != null && widget.attachments!.length > 1) ||
        (widget.mediaFiles != null && widget.mediaFiles!.length > 1));
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        LMAnalytics.get().track(AnalyticsKeys.clickedOnAttachment, {
          "post_id": widget.postId,
          "type": "photo",
        });
        locator<NavigationService>().navigateTo(
          MediaPreview.route,
          arguments: widget.attachments == null
              ? MediaPreviewArguments(
                  mediaFiles: widget.mediaFiles!,
                  postId: widget.postId,
                )
              : MediaPreviewArguments(
                  attachments: widget.attachments!,
                  postId: widget.postId,
                ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: kPaddingMedium),
        child: Column(
          children: [
            CarouselSlider(
              items: widget.attachments == null
                  ? widget.mediaFiles!.map((e) {
                      if (e['mediaType'] == 1) {
                        return Image.file(
                          e['mediaFile'],
                          fit: BoxFit.cover,
                        );
                      } else if (e['mediaType'] == 2) {
                        return PostVideo(
                          videoFile: e['mediaFile'],
                        );
                      }
                      return const SizedBox.shrink();
                    }).toList()
                  : widget.attachments!.map((e) {
                      if (e.attachmentType == 1) {
                        return CachedNetworkImage(
                          imageUrl: e.attachmentMeta.url!,
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(
                            milliseconds: 200,
                          ),
                          progressIndicatorBuilder: (context, url, progress) =>
                              const PostShimmer(),
                        );
                      } else if ((e.attachmentType == 2)) {
                        return PostVideo(
                          url: e.attachmentMeta.url,
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }).toList(),
              options: CarouselOptions(
                  aspectRatio: 1.0,
                  initialPage: 0,
                  disableCenter: true,
                  scrollDirection: Axis.horizontal,
                  enableInfiniteScroll: false,
                  enlargeFactor: 0.0,
                  viewportFraction: 1.0,
                  height: widget.height != null
                      ? max(widget.height! - 38, 0)
                      : screenSize!.width,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currPosition = index;
                    });
                  }),
            ),
            checkIfMultipleAttachments()
                ? kVerticalPaddingMedium
                : const SizedBox(),
            checkIfMultipleAttachments()
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.attachments != null
                        ? widget.attachments!.map((url) {
                            int index = widget.attachments!.indexOf(url);
                            return Container(
                              width:
                                  widget.height != null && widget.height! < 150
                                      ? 4.0
                                      : 8.0,
                              height:
                                  widget.height != null && widget.height! < 150
                                      ? 4.0
                                      : 8.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 7.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currPosition == index
                                    ? const Color.fromRGBO(0, 0, 0, 0.9)
                                    : const Color.fromRGBO(0, 0, 0, 0.4),
                              ),
                            );
                          }).toList()
                        : widget.mediaFiles!.map((data) {
                            int index = widget.mediaFiles!.indexOf(data);
                            return Container(
                              width:
                                  widget.height != null && widget.height! < 150
                                      ? 4.0
                                      : 8.0,
                              height:
                                  widget.height != null && widget.height! < 150
                                      ? 4.0
                                      : 8.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 7.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currPosition == index
                                    ? const Color.fromRGBO(0, 0, 0, 0.9)
                                    : const Color.fromRGBO(0, 0, 0, 0.4),
                              ),
                            );
                          }).toList(),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
