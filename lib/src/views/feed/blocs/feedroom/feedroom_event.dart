part of 'feedroom_bloc.dart';

abstract class FeedRoomEvent extends Equatable {
  const FeedRoomEvent();

  @override
  List<Object> get props => [];
}

class GetFeedRoom extends FeedRoomEvent {
  final int feedRoomId;
  final int offset;
  final bool forLoadMore;
  final GetFeedRoomResponse? feedRoomResponse;
  GetFeedRoom({
    required this.feedRoomId,
    required this.offset,
    required this.forLoadMore,
    this.feedRoomResponse,
  });
  @override
  List<Object> get props => [feedRoomId];
}

class GetFeedRoomList extends FeedRoomEvent {
  final List<int> feedRoomIds;
  final int offset;
  final bool forLoadMore;
  GetFeedRoomList(
      {required this.feedRoomIds,
      required this.offset,
      required this.forLoadMore});
  @override
  List<Object> get props => [feedRoomIds];
}
