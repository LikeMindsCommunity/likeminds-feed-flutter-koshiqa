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

class EditPostUploading extends NewPostState {}

class NewPostUploaded extends NewPostState {
  final Post postData;
  final Map<String, User> userData;
  final Map<String, Topic> topics;

  const NewPostUploaded({
    required this.postData,
    required this.userData,
    required this.topics,
  });
}

class EditPostUploaded extends NewPostState {
  final Post postData;
  final Map<String, User> userData;
  final Map<String, Topic> topics;

  const EditPostUploaded({
    required this.postData,
    required this.userData,
    required this.topics,
  });
}

class NewPostError extends NewPostState {
  final String message;

  const NewPostError({required this.message});
}
