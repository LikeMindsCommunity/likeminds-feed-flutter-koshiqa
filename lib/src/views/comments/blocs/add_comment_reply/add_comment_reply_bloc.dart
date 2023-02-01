import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feed_sdk/feed_sdk.dart';

part 'add_comment_reply_event.dart';
part 'add_comment_reply_state.dart';

class AddCommentReplyBloc
    extends Bloc<AddCommentReplyEvent, AddCommentReplyState> {
  final FeedApi feedApi;
  AddCommentReplyBloc({required this.feedApi})
      : super(AddCommentReplyInitial()) {
    on<AddCommentReply>(
      (event, emit) async {
        await _mapAddCommentReplyToState(
          addCommentReplyRequest: event.addCommentRequest,
          emit: emit,
        );
      },
    );
  }

  FutureOr<void> _mapAddCommentReplyToState(
      {required AddCommentReplyRequest addCommentReplyRequest,
      required Emitter<AddCommentReplyState> emit}) async {
    emit(AddCommentReplyLoading());
    AddCommentReplyResponse? response =
        await feedApi.addCommentReply(addCommentReplyRequest);
    if (response == null) {
      emit(AddCommentReplyError(message: "No data found"));
    } else {
      emit(AddCommentReplySuccess(addCommentResponse: response));
    }
  }
}
