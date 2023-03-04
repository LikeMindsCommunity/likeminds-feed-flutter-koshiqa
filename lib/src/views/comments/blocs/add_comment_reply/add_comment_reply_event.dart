part of 'add_comment_reply_bloc.dart';

abstract class AddCommentReplyEvent extends Equatable {
  const AddCommentReplyEvent();

  @override
  List<Object> get props => [];
}

// Add Comment events
class AddCommentReply extends AddCommentReplyEvent {
  final AddCommentReplyRequest addCommentRequest;
  AddCommentReply({required this.addCommentRequest});

  @override
  List<Object> get props => [addCommentRequest];
}
