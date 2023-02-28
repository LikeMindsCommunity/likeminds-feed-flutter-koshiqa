part of 'tagging_bloc.dart';

abstract class TaggingEvent extends Equatable {
  const TaggingEvent();

  @override
  List<Object> get props => [];
}

class GetTaggingListEvent extends TaggingEvent {
  final int? feedroomId;
  final int? page;
  final int? limit;
  final String? search;
  final bool isPaginationEvent;

  GetTaggingListEvent({
    this.feedroomId,
    this.page,
    this.limit,
    this.search,
    this.isPaginationEvent = false,
  });
}
