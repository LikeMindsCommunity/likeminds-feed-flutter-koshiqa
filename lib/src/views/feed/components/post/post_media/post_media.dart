import 'package:feed_sx/src/views/feed/components/post/post_media/media_model.dart';
import 'package:feed_sx/src/widgets/close_icon.dart';
import 'package:flutter/material.dart';

import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_image_shimmer.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_video.dart';

import 'package:likeminds_feed/likeminds_feed.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PostMedia extends StatefulWidget {
  final String postId;
  double? height;
  List<Attachment>? attachments;
  List<MediaModel>? mediaFiles;
  Function(int)? removeAttachment;
  PostMedia({
    super.key,
    this.height,
    this.attachments,
    this.removeAttachment,
    required this.postId,
    this.mediaFiles,
  });

  @override
  State<PostMedia> createState() => _PostMediaState();
}

class _PostMediaState extends State<PostMedia> {
  Size? screenSize;
  int currPosition = 0;
  // Current index of carousel

  bool checkIfMultipleAttachments() {
    return ((widget.attachments != null && widget.attachments!.length > 1) ||
        (widget.mediaFiles != null && widget.mediaFiles!.length > 1));
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(top: kPaddingMedium),
      child: Column(
        children: [
          SizedBox(
            width: widget.height ?? screenSize!.width,
            height: widget.height ?? screenSize!.width,
            child: CarouselSlider(
              items: widget.attachments == null
                  ? widget.mediaFiles!.map((e) {
                      if (e.mediaType == MediaType.image) {
                        return Stack(
                          children: [
                            Image.file(
                              e.mediaFile!,
                              fit: BoxFit.contain,
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: GestureDetector(
                                  onTap: () {
                                    int fileIndex =
                                        widget.mediaFiles!.indexOf(e);
                                    if (fileIndex ==
                                        widget.mediaFiles!.length - 1) {
                                      currPosition -= 1;
                                    }
                                    widget.removeAttachment!(fileIndex);
                                    setState(() {});
                                  },
                                  child: const CloseIcon()),
                            )
                          ],
                        );
                      } else if (e.mediaType == MediaType.video) {
                        return Stack(
                          children: [
                            PostVideo(
                              videoFile: e.mediaFile,
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: () {
                                  int fileIndex = widget.mediaFiles!.indexOf(e);
                                  if (fileIndex ==
                                      widget.mediaFiles!.length - 1) {
                                    currPosition -= 1;
                                  }
                                  widget.removeAttachment!(fileIndex);
                                  setState(() {});
                                },
                                child: const CloseIcon(),
                              ),
                            )
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }).toList()
                  : widget.attachments!.map((e) {
                      if (e.attachmentType == 1) {
                        return CachedNetworkImage(
                          imageUrl: e.attachmentMeta.url!,
                          fit: BoxFit.contain,
                          fadeInDuration: const Duration(
                            milliseconds: 200,
                          ),
                          errorWidget: (context, url, error) {
                            return Container(
                              color: kBackgroundColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.error_outline,
                                    size: 24,
                                    color: kGrey3Color,
                                  ),
                                  SizedBox(height: 24),
                                  Text(
                                    "An error occurred fetching media",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
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
                  onPageChanged: (index, reason) {
                    setState(() {
                      currPosition = index;
                    });
                  }),
            ),
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
                            width: 8.0,
                            height: 8.0,
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
                            width: 8.0,
                            height: 8.0,
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
    );
  }
}
