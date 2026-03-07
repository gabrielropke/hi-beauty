import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hi_core/app/hi_mobile.dart';
import 'package:hi_core/hi_core.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // ENV continua sendo do app
  await dotenv.load(fileName: ".env");

  // Configuração de marca específica do HiBarber
  final brandMap = await BrandLoader.load();
  final brandColors = ThemeColors.fromJson(brandMap['colors']);
  AppColors.setInstance(brandColors);

  // Inicializações específicas do app
  await UserService().initialize();
  await NotificationsService().initialize();
  await SubscriptionService().initialize();

  runApp(const HiCoreRunApp());
}
