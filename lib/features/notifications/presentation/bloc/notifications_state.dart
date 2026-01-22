part of 'notifications_bloc.dart';

enum NotificationTypes {all, booking, payment, notice, system, commissionCalculated, commissionPaid}

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsNotifications extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final String message;
  final bool loading;
  final List<NotificationModel> notifications;
  final NotificationTypes filterType;

  const NotificationsLoaded({
    this.message = '',
    this.loading = false,
    this.notifications = const [],
    this.filterType = NotificationTypes.all,
  });

  NotificationsLoaded copyWith({
    ValueGetter<String>? message,
    ValueGetter<bool>? loading,
    ValueGetter<List<NotificationModel>>? notifications,
    ValueGetter<NotificationTypes>? filterType,
  }) {
    return NotificationsLoaded(
      message: message != null ? message() : this.message,
      loading: loading != null ? loading() : this.loading,
      notifications: notifications != null ? notifications() : this.notifications,
      filterType: filterType != null ? filterType() : this.filterType,
    );
  }

  @override
  List<Object?> get props => [message, loading, notifications, filterType];
}

class NotificationsEmpty extends NotificationsState {}

class NotificationsFailure extends NotificationsState {}
