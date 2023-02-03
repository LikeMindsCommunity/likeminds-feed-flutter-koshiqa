import 'dart:io';

import 'package:dio/dio.dart';
import 'package:feed_sx/src/utils/constants/assets_constants.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/feed/blocs/download_doc/download_doc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart';

class PostDocument extends StatefulWidget {
  final String url;
  final String type;
  final String size;

  const PostDocument(
      {super.key, required this.url, required this.size, required this.type});

  @override
  State<PostDocument> createState() => _PostDocumentState();
}

class _PostDocumentState extends State<PostDocument> {
  late final String _fileName;
  late final String _fileExtension;
  late final String _fileSize;
  late final String url;
  late final DownloadDocBloc _downloadDocBloc;
  @override
  void initState() {
    super.initState();
    url = widget.url;
    File file = File(url);
    _fileExtension = widget.type;
    _fileSize = widget.size;
    _fileName = basenameWithoutExtension(file.path);
    _downloadDocBloc = DownloadDocBloc(Dio());
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_downloadDocBloc.state is Downloaded) {
          // TODO : Open file
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: kPaddingMedium),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: kGreyWebBGColor, width: 1),
              borderRadius: BorderRadius.circular(kBorderRadiusMedium)),
          padding: EdgeInsets.all(kPaddingLarge),
          child: Row(
            children: [
              SvgPicture.asset(kAssetDocPDFIcon),
              kHorizontalPaddingMedium,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _fileName,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: kFontMedium, color: kGrey2Color),
                    ),
                    kVerticalPaddingSmall,
                    Row(
                      children: [
                        Text(
                          '2 Pages',
                          style: TextStyle(
                              fontSize: kFontSmall, color: kGrey3Color),
                        ),
                        kHorizontalPaddingXSmall,
                        Text(
                          '·',
                          style: TextStyle(
                              fontSize: kFontSmall, color: kGrey3Color),
                        ),
                        kHorizontalPaddingXSmall,
                        Text(
                          '$_fileSize KB',
                          style: TextStyle(
                              fontSize: kFontSmall, color: kGrey3Color),
                        ),
                        kHorizontalPaddingXSmall,
                        Text(
                          '·',
                          style: TextStyle(
                              fontSize: kFontSmall, color: kGrey3Color),
                        ),
                        kHorizontalPaddingXSmall,
                        Text(
                          _fileExtension,
                          style: TextStyle(
                              fontSize: kFontSmall, color: kGrey3Color),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              BlocConsumer<DownloadDocBloc, DownloadDocState>(
                bloc: _downloadDocBloc,
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  if (state is Downloading) {
                    return SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        value: state.progress / 100,
                      ),
                    );
                  }
                  if (state is Downloaded) {
                    return SizedBox.shrink();
                  }
                  return IconButton(
                    icon: Icon(Icons.download_for_offline_outlined),
                    onPressed: () {
                      _downloadDocBloc.add(Download(url: url));
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
