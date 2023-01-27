part of 'all_comments_bloc.dart';

abstract class AllCommentsEvent extends Equatable {
  const AllCommentsEvent();
}

class GetAllComments extends AllCommentsEvent {
  final int offset;
  final bool forLoadMore;
  GetAllComments({required this.offset, required this.forLoadMore});
  @override
  List<Object?> get props => [offset, forLoadMore];
}
