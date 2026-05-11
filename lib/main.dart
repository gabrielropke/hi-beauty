import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hi_core/app/hi_mobile.dart';
import 'package:hi_core/hi_core.dart';
import 'package:flutter/services.dart';
import 'package:hibeauty/firebase_options.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
// Import direto da lib para inicialização pura
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  // ENV carregado primeiro para disponibilizar chaves
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseRemoteConfig.instance.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: Duration.zero,
    ),
  );

  // Configuração de marca específica
  final brandMap = await BrandLoader.load();
  final brandColors = ThemeColors.fromJson(brandMap['colors']);
  AppColors.setInstance(brandColors);

  // Inicializações de serviços
  await UserService().initialize();
  await NotificationsService().initialize();
  await SubscriptionService().initialize();
  
  // Inicialização PURA do Mixpanel
  // Certifique-se de ter 'MIXPANEL_TOKEN' no seu .env
  await Mixpanel.init(
    'c4e812342ca770322c46f19c3fcfaafc',
    trackAutomaticEvents: true,
  );

  OneSignal.initialize("e2245be5-a02a-467b-afc3-7207ac4aa86d");

  runApp(const HiCoreRunApp());
}