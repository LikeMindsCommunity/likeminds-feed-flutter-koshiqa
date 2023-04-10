part of 'new_post_bloc.dart';

abstract class NewPostEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateNewPost extends NewPostEvents {
  final List<MediaModel>? postMedia;
  final User? user;
  final String postText;
  final int feedRoomId;

  CreateNewPost({
    this.postMedia,
    required this.postText,
    this.user,
    required this.feedRoomId,
  });
}
