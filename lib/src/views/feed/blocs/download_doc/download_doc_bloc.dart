// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

part 'download_doc_event.dart';
part 'download_doc_state.dart';

class DownloadDocBloc extends Bloc<DownloadDocEvent, DownloadDocState> {
  final Dio dioClient;

  DownloadDocBloc(
    this.dioClient,
  ) : super(DownloadDocInitial()) {
    on<Download>((event, emit) async {
      final String url = event.url;
      final File file = File(url);
      final String name = basename(file.path);

      try {
        var dir = await getTemporaryDirectory();
        final String savePath = '${dir.path}/$name';
        print(dir);

        await dioClient.download(url, savePath,
            onReceiveProgress: (rec, total) {
          // print(rec.toString() + "l");
          if (rec == total) {
            emit(Downloaded(path: Uri(path: savePath, scheme: 'file')));
          } else {
            emit(Downloading(progress: ((rec / total) * 100)));
          }
        });
      } catch (expception) {
        emit(DownloadError(message: expception.toString()));
      }
    });
  }
}
