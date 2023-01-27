part of 'all_comments_bloc.dart';

abstract class AllCommentsState extends Equatable {
  const AllCommentsState();
}

class AllCommentsInitial extends AllCommentsState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class AllCommentsLoaded extends AllCommentsState {
  final AllCommentsResponse feed;
  final bool hasReachedMax;
  AllCommentsLoaded({required this.feed, required this.hasReachedMax});

  @override
  List<Object?> get props => [feed, hasReachedMax];
}

class AllCommentsLoading extends AllCommentsState {
  @override
  List<Object?> get props => [];
}

class PaginatedAllCommentsLoading extends AllCommentsState {
  @override
  List<Object?> get props => [];
}

class AllCommentsError extends AllCommentsState {
  final String message;
  AllCommentsError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
