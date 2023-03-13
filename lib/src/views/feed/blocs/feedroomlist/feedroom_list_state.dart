part of 'feedroom_list_bloc.dart';

abstract class FeedRoomListState extends Equatable {
  const FeedRoomListState();

  @override
  List<Object> get props => [];
}

class FeedRoomListInitial extends FeedRoomListState {}

class FeedRoomListLoading extends FeedRoomListState {}

class FeedRoomListEmpty extends FeedRoomListState {}

class FeedRoomListLoaded extends FeedRoomListState {
  final List<FeedRoom> feedList;
  final int size;
  const FeedRoomListLoaded({required this.feedList, required this.size});
  @override
  List<Object> get props => [feedList];
}

class FeedRoomListError extends FeedRoomListState {
  final String message;
  const FeedRoomListError({required this.message});
  @override
  List<Object> get props => [message];
}
