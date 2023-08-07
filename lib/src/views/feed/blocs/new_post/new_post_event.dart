part of 'new_post_bloc.dart';

abstract class NewPostEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateNewPost extends NewPostEvents {
  final List<MediaModel>? postMedia;
  final String postText;
  final int feedRoomId;
  final List<TopicViewModel> selectedTopics;

  CreateNewPost({
    this.postMedia,
    required this.postText,
    required this.feedRoomId,
    required this.selectedTopics,
  });
}

class EditPost extends NewPostEvents {
  final List<Attachment>? attachments;
  final String postText;
  final int? feedRoomId;
  final String postId;
  final List<TopicViewModel> selectedTopics;

  EditPost({
    required this.postText,
    this.attachments,
    this.feedRoomId,
    required this.postId,
    required this.selectedTopics,
  });
}
