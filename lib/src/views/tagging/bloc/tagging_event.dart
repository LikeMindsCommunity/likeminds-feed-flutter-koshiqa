part of 'tagging_bloc.dart';

abstract class TaggingEvent extends Equatable {
  const TaggingEvent();

  @override
  List<Object> get props => [];
}

class GetTaggingListEvent extends TaggingEvent {
  final int? feedroomId;

  GetTaggingListEvent({this.feedroomId});
}
