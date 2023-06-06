import 'package:equatable/equatable.dart';
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(NotificationsInitial()) {
    on<NotificationsEvent>(
      (event, emit) async {
        if (event is GetNotifications) {
          if (event.offset > 1) {
            emit(NotificationsPaginationLoading());
          } else {
            emit(NotificationsLoading());
          }
          try {
            GetNotificationFeedResponse? response =
                await locator<LikeMindsService>().getNotificationFeed(
              (GetNotificationFeedRequestBuilder()
                    ..page(event.offset)
                    ..pageSize(event.pageSize))
                  .build(),
            );

            if (response.success) {
              emit(
                NotificationsLoaded(response: response),
              );
            } else {
              emit(
                const NotificationsError(
                    message: "An error occurred, Please try again"),
              );
            }
          } catch (e) {
            emit(
              NotificationsError(message: "${e.toString()} No data found"),
            );
          }
        }
      },
    );
  }
}
