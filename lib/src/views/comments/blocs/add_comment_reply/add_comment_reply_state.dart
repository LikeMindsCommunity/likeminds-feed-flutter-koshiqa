part of 'add_comment_reply_bloc.dart';

abstract class AddCommentReplyState extends Equatable {
  const AddCommentReplyState();

  @override
  List<Object> get props => [];
}

class AddCommentReplyInitial extends AddCommentReplyState {}

class AddCommentReplyLoading extends AddCommentReplyState {}

class AddCommentReplySuccess extends AddCommentReplyState {
  final AddCommentReplyResponse addCommentResponse;
  AddCommentReplySuccess({required this.addCommentResponse});
}

class AddCommentReplyError extends AddCommentReplyState {
  final String message;
  AddCommentReplyError({required this.message});
}
