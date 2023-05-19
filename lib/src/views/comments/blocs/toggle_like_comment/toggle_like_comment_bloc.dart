import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

part 'toggle_like_comment_event.dart';
part 'toggle_like_comment_state.dart';

class ToggleLikeCommentBloc
    extends Bloc<ToggleLikeCommentEvent, ToggleLikeCommentState> {
  final FeedApi feedApi;
  ToggleLikeCommentBloc({required this.feedApi})
      : super(ToggleLikeCommentInitial()) {
    on<ToggleLikeComment>((event, emit) async {
      await _mapToggleLikeCommentToState(
        toggleLikeCommentRequest: event.toggleLikeCommentRequest,
        emit: emit,
      );
    });
  }

  _mapToggleLikeCommentToState(
      {required ToggleLikeCommentRequest toggleLikeCommentRequest,
      required Emitter<ToggleLikeCommentState> emit}) async {
    emit(ToggleLikeCommentLoading());
    ToggleLikeCommentResponse? response =
        await feedApi.toggleLikeComment(toggleLikeCommentRequest);
    if (response == null) {
      emit(const ToggleLikeCommentError(message: "No data found"));
    } else {
      emit(ToggleLikeCommentSuccess(toggleLikeCommentResponse: response));
    }
  }
}
