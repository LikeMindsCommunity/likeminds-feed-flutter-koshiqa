part of 'new_post_bloc.dart';

abstract class NewPostState extends Equatable {
  const NewPostState();

  @override
  List<Object> get props => [];
}

class NewPostInitiate extends NewPostState {}

class NewPostUploading extends NewPostState {
  final Stream<double> progress;
  final MediaModel? thumbnailMedia;

  const NewPostUploading({required this.progress, this.thumbnailMedia});
}

class NewPostUploaded extends NewPostState {
  final Post postData;
  final Map<String, PostUser> userData;

  const NewPostUploaded({required this.postData, required this.userData});
}

class NewPostError extends NewPostState {
  final String message;

  const NewPostError({required this.message});
}
