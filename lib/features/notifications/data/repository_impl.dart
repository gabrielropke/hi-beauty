import 'package:hibeauty/core/constants/failures.dart';
import '../domain/repository.dart';
import 'data_source.dart';
import 'model.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remote;

  NotificationsRepositoryImpl(this.remote);

  @override
  Future<NotificationsModel> getNotifications() async {
    try {
      return await remote.getNotifications();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      return await remote.getUnreadCount();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> markAllRead() async {
    try {
      return await remote.markAllRead();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> markRead(String id) async {
    try {
      return await remote.markRead(id);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    try {
      return await remote.deleteNotification(id);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
