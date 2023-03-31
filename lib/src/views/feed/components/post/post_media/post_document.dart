import 'dart:io';

import 'package:dio/dio.dart';
import 'package:feed_sx/src/utils/constants/assets_constants.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/feed/components/post/post_media/post_image_shimmer.dart';
import 'package:feed_sx/src/widgets/close_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PostDocument extends StatefulWidget {
  String? url;
  final String type;
  final String size;
  File? docFile;
  int? index;
  Function(int)? removeAttachment;

  PostDocument(
      {super.key,
      this.docFile,
      this.url,
      this.removeAttachment,
      this.index,
      required this.size,
      required this.type});

  @override
  State<PostDocument> createState() => _PostDocumentState();
}

class _PostDocumentState extends State<PostDocument> {
  String? _fileName;
  String? _fileExtension;
  String? _fileSize;
  String? url;
  File? file;

  Future loadFile() async {
    File file;
    if (widget.url != null) {
      final String url = widget.url!;
      file = File(url);
    } else {
      file = widget.docFile!;
    }
    _fileExtension = widget.type;
    _fileSize = widget.size;
    _fileName = basenameWithoutExtension(file.path);
    return file;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadFile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return InkWell(
              onTap: () async {
                if (widget.url != null) {
                  print(widget.url);
                  Uri fileUrl = Uri.parse(widget.url!);
                  launchUrl(fileUrl, mode: LaunchMode.externalApplication);
                } else {
                  OpenFilex.open(widget.docFile!.path);
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: kPaddingMedium),
                child: Container(
                  height: 78,
                  decoration: BoxDecoration(
                      border: Border.all(color: kGreyWebBGColor, width: 1),
                      borderRadius: BorderRadius.circular(kBorderRadiusMedium)),
                  padding: const EdgeInsets.all(kPaddingLarge),
                  child: Row(
                    children: [
                      SvgPicture.asset(kAssetDocPDFIcon),
                      kHorizontalPaddingMedium,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _fileName ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: kFontMedium, color: kGrey2Color),
                            ),
                            kVerticalPaddingSmall,
                            Row(
                              children: [
                                kHorizontalPaddingXSmall,
                                Text(
                                  _fileSize!.toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: kFontSmall, color: kGrey3Color),
                                ),
                                kHorizontalPaddingXSmall,
                                const Text(
                                  '·',
                                  style: TextStyle(
                                      fontSize: kFontSmall, color: kGrey3Color),
                                ),
                                kHorizontalPaddingXSmall,
                                Text(
                                  _fileExtension!.toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: kFontSmall, color: kGrey3Color),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      widget.docFile != null
                          ? GestureDetector(
                              onTap: () {
                                widget.removeAttachment!(widget.index!);
                              },
                              child: const CloseIcon())
                          : const SizedBox.shrink()
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return getDocumentTileShimmer();
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}
