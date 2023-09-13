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
  final List<TopicUI>? topics;
  final FeedRoom? feedRoomResponse;
  const GetFeedRoom({
    required this.feedRoomId,
    required this.offset,
    this.isPaginationLoading = false,
    this.feedRoomResponse,
    this.topics,
  });
  @override
  List<Object> get props => [feedRoomId];
}
