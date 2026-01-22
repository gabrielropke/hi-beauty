import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/core/services/configuration_state_manager.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:hibeauty/theme/app_theme.dart';
import 'routes/app_routes.dart';

class HiMobile extends StatefulWidget {
  const HiMobile({super.key});

  @override
  State<HiMobile> createState() => _HiMobileState();
}

class _HiMobileState extends State<HiMobile> {
  bool _loading = true;
  ThemeData? _theme;
  String _brandName = 'Hi App';

  @override
  void initState() {
    super.initState();
    _loadBrand();
  }

  Future<void> _loadBrand() async {
    final Map<String, dynamic> brandJson = await BrandLoader.load();
    final themeColors = ThemeColors.fromJson(brandJson['colors']);
    AppColors.setInstance(themeColors);
    final name = brandJson['displayName'] ?? brandJson['name'] ?? 'Hi App';
    setState(() {
      _brandName = name;
      _theme = AppTheme.lightTheme(themeColors);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp.router(
      title: _brandName,
      theme: _theme!,
      routerConfig: AppRoutes.router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('pt'),
      supportedLocales: const [Locale('en', ''), Locale('pt', '')],
      debugShowCheckedModeBanner: false,
    );
  }
}

bool isConfigurationComplete() {
  final manager = ConfigurationStateManager();
  manager.updateConfigurationState(); // Atualiza o estado atual
  return manager.isConfigurationComplete;
}
