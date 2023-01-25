part of 'universal_feed_bloc.dart';

abstract class UniversalFeedState extends Equatable {
  const UniversalFeedState();
}

class UniversalFeedInitial extends UniversalFeedState {
  @override
  List<Object?> get props => [];
}

class UniversalFeedLoaded extends UniversalFeedState {
  final UniversalFeedResponse feed;
  final bool hasReachedMax;
  UniversalFeedLoaded({required this.feed, required this.hasReachedMax});

  @override
  List<Object?> get props => [feed, hasReachedMax];
}

class UniversalFeedLoading extends UniversalFeedState {
  @override
  List<Object?> get props => [];
}

class PaginatedUniversalFeedLoading extends UniversalFeedState {
  @override
  List<Object?> get props => [];
}

class UniversalFeedError extends UniversalFeedState {
  final String message;
  UniversalFeedError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
