part of 'add_comment_bloc.dart';

abstract class AddCommentEvent extends Equatable {
  const AddCommentEvent();

  @override
  List<Object> get props => [];
}

// Add Comment events
class AddComment extends AddCommentEvent {
  final AddCommentRequest addCommentRequest;
  AddComment({required this.addCommentRequest});

  @override
  List<Object> get props => [addCommentRequest];
}

class EditComment extends AddCommentEvent {
  final EditCommentRequest editCommentRequest;
  EditComment({required this.editCommentRequest});

  @override
  List<Object> get props => [editCommentRequest];
}

class EditCommentCancel extends AddCommentEvent {}

class EditingComment extends AddCommentEvent {
  final String commentId;
  final String text;

  const EditingComment({required this.commentId, required this.text});
}
