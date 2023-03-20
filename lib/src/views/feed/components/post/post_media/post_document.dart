import 'dart:io';

import 'package:dio/dio.dart';
import 'package:feed_sx/src/utils/constants/assets_constants.dart';
import 'package:feed_sx/src/utils/constants/ui_constants.dart';
import 'package:feed_sx/src/views/feed/blocs/download_doc/download_doc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PostDocument extends StatefulWidget {
  String? url;
  final String type;
  final String size;
  File? docFile;

  PostDocument(
      {super.key,
      this.docFile,
      this.url,
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
  late final DownloadDocBloc _downloadDocBloc;

  Future downloadFile() async {
    final String url = widget.url!;
    final File file = File(url);
    final String name = basename(file.path);

    try {
      var dir = await getTemporaryDirectory();
      final String savePath = '${dir.path}/$name';
      print(dir);

      var response = await Dio().download(url, savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (exception) {
      print(exception.toString());
    }
    return file;
  }

  Future loadFile() async {
    File file;
    if (widget.url != null) {
      url = widget.url!;
      file = await downloadFile();
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
    _downloadDocBloc = DownloadDocBloc(Dio());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadFile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return InkWell(
              onTap: () {
                if (_downloadDocBloc.state is Downloaded) {
                  // TODO : Open file
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
                                  _fileSize!,
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
                                  _fileExtension!,
                                  style: const TextStyle(
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
                            return const SizedBox.shrink();
                          }
                          return IconButton(
                            icon:
                                const Icon(Icons.download_for_offline_outlined),
                            onPressed: () {
                              _downloadDocBloc.add(Download(url: url!));
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}
