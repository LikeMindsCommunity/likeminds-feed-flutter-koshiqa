part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class GetNotifications extends NotificationsEvent {
  final int offset;
  final int pageSize;

  const GetNotifications({
    required this.offset,
    required this.pageSize,
  });

  @override
  List<Object> get props => [offset, pageSize];
}
