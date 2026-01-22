import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hibeauty/app/hi_mobile.dart';
import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/core/data/subscription.dart';
import 'package:hibeauty/core/data/user.dart';
import 'package:hibeauty/core/services/notifications_service.dart';
import 'package:hibeauty/theme/app_colors.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  final Map<String, dynamic> brandMap = await BrandLoader.load();
  final ThemeColors brandColors = ThemeColors.fromJson(brandMap['colors']);
  AppColors.setInstance(brandColors);
  await UserService().initialize();
  await NotificationsService().initialize();
  await SubscriptionService().initialize();
  runApp(const HiMobile());
}
