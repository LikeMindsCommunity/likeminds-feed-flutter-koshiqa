part of 'add_comment_bloc.dart';

abstract class AddCommentState extends Equatable {
  const AddCommentState();

  @override
  List<Object> get props => [];
}

class AddCommentInitial extends AddCommentState {}

class AddCommentLoading extends AddCommentState {}

class EditingStarted extends AddCommentState {
  final String commentId;
  final String text;

  const EditingStarted({required this.commentId, required this.text});
}

class EditCommentLoading extends AddCommentState {}

class EditCommentCanceled extends AddCommentState {}

class EditCommentSuccess extends AddCommentState {
  final EditCommentResponse editCommentResponse;

  EditCommentSuccess({required this.editCommentResponse});
}

class EditCommentError extends AddCommentState {
  final String message;
  const EditCommentError({required this.message});
}

class AddCommentSuccess extends AddCommentState {
  final AddCommentResponse addCommentResponse;
  const AddCommentSuccess({required this.addCommentResponse});
}

class AddCommentError extends AddCommentState {
  final String message;
  AddCommentError({required this.message});
}
