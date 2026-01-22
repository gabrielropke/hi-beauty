import '../data/model.dart';

abstract class NotificationsRepository {
  Future<NotificationsModel> getNotifications();
  Future<int> getUnreadCount();
  Future<void> markAllRead();
  Future<void> markRead(String id);
  Future<void> deleteNotification(String id);
}

class GetNotifications {
  final NotificationsRepository repository;
  GetNotifications(this.repository);

  Future<NotificationsModel> call() {
    return repository.getNotifications();
  }
}

class GetUnreadCount {
  final NotificationsRepository repository;
  GetUnreadCount(this.repository);

  Future<int> call() {
    return repository.getUnreadCount();
  }
}

class MarkAllRead {
  final NotificationsRepository repository;
  MarkAllRead(this.repository);

  Future<void> call() {
    return repository.markAllRead();
  }
}

class MarkRead {
  final NotificationsRepository repository;
  MarkRead(this.repository);

  Future<void> call(String id) {
    return repository.markRead(id);
  }
}

class DeleteNotification {
  final NotificationsRepository repository;
  DeleteNotification(this.repository);

  Future<void> call(String id) {
    return repository.deleteNotification(id);
  }
}