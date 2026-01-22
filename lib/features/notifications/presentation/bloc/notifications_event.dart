part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class NotificationsLoadRequested extends NotificationsEvent {}

class CloseMessage extends NotificationsEvent {}

class MarkRead extends NotificationsEvent {
  final String id;
  const MarkRead({required this.id});

  @override
  List<Object?> get props => [id];
}

class MarkAllRead extends NotificationsEvent {}

class DeleteNotification extends NotificationsEvent {
  final String id;
  const DeleteNotification({required this.id});

  @override
  List<Object?> get props => [id];
}