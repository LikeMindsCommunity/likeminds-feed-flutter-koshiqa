import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

part 'add_comment_event.dart';
part 'add_comment_state.dart';

class AddCommentBloc extends Bloc<AddCommentEvent, AddCommentState> {
  AddCommentBloc() : super(AddCommentInitial()) {
    on<AddComment>(
      (event, emit) async {
        await _mapAddCommentToState(
          addCommentRequest: event.addCommentRequest,
          emit: emit,
        );
      },
    );
  }

  FutureOr<void> _mapAddCommentToState(
      {required AddCommentRequest addCommentRequest,
      required Emitter<AddCommentState> emit}) async {
    emit(AddCommentLoading());
    AddCommentResponse? response = await locator<LikeMindsService>()
        .getFeedApi()
        .addComment(addCommentRequest);
    if (response == null) {
      emit(const AddCommentError(message: "No data found"));
    } else {
      LMAnalytics.get().track(
        AnalyticsKeys.commentPosted,
        {
          "post_id": addCommentRequest.postId,
        },
      );
      emit(AddCommentSuccess(addCommentResponse: response));
    }
  }
}
