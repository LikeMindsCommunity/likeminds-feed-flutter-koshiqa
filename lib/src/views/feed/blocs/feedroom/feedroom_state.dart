part of 'feedroom_bloc.dart';

abstract class FeedRoomState extends Equatable {
  const FeedRoomState();

  @override
  List<Object> get props => [];
}

class FeedRoomInitial extends FeedRoomState {}

class FeedRoomLoading extends FeedRoomState {}

class PaginationLoading extends FeedRoomState {}

class FeedRoomEmpty extends FeedRoomState {
  final GetFeedOfFeedRoomResponse feed;
  final FeedRoom feedRoom;
  const FeedRoomEmpty({
    required this.feedRoom,
    required this.feed,
  });
  @override
  List<Object> get props => [feedRoom, feed];
}

class FeedRoomLoaded extends FeedRoomState {
  final GetFeedOfFeedRoomResponse feed;
  final FeedRoom feedRoom;
  const FeedRoomLoaded({required this.feedRoom, required this.feed});
  @override
  List<Object> get props => [feedRoom, feed];
}

class FeedRoomError extends FeedRoomState {
  final String message;
  const FeedRoomError({required this.message});
  @override
  List<Object> get props => [message];
}
