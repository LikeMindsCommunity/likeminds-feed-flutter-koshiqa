import 'package:cached_network_image/cached_network_image.dart';
import 'package:likeminds_feed_flutter_koshiqa/src/utils/constants/ui_constants.dart';
import 'package:likeminds_feed_ui_fl/likeminds_feed_ui_fl.dart';
import 'package:flutter/material.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:url_launcher/url_launcher.dart';

class PostLinkView extends StatelessWidget {
  const PostLinkView({
    super.key,
    required this.screenSize,
    this.attachment,
    this.linkModel,
  });

  final Size? screenSize;
  final MediaModel? linkModel;
  final Attachment? attachment;

  bool checkNullMedia() {
    return ((linkModel == null ||
            linkModel!.ogTags == null ||
            linkModel!.ogTags!.image == null ||
            linkModel!.ogTags!.image!.isEmpty) &&
        (attachment == null ||
            attachment!.attachmentMeta.ogTags == null ||
            attachment!.attachmentMeta.ogTags!.image == null));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        launchUrl(
          Uri.parse(linkModel == null
              ? attachment!.attachmentMeta.ogTags!.url!
              : linkModel!.link!),
          mode: LaunchMode.externalApplication,
        );
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: kWhiteColor,
          border: Border.all(
            color: kGrey3Color,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        width: screenSize!.width,
        child: Column(
          children: <Widget>[
            checkNullMedia()
                ? const SizedBox.shrink()
                : CachedNetworkImage(
                    width: screenSize!.width,
                    height: 150,
                    fit: BoxFit.cover,
                    maxHeightDiskCache: screenSize!.height.toInt(),
                    imageUrl: linkModel == null
                        ? attachment!.attachmentMeta.ogTags!.image!
                        : linkModel!.ogTags!.image!,
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: screenSize!.width,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: screenSize!.width,
                      child: Text(
                        linkModel == null
                            ? attachment!.attachmentMeta.ogTags!.title ?? ''
                            : linkModel!.ogTags!.title ?? '',
                        style: const TextStyle(
                          color: kGrey1Color,
                          fontSize: kFontMedium,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    kVerticalPaddingSmall,
                    SizedBox(
                      width: screenSize!.width,
                      child: Text(
                        linkModel == null
                            ? attachment!.attachmentMeta.ogTags!.description ??
                                ''
                            : linkModel!.ogTags!.description ?? '',
                        maxLines: 2,
                        style: const TextStyle(
                          color: kGrey3Color,
                          fontSize: kFontSmall,
                        ),
                      ),
                    ),
                    kVerticalPaddingXSmall,
                    SizedBox(
                      width: screenSize!.width,
                      child: Text(
                        linkModel == null
                            ? attachment!.attachmentMeta.ogTags!.url!
                                .toLowerCase()
                            : linkModel!.link!.toLowerCase(),
                        maxLines: 1,
                        style: const TextStyle(
                          color: kGrey3Color,
                          fontSize: kFontXSmall,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
