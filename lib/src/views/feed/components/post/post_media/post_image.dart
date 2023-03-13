import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/navigation/arguments.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_image_shimmer.dart';
import 'package:feed_sx/src/views/previews/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:shimmer/shimmer.dart';

class PostImage extends StatefulWidget {
  final String postId;
  double? height;
  List<String>? url;
  List<File>? imagesFile;
  PostImage({
    super.key,
    this.height,
    this.url,
    required this.postId,
    this.imagesFile,
  });

  @override
  State<PostImage> createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {
  Size? screenSize;
  int currPosition = 0; // Current index of carousel

  bool checkIfMultipleAttachments() {
    return ((widget.url != null && widget.url!.length > 1) ||
        (widget.imagesFile != null && widget.imagesFile!.length > 1));
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
          ImagePreview.route,
          arguments: ImagePreviewArguments(
            url: widget.url!,
            postId: widget.postId,
          ),
        );
      },
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(top: kPaddingMedium),
          child: Column(children: [
            CarouselSlider(
              items: widget.url == null
                  ? widget.imagesFile!
                      .map((e) => Image.file(
                            e,
                            fit: BoxFit.cover,
                          ))
                      .toList()
                  : widget.url!
                      .map(
                        (e) => CachedNetworkImage(
                          imageUrl: e,
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(
                            milliseconds: 200,
                          ),
                          progressIndicatorBuilder: (context, url, progress) =>
                              getPostShimmer(screenSize!),
                        ),
                      )
                      .toList(),
              options: CarouselOptions(
                  aspectRatio: 1.0,
                  initialPage: 0,
                  disableCenter: true,
                  scrollDirection: Axis.horizontal,
                  enableInfiniteScroll: false,
                  enlargeFactor: 0.0,
                  viewportFraction: 1.0,
                  height: widget.height != null
                      ? max(widget.height! - 30, 0)
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
                    children: widget.url != null
                        ? widget.url!.map((url) {
                            int index = widget.url!.indexOf(url);
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
                        : widget.imagesFile!.map((url) {
                            int index = widget.imagesFile!.indexOf(url);
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
          ])),
    );
  }
}
