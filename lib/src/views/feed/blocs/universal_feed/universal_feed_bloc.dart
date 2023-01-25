import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feed_sdk/feed_sdk.dart';

part 'universal_feed_event.dart';
part 'universal_feed_state.dart';

class UniversalFeedBloc extends Bloc<UniversalFeedEvent, UniversalFeedState> {
  final FeedApi feedApi;
  UniversalFeedBloc({required this.feedApi}) : super(UniversalFeedInitial()) {
    on<UniversalFeedEvent>((event, emit) async {
      if (event is GetUniversalFeed) {
        await _mapGetUniversalFeedToState(
            offset: event.offset, forLoadMore: event.forLoadMore, emit: emit);
      }
    });
  }

  bool hasReachedMax(UniversalFeedState state, bool forLoadMore) =>
      state is UniversalFeedLoaded && state.hasReachedMax && forLoadMore;

  FutureOr<void> _mapGetUniversalFeedToState(
      {required int offset,
      required bool forLoadMore,
      required Emitter<UniversalFeedState> emit}) async {
    // if (!hasReachedMax(state, forLoadMore)) {
    print("hellobook");
    emit(UniversalFeedLoading());
    UniversalFeedResponse response =
        await feedApi.getUniversalFeed(UniversalFeedRequest(page: offset));
    emit(UniversalFeedLoaded(
        feed: response, hasReachedMax: response.posts.isEmpty));
    // try {
    //   List<BookingListModel> bookings = [];
    //   if (state is UniversalFeedLoaded && forLoadMore) {
    //     emit(MoreUniversalFeedLoading());
    //     bookings = (state as UniversalFeedLoaded).bookings;
    //   } else {
    //     emit(UniversalFeedLoading());
    //   }

    //   List<BookingListModel> moreBookings =
    //       await _repository.getUniversalFeed(offset: offset);
    //   emit(UniversalFeedLoaded(
    //       bookings: bookings + moreBookings,
    //       hasReachedMax:
    //           moreBookings.length != 10)); //page limit in apiconstants is 10
    // } catch (e) {
    //   emit(UniversalFeedError(message: e.toString()));
    // }
    // }
  }
}
