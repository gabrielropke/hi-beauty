import 'dart:convert';

import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/core/data/base_remote_data_source.dart';
import 'package:hibeauty/core/data/user.dart';
import 'model.dart';

abstract class NotificationsRemoteDataSource {
  Future<NotificationsModel> getNotifications();
  Future<int> getUnreadCount();
  Future<void> markAllRead();
  Future<void> markRead(String id);
  Future<void> deleteNotification(String id);
}

class NotificationsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements NotificationsRemoteDataSource {
  NotificationsRemoteDataSourceImpl({super.client, super.baseUrl, super.timeout});

  @override
  Future<NotificationsModel> getNotifications() async {
    final uri = buildUri('v1/notifications');

    final res = await getJson(
      uri,
      headers: {
        'accept': 'application/json',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) {
      throw apiFailure;
    }

    final decoded =
        jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

    return NotificationsModel.fromJson(decoded);
  }

  @override
  Future<int> getUnreadCount() async {
    final uri = buildUri('v1/notifications/unread-count');

    final res = await getJson(
      uri,
      headers: {
        'accept': 'application/json',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) {
      throw apiFailure;
    }

    final decoded =
        jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

    return decoded['count'] as int;
  }

  @override
  Future<void> markAllRead() async {
    final uri = buildUri('v1/notifications/mark-all-read');

    final res = await patchJson(
      uri,
      headers: {
        'accept': 'application/json',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
      body: {},
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;
  }

  @override
  Future<void> markRead(String id) async {
    final uri = buildUri('v1/notifications/$id/read');

    final res = await patchJson(
      uri,
      headers: {
        'accept': 'application/json',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
      body: {},
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;
  }

  @override
  Future<void> deleteNotification(String id) async {
    final uri = buildUri('v1/notifications/$id');

    final res = await deleteJson(
      uri,
      body: {},
      headers: {
        'accept': '*/*',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;
  }

}
