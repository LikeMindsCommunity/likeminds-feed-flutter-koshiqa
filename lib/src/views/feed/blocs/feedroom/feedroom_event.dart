part of 'feedroom_bloc.dart';

abstract class FeedRoomEvent extends Equatable {
  const FeedRoomEvent();

  @override
  List<Object> get props => [];
}

class GetFeedRoom extends FeedRoomEvent {
  final int feedRoomId;
  final FeedRoom? feedRoom;

  GetFeedRoom({
    this.feedRoom,
    required this.feedRoomId,
  });
  @override
  List<Object> get props => [feedRoomId];
}

class GetFeedRoomList extends FeedRoomEvent {}
