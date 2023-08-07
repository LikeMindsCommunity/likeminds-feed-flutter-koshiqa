import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:likeminds_feed_ui_fl/likeminds_feed_ui_fl.dart';

part 'feedroom_event.dart';
part 'feedroom_state.dart';

class FeedRoomBloc extends Bloc<FeedRoomEvent, FeedRoomState> {
  FeedRoomBloc() : super(FeedRoomInitial()) {
    on<FeedRoomEvent>(
      (event, emit) async {
        Map<String, User> users = {};
        Map<String, Topic> topics = {};
        if (state is FeedRoomLoaded) {
          users = (state as FeedRoomLoaded).feed.users;
          topics = (state as FeedRoomLoaded).feed.topics;
        }
        if (event is GetFeedRoom) {
          event.isPaginationLoading
              ? emit(PaginationLoading())
              : emit(FeedRoomLoading());
          try {
            List<Topic> selectedTopics = [];
            if (event.topics != null && event.topics!.isNotEmpty) {
              selectedTopics = event.topics!.map((e) => e.toTopic()).toList();
            }
            GetFeedOfFeedRoomResponse? response =
                await locator<LikeMindsService>().getFeedOfFeedRoom(
              (GetFeedOfFeedRoomRequestBuilder()
                    ..feedroomId(event.feedRoomId)
                    ..topics(selectedTopics)
                    ..page(event.offset)
                    ..pageSize(10))
                  .build(),
            );
            if (!response.success) {
              emit(
                FeedRoomError(
                  message: response.errorMessage ?? 'An error occurred',
                ),
              );
            }
            GetFeedRoomResponse? feedRoomResponse =
                await locator<LikeMindsService>().getFeedRoom(
              (GetFeedRoomRequestBuilder()
                    ..feedroomId(event.feedRoomId)
                    ..page(event.offset))
                  .build(),
            );
            if (!feedRoomResponse.success) {
              emit(
                FeedRoomError(
                  message: feedRoomResponse.errorMessage ?? 'An error occurred',
                ),
              );
            }
            response.users.addAll(users);
            response.topics.addAll(topics);
            if ((response.posts == null || response.posts!.isEmpty) &&
                event.offset <= 1) {
              emit(
                FeedRoomEmpty(
                  feedRoom: feedRoomResponse.chatroom!,
                  feed: response,
                ),
              );
            } else {
              emit(
                FeedRoomLoaded(
                  feed: response,
                  feedRoom: feedRoomResponse.chatroom!,
                ),
              );
            }
          } catch (e) {
            emit(
              const FeedRoomError(
                message: 'An error occurred',
              ),
            );
          }
        }
      },
    );
  }
}
