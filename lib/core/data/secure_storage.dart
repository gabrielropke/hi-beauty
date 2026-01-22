import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hibeauty/core/data/user.dart';
import 'package:hibeauty/features/onboarding/data/business/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorage {
  static const _tokenKey = 'user_token';
  static const _businessDataKey = 'business_data';

  // -----------------------------
  // USER
  // -----------------------------

  static Future<void> saveToken(String token) async {
    await FlutterSecureStorage().write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await FlutterSecureStorage().read(key: _tokenKey);
  }

  static Future<void> saveUser(User user) async {
    await FlutterSecureStorage().write(key: 'user', value: jsonEncode(user.toJson()));
  }

  static Future<User?> getUser() async {
    final userString = await FlutterSecureStorage().read(key: 'user');
    if (userString != null) {
      final userMap = jsonDecode(userString) as Map<String, dynamic>;
      return User.fromJson(userMap);
    }
    return null;
  }

  // -----------------------------
  // BUSINESS
  // -----------------------------

  static Future<void> saveBusiness(BusinessModel business) async {
    final businessJson = json.encode(business.toJson());
    await FlutterSecureStorage().write(key: _businessDataKey, value: businessJson);
  }

  static Future<BusinessModel?> getBusiness() async {
    final businessJson = await FlutterSecureStorage().read(key: _businessDataKey);
    if (businessJson == null) return null;

    try {
      final businessMap = json.decode(businessJson) as Map<String, dynamic>;
      return BusinessModel.fromJson(businessMap);
    } catch (_) {
      return null;
    }
  }

  // -----------------------------
  // CLEAR ALL
  // -----------------------------

  static Future<void> clearAll() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: _tokenKey);
    await storage.delete(key: 'user'); // Corrigindo para usar a chave correta
    await storage.delete(key: _businessDataKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
