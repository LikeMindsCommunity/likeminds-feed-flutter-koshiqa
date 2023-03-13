part of 'feedroom_bloc.dart';

abstract class FeedRoomEvent extends Equatable {
  const FeedRoomEvent();

  @override
  List<Object> get props => [];
}

class GetFeedRoom extends FeedRoomEvent {
  final int feedRoomId;
  final int offset;
  final bool isPaginationLoading;
  final FeedRoom? feedRoomResponse;
  GetFeedRoom({
    required this.feedRoomId,
    required this.offset,
    this.isPaginationLoading = false,
    this.feedRoomResponse,
  });
  @override
  List<Object> get props => [feedRoomId];
}
