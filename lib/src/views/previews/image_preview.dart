import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_image_shimmer.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatefulWidget {
  static const route = '/image_preview';
  final List<String>? url;
  final List<File>? images;
  final String postId;

  const ImagePreview({
    super.key,
    this.url,
    this.images,
    required this.postId,
  });

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  Size? screenSize;
  int currPosition = 0;

  bool checkIfMultipleAttachments() {
    return ((widget.url != null && widget.url!.length > 1) ||
        (widget.images != null && widget.images!.length > 1));
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
          title: const Text('Image Preview',
              style: TextStyle(fontSize: kFontMedium, color: kGrey1Color)),
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
                items: widget.url == null
                    ? widget.images!
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
                            progressIndicatorBuilder:
                                (context, url, progress) =>
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
                    height: screenSize!.width,
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
                          : widget.images!.map((url) {
                              int index = widget.images!.indexOf(url);
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
        ),
      ),
    );
  }
}
