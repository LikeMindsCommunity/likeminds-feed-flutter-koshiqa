import 'package:equatable/equatable.dart';
import 'package:likeminds_feed_flutter_koshiqa/feed.dart';
import 'package:likeminds_feed_flutter_koshiqa/src/services/likeminds_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

part 'feedroom_list_event.dart';
part 'feedroom_list_state.dart';

class FeedRoomListBloc extends Bloc<FeedRoomListEvent, FeedRoomListState> {
  FeedRoomListBloc() : super(FeedRoomListInitial()) {
    on<FeedRoomListEvent>((event, emit) async {
      if (event is GetFeedRoomList) {
        emit(FeedRoomListLoading());
        try {
          GetFeedRoomResponse? response =
              await locator<LikeMindsService>().getFeedRoom(
            (GetFeedRoomRequestBuilder()..page(event.offset)).build(),
          );
          final List<FeedRoom> feedList = response.chatrooms!;

          if (response.success) {
            emit(
              FeedRoomListLoaded(feedList: feedList, size: feedList.length),
            );
          } else {
            emit(
              const FeedRoomListError(
                  message: "An error occurred, Please try again"),
            );
          }
        } catch (e) {
          emit(
            FeedRoomListError(message: "${e.toString()} No data found"),
          );
        }
      }
    });
  }
}
