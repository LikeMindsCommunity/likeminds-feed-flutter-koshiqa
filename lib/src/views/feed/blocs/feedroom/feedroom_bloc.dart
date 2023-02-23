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
      Map<String, PostUser> users = {};
      if (state is FeedRoomLoaded) {
        users = (state as FeedRoomLoaded).feed.users;
      }
      if (event is GetFeedRoom) {
        emit(FeedRoomLoading());
        GetFeedOfFeedRoomResponse? response =
            await locator<LikeMindsService>().getFeedOfFeedRoom(
          GetFeedOfFeedRoomRequest(
            feedroomId: event.feedRoomId,
            page: event.offset,
            pageSize: 10,
          ),
        );
        GetFeedRoomResponse? feedRoomResponse =
            await locator<LikeMindsService>().getFeedRoom(
          GetFeedRoomRequest(
            feedroomId: event.feedRoomId,
            page: event.offset,
          ),
        );
        if (!response.success) {
          emit(FeedRoomError(message: "No data found"));
        } else {
          response.users.addAll(users);
          if (response.posts == null || response.posts!.isEmpty) {
            emit(FeedRoomEmpty(
              feedRoom: feedRoomResponse,
              feed: response,
            ));
          } else {
            emit(FeedRoomLoaded(
                feed: response,
                feedRoom: feedRoomResponse,
                hasReachedMax: response.posts!.isEmpty));
          }
        }
      } else if (event is GetFeedRoomList) {
        emit(FeedRoomLoading());
        List<GetFeedRoomResponse> feedRooms = [];
        try {
          for (int feedRoomId in event.feedRoomIds) {
            GetFeedRoomResponse? response =
                await locator<LikeMindsService>().getFeedRoom(
              GetFeedRoomRequest(
                feedroomId: feedRoomId,
                page: event.offset,
              ),
            );
            if (response.success) {
              feedRooms.add(response);
            }
          }
          if (feedRooms.isEmpty && event.offset > 1) {
            emit(FeedRoomListLoaded(feedRooms: feedRooms, hasReachedMax: true));
          } else if (feedRooms.isEmpty) {
            emit(FeedRoomListEmpty());
          } else {
            emit(
                FeedRoomListLoaded(feedRooms: feedRooms, hasReachedMax: false));
          }
        } catch (e) {
          emit(FeedRoomError(message: "${e.toString()} No data found"));
        }
      }
    });
  }
}
