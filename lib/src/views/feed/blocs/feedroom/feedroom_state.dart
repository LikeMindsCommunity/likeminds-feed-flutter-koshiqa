part of 'feedroom_bloc.dart';

abstract class FeedRoomState extends Equatable {
  const FeedRoomState();

  @override
  List<Object> get props => [];
}

class FeedRoomInitial extends FeedRoomState {}

class FeedRoomLoading extends FeedRoomState {}

class FeedRoomLoaded extends FeedRoomState {
  final GetFeedOfFeedRoomResponse feed;
  final GetFeedRoomResponse feedRoom;
  FeedRoomLoaded({
    required this.feedRoom,
    required this.feed,
  });
  @override
  List<Object> get props => [feedRoom];
}

class FeedRoomListLoaded extends FeedRoomState {
  final List<GetFeedRoomResponse> feedRooms;
  FeedRoomListLoaded({required this.feedRooms});
  @override
  List<Object> get props => [feedRooms];
}

class FeedRoomError extends FeedRoomState {
  final String message;
  FeedRoomError({required this.message});
  @override
  List<Object> get props => [message];
}
