import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';

part 'feedroom_event.dart';
part 'feedroom_state.dart';

class FeedRoomBloc extends Bloc<FeedRoomEvent, FeedRoomState> {
  FeedRoomBloc() : super(FeedRoomInitial()) {
    on<FeedRoomEvent>((event, emit) async {
      if (event is GetFeedRoom) {
        emit(FeedRoomLoading());
        try {
          GetFeedOfFeedRoomResponse? feedResponse =
              await locator<LikeMindsService>().getFeedOfFeedRoom(
            GetFeedOfFeedRoomRequest(
              feedroomId: event.feedRoomId,
              page: 1,
              pageSize: 20,
            ),
          );

          GetFeedRoomResponse? feedRoomResponse =
              await locator<LikeMindsService>().getFeedRoom(
            GetFeedRoomRequest(
              page: 1,
              feedroomId: event.feedRoomId,
            ),
          );
          final FeedRoom feedRoom = feedRoomResponse.chatroom!;

          if (!feedResponse.success) {
            emit(FeedRoomError(message: "An error has occured"));
          } else {
            if (feedResponse.posts == null || feedResponse.posts!.isEmpty) {
              emit(FeedRoomEmpty(
                feedRoom: feedRoom,
                feed: feedResponse,
              ));
            } else {
              emit(FeedRoomLoaded(
                feed: feedResponse,
                feedRoom: feedRoom,
              ));
            }
          }
        } catch (e) {
          emit(FeedRoomError(message: "${e.toString()}"));
        }
      } else if (event is GetFeedRoomList) {
        emit(FeedRoomLoading());
        try {
          GetFeedRoomResponse? response = await locator<LikeMindsService>()
              .getFeedRoom(GetFeedRoomRequest(page: 1));
          final List<FeedRoom> feedList = response.chatrooms!;

          if (response.success) {
            emit(FeedRoomListLoaded(
              feedList: feedList,
              size: feedList.length,
            ));
          } else {
            emit(FeedRoomError(
              message: "No data found",
            ));
          }
        } catch (e) {
          emit(FeedRoomError(
            message: "${e.toString()} No data found",
          ));
        }
      }
    });
  }
}
