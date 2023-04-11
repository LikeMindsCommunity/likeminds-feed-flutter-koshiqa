import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feed_sx/src/utils/analytics/analytics.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

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
      LMAnalytics.get().track(
        AnalyticsKeys.replyPosted,
        {
          "post_id": addCommentReplyRequest.postId,
          "comment_id": addCommentReplyRequest.commentId,
        },
      );
      emit(AddCommentReplySuccess(addCommentResponse: response));
    }
  }
}
