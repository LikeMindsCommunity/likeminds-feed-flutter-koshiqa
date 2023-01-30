part of 'add_comment_bloc.dart';

abstract class AddCommentState extends Equatable {
  const AddCommentState();

  @override
  List<Object> get props => [];
}

class AddCommentInitial extends AddCommentState {}

class AddCommentLoading extends AddCommentState {}

class AddCommentSuccess extends AddCommentState {
  final AddCommentResponse addCommentResponse;
  AddCommentSuccess({required this.addCommentResponse});
}

class AddCommentError extends AddCommentState {
  final String message;
  AddCommentError({required this.message});
}
