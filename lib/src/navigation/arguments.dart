import 'package:likeminds_feed/likeminds_feed.dart';

class AllCommentsScreenArguments {
  final Post post;
  AllCommentsScreenArguments({required this.post});
}

class LikesScreenArguments {
  final GetPostLikesResponse response;
  LikesScreenArguments({required this.response});
}

class NewPostScreenArguments {
  final User user;
  final int feedroomId;
  NewPostScreenArguments({required this.user, required this.feedroomId});
}

class ImagePreviewArguments {
  final String postId;
  final String url;
  ImagePreviewArguments({
    required this.url,
    required this.postId,
  });
}
