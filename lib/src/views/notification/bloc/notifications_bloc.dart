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
            // GetNotificationFeedResponse? response =
            //     await locator<LikeMindsService>().getNotificationFeed(
            //   (GetNotificationFeedResponse()).build(),
            // );

            // if (response.success) {
            //   emit(
            //     NotificationsLoaded(response: response),
            //   );
            // } else {
            //   emit(
            //     const NotificationsError(message: "An error occurred, Please try again"),
            //   );
            // }
            await Future.delayed(
              const Duration(seconds: 3),
            );
            List<Map<String, dynamic>> response = [
              {
                'isRead': false,
                'name': "Anurag Tyagi",
                'action': "likes a post",
                'time': '4 days ago',
                'post':
                    "This is the actual post bla bla bla, Here is the list of all the social media tool to help get started withcommunity building and more",
              },
              {
                'isRead': false,
                'name': "Divyansh Gandhi",
                'action': "commented on",
                'time': '4 days ago',
                'post':
                    "This is the actual post bla bla bla, Here is the list of all the social media tool to help get started withcommunity building and more",
              },
              {
                'isRead': true,
                'name': "Anurag Tyagi",
                'action': "likes a post",
                'time': '4 days ago',
                'post':
                    "This is the actual post bla bla bla, Here is the list of all the social media tool to help get started withcommunity building and more",
              },
              {
                'isRead': true,
                'name': "Anurag Tyagi",
                'action': "likes a post",
                'time': '4 days ago',
                'post':
                    "This is the actual post bla bla bla, Here is the list of all the social media tool to help get started withcommunity building and more",
              },
              {
                'isRead': false,
                'name': "Anurag Tyagi",
                'action': "likes a post",
                'time': '4 days ago',
                'post':
                    "This is the actual post bla bla bla, Here is the list of all the social media tool to help get started withcommunity building and more",
              },
              {
                'isRead': false,
                'name': "Anurag Tyagi",
                'action': "likes a post",
                'time': '4 days ago',
                'post':
                    "This is the actual post bla bla bla, Here is the list of all the social media tool to help get started withcommunity building and more",
              },
              {
                'isRead': false,
                'name': "Anurag Tyagi",
                'action': "likes a post",
                'time': '4 days ago',
                'post':
                    "This is the actual post bla bla bla, Here is the list of all the social media tool to help get started withcommunity building and more",
              },
              {
                'isRead': true,
                'name': "Anurag Tyagi",
                'action': "likes a post",
                'time': '4 days ago',
                'post':
                    "This is the actual post bla bla bla, Here is the list of all the social media tool to help get started withcommunity building and more",
              },
              {
                'isRead': true,
                'name': "Anurag Tyagi",
                'action': "likes a post",
                'time': '4 days ago',
                'post':
                    "This is the actual post bla bla bla, Here is the list of all the social media tool to help get started withcommunity building and more",
              },
              {
                'isRead': true,
                'name': "Anurag Tyagi",
                'action': "likes a post",
                'time': '4 days ago',
                'post':
                    "This is the actual post bla bla bla, Here is the list of all the social media tool to help get started withcommunity building and more",
              },
            ];
            emit(NotificationsLoaded(response: response));
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
