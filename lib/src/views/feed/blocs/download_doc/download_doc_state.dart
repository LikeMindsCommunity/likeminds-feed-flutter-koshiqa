// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'download_doc_bloc.dart';

@immutable
abstract class DownloadDocState extends Equatable {}

class DownloadDocInitial extends DownloadDocState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Downloading extends DownloadDocState {
  final double progress;
  Downloading({
    required this.progress,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [progress];
}

class Downloaded extends DownloadDocState {
  final Uri path;
  Downloaded({
    required this.path,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [path];
}

class DownloadError extends DownloadDocState {
  final String message;
  DownloadError({
    required this.message,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
