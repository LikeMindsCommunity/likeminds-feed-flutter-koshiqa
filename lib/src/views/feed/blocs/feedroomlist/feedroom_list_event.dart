part of 'feedroom_list_bloc.dart';

abstract class FeedRoomListEvent extends Equatable {
  const FeedRoomListEvent();
  @override
  List<Object> get props => [];
}

class GetFeedRoomList extends FeedRoomListEvent {
  final int offset;
  const GetFeedRoomList({required this.offset});
  @override
  List<Object> get props => [offset];
}
