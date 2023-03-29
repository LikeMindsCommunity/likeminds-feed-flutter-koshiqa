import 'package:feed_sx/src/views/feed/components/post/post_media/media_model.dart';
import 'package:flutter/material.dart';

import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_image_shimmer.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_video.dart';

import 'package:likeminds_feed/likeminds_feed.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MediaPreview extends StatefulWidget {
  static const route = '/media_preview';
  final List<Attachment>? attachments;
  final List<MediaModel>? mediaFiles;
  final String postId;

  const MediaPreview({
    super.key,
    this.attachments,
    this.mediaFiles,
    required this.postId,
  });

  @override
  State<MediaPreview> createState() => _MediaPreviewState();
}

class _MediaPreviewState extends State<MediaPreview> {
  Size? screenSize;
  int currPosition = 0;

  /* If multiple attachments are there,
  then we need to show  */
  bool checkIfMultipleAttachments() {
    return ((widget.attachments != null && widget.attachments!.length > 1) ||
        (widget.mediaFiles != null && widget.mediaFiles!.length > 1));
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CarouselSlider(
                items: widget.attachments == null
                    ? widget.mediaFiles!.map(
                        (e) {
                          if (e.mediaType == MediaType.image) {
                            return Image.file(
                              e.mediaFile,
                              fit: BoxFit.cover,
                            );
                          } else if (e.mediaType == MediaType.video) {
                            // return video player widget
                            return PostVideo(
                              videoFile: e.mediaFile,
                              width: screenSize!.width,
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ).toList()
                    : widget.attachments!.map((e) {
                        if (e.attachmentType == 1) {
                          return CachedNetworkImage(
                            imageUrl: e.attachmentMeta.url!,
                            fit: BoxFit.cover,
                            fadeInDuration: const Duration(
                              milliseconds: 200,
                            ),
                            progressIndicatorBuilder:
                                (context, url, progress) => const PostShimmer(),
                          );
                        } else if (e.attachmentType == 2) {
                          return PostVideo(
                            url: e.attachmentMeta.url,
                            width: screenSize!.width,
                          );
                        }
                        return const SizedBox.shrink();
                      }).toList(),
                options: CarouselOptions(
                  aspectRatio: 1.0,
                  initialPage: 0,
                  disableCenter: true,
                  scrollDirection: Axis.horizontal,
                  enableInfiniteScroll: false,
                  enlargeFactor: 0.0,
                  viewportFraction: 1.0,
                  height: screenSize!.width,
                  onPageChanged: (index, reason) {
                    setState(
                      () {
                        currPosition = index;
                      },
                    );
                  },
                ),
              ),
              checkIfMultipleAttachments()
                  ? kVerticalPaddingMedium
                  : const SizedBox(),
              checkIfMultipleAttachments()
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.attachments != null
                          ? widget.attachments!.map(
                              (url) {
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
                              },
                            ).toList()
                          : widget.mediaFiles!.map(
                              (data) {
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
                              },
                            ).toList(),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
