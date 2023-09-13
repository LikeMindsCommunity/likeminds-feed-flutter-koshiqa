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

  @override
  List<Object> get props => [progress];
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

  @override
  List<Object> get props => [postData, userData, topics];
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

  @override
  List<Object> get props => [postData, userData, topics];
}

class NewPostError extends NewPostState {
  final String message;

  const NewPostError({required this.message});

  @override
  List<Object> get props => [message];
}

class PostDeletionError extends NewPostState {
  final String message;

  const PostDeletionError({required this.message});

  @override
  List<Object> get props => [message];
}

class PostDeleted extends NewPostState {
  final String postId;

  const PostDeleted({required this.postId});

  @override
  List<Object> get props => [postId];
}
