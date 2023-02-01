part of 'feedroom_bloc.dart';

abstract class FeedRoomEvent extends Equatable {
  const FeedRoomEvent();

  @override
  List<Object> get props => [];
}

class GetFeedRoom extends FeedRoomEvent {
  final int feedRoomId;
  final GetFeedRoomResponse? feedRoomResponse;
  GetFeedRoom({
    required this.feedRoomId,
    this.feedRoomResponse,
  });
  @override
  List<Object> get props => [feedRoomId];
}

class GetFeedRoomList extends FeedRoomEvent {
  final List<int> feedRoomIds;
  GetFeedRoomList({required this.feedRoomIds});
  @override
  List<Object> get props => [feedRoomIds];
}
