import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/services/service_locator.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

part 'tagging_event.dart';
part 'tagging_state.dart';

class TaggingBloc extends Bloc<TaggingEvent, TaggingState> {
  TaggingBloc() : super(TaggingInitial()) {
    on<TaggingEvent>((event, emit) async {
      if (event is GetTaggingListEvent) {
        emit(TaggingLoading());
        try {
          final taggingData = await locator<LikeMindsService>().getTags(
            feedroomId: event.feedroomId,
          );
          emit(TaggingLoaded(taggingData: taggingData));
        } catch (e) {
          emit(TaggingError());
        }
      }
    });
  }
}
