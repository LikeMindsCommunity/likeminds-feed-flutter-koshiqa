part of 'notifications_bloc.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsPaginationLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<dynamic> response;
  //final GetNotificationFeedRequest response;
  const NotificationsLoaded({required this.response});

  @override
  List<Object> get props => [response];
}

class NotificationsError extends NotificationsState {
  final String message;
  const NotificationsError({required this.message});

  @override
  List<Object> get props => [message];
}
