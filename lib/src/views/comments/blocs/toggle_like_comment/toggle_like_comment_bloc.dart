import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

part 'toggle_like_comment_event.dart';
part 'toggle_like_comment_state.dart';

class ToggleLikeCommentBloc
    extends Bloc<ToggleLikeCommentEvent, ToggleLikeCommentState> {
  final CommentApi commentApi = locator<LikeMindsService>().getCommentApi();

  ToggleLikeCommentBloc() : super(ToggleLikeCommentInitial()) {
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
        await commentApi.toggleLikeComment(toggleLikeCommentRequest);
    if (response == null) {
      emit(const ToggleLikeCommentError(message: "No data found"));
    } else {
      emit(ToggleLikeCommentSuccess(toggleLikeCommentResponse: response));
    }
  }
}
