// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'download_doc_bloc.dart';

@immutable
abstract class DownloadDocState extends Equatable {}

class DownloadDocInitial extends DownloadDocState {
  @override
  List<Object?> get props => [];
}

class Downloading extends DownloadDocState {
  final double progress;
  Downloading({
    required this.progress,
  });
  @override
  List<Object?> get props => [progress];
}

class Downloaded extends DownloadDocState {
  final Uri path;
  Downloaded({
    required this.path,
  });
  @override
  List<Object?> get props => [path];
}

class DownloadError extends DownloadDocState {
  final String message;
  DownloadError({
    required this.message,
  });
  @override
  List<Object?> get props => [message];
}
