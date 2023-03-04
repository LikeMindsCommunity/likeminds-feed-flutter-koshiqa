import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/services/service_locator.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

part 'tagging_event.dart';
part 'tagging_state.dart';

class TaggingBloc extends Bloc<TaggingEvent, TaggingState> {
  static const FIXED_SIZE = 6;
  TaggingBloc() : super(TaggingInitial()) {
    on<TaggingEvent>((event, emit) async {
      if (event is GetTaggingListEvent) {
        event.isPaginationEvent
            ? emit(TaggingPaginationLoading())
            : emit(TaggingLoading());
        try {
          final taggingData = await locator<LikeMindsService>().getTags(
            feedroomId: event.feedroomId,
            page: event.page,
            pageSize: FIXED_SIZE,
            searchQuery: event.search,
          );
          if (taggingData.members != null && taggingData.members!.isNotEmpty) {
            emit(TaggingLoaded(taggingData: taggingData));
          }
        } catch (e) {
          emit(TaggingError());
        }
      }
    });
  }
}
