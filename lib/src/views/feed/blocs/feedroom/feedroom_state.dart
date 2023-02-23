part of 'feedroom_bloc.dart';

abstract class FeedRoomState extends Equatable {
  const FeedRoomState();

  @override
  List<Object> get props => [];
}

class FeedRoomInitial extends FeedRoomState {}

class FeedRoomLoading extends FeedRoomState {}

class FeedRoomEmpty extends FeedRoomState {
  final GetFeedOfFeedRoomResponse feed;
  final GetFeedRoomResponse feedRoom;
  FeedRoomEmpty({
    required this.feedRoom,
    required this.feed,
  });
  @override
  List<Object> get props => [feedRoom];
}

class FeedRoomLoaded extends FeedRoomState {
  final GetFeedOfFeedRoomResponse feed;
  final GetFeedRoomResponse feedRoom;
  final bool hasReachedMax;
  FeedRoomLoaded(
      {required this.feedRoom,
      required this.feed,
      required this.hasReachedMax});
  @override
  List<Object> get props => [feedRoom];
}

class FeedRoomListLoaded extends FeedRoomState {
  final List<GetFeedRoomResponse> feedRooms;
  final bool hasReachedMax;

  FeedRoomListLoaded({required this.feedRooms, required this.hasReachedMax});
  @override
  List<Object> get props => [feedRooms];
}

class FeedRoomListLoading extends FeedRoomState {}

class FeedRoomListEmpty extends FeedRoomState {}

class FeedRoomError extends FeedRoomState {
  final String message;
  FeedRoomError({required this.message});
  @override
  List<Object> get props => [message];
}
