part of 'tagging_bloc.dart';

abstract class TaggingState extends Equatable {
  const TaggingState();

  @override
  List<Object> get props => [];
}

class TaggingInitial extends TaggingState {}

class TaggingLoading extends TaggingState {}

class TaggingPaginationLoading extends TaggingState {}

class TaggingLoaded extends TaggingState {
  final TagResponseModel taggingData;

  TaggingLoaded({required this.taggingData});
}

class TaggingError extends TaggingState {}
