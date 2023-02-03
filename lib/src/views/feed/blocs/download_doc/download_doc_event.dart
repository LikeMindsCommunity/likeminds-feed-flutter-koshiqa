// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'download_doc_bloc.dart';

@immutable
abstract class DownloadDocEvent extends Equatable {}

class Download extends DownloadDocEvent {
  final String url;
  Download({
    required this.url,
  });

  @override
  List<Object?> get props => [url];
}

class CancelDownload extends DownloadDocEvent {
  @override
  List<Object?> get props => [];
}
