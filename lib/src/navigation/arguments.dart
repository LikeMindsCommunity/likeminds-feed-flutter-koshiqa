import 'dart:io';

import 'package:likeminds_feed_ui_fl/likeminds_feed_ui_fl.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

class AllCommentsScreenArguments {
  final String postId;
  final int feedRoomId;
  final bool fromComment;
  const AllCommentsScreenArguments({
    required this.postId,
    required this.feedRoomId,
    this.fromComment = false,
  });
}

class LikesScreenArguments {
  final String postId;
  String? commentId;
  bool isCommentLikes;
  LikesScreenArguments({
    required this.postId,
    this.commentId,
    this.isCommentLikes = false,
  });
}

class NewPostScreenArguments {
  final int feedroomId;
  final String feedRoomTitle;
  String? populatePostText;
  List<MediaModel>? populatePostMedia;
  bool isCm;
  NewPostScreenArguments({
    required this.feedroomId,
    required this.feedRoomTitle,
    required this.isCm,
    this.populatePostMedia,
    this.populatePostText,
  });
}

class EditPostScreenArguments {
  String postId;
  int feedRoomId;

  EditPostScreenArguments({
    required this.postId,
    required this.feedRoomId,
  });
}

class MediaPreviewArguments {
  final String? postId;
  final List<Attachment>? attachments;
  final List<MediaModel>? mediaFiles;
  final String? mediaUrl;
  final File? mediaFile;

  MediaPreviewArguments({
    this.attachments,
    this.mediaFiles,
    this.postId,
    this.mediaUrl,
    this.mediaFile,
  });
}

class DocumentPreviewArguments {
  final String docUrl;
  DocumentPreviewArguments({
    required this.docUrl,
  });
}

class FeedRoomSelectArguments {
  final User user;
  List<FeedRoom> feedRoomIds;
  FeedRoomSelectArguments({
    required this.user,
    required this.feedRoomIds,
  });
}

class TopicSelectScreenArguments {
  final List<TopicViewModel> selectedTopic;
  final Function(List<TopicViewModel>) onSelect;

  TopicSelectScreenArguments({
    required this.selectedTopic,
    required this.onSelect,
  });
}
