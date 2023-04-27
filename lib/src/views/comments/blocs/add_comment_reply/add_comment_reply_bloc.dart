import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/utils/analytics/analytics.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

part 'add_comment_reply_event.dart';

part 'add_comment_reply_state.dart';

class AddCommentReplyBloc
    extends Bloc<AddCommentReplyEvent, AddCommentReplyState> {
  AddCommentReplyBloc() : super(AddCommentReplyInitial()) {
    on<AddCommentReply>(
      (event, emit) async {
        await _mapAddCommentReplyToState(
          addCommentReplyRequest: event.addCommentRequest,
          emit: emit,
        );
      },
    );
    on<EditReplyCancel>(
      (event, emit) {
        emit(EditReplyCanceled());
      },
    );
    on<EditingReply>((event, emit) {
      emit(
        ReplyEditingStarted(
          commentId: event.commentId,
          text: event.text,
          replyId: event.replyId,
        ),
      );
    });
    on<EditReply>((event, emit) async {
      emit(EditReplyLoading());
      EditCommentReplyResponse? response = await locator<LikeMindsService>()
          .getFeedApi()
          .editCommentReply(event.editCommentReplyRequest);
      if (response == null) {
        emit(const EditReplyError(message: "An error occurred"));
      } else {
        emit(EditReplySuccess(editCommentReplyResponse: response));
      }
    });
    on<EditCommentCancel>(
      (event, emit) {
        emit(EditCommentCanceled());
      },
    );
    on<EditingComment>((event, emit) {
      emit(
        CommentEditingStarted(
          commentId: event.commentId,
          text: event.text,
        ),
      );
    });
    on<EditComment>((event, emit) async {
      emit(EditCommentLoading());
      EditCommentResponse? response = await locator<LikeMindsService>()
          .getFeedApi()
          .editComment(event.editCommentRequest);
      if (response == null) {
        emit(const EditCommentError(message: "An error occurred"));
      } else {
        emit(EditCommentSuccess(editCommentResponse: response));
      }
    });
  }

  FutureOr<void> _mapAddCommentReplyToState(
      {required AddCommentReplyRequest addCommentReplyRequest,
      required Emitter<AddCommentReplyState> emit}) async {
    emit(AddCommentReplyLoading());
    AddCommentReplyResponse? response = await locator<LikeMindsService>()
        .getFeedApi()
        .addCommentReply(addCommentReplyRequest);
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
