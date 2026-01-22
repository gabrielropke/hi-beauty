import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/features/notifications/data/data_source.dart';
import 'package:hibeauty/features/notifications/data/repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NotificationsService with WidgetsBindingObserver {
  static final NotificationsService _instance =
      NotificationsService._internal();
  factory NotificationsService() => _instance;
  NotificationsService._internal();

  final ValueNotifier<int> _unreadCountNotifier = ValueNotifier<int>(0);
  bool _loaded = false;
  Timer? _pollingTimer;
  bool _isPollingActive = false;
  static const Duration _pollingInterval = Duration(seconds: 30);

  int get count => _unreadCountNotifier.value;
  ValueNotifier<int> get countNotifier => _unreadCountNotifier;

  Future<void> initialize() async {
    if (_loaded) return;
    
    // Adiciona observer para detectar mudanças no ciclo de vida do app
    WidgetsBinding.instance.addObserver(this);
    
    await refreshCount();
    startPolling();
  }

  Future<void> refreshCount() async {
    try {
      final newCount = await NotificationsRepositoryImpl(
        NotificationsRemoteDataSourceImpl(),
      ).getUnreadCount();
      _unreadCountNotifier.value = newCount;
      _loaded = true;
    } catch (e) {
      _unreadCountNotifier.value = 0;
      _loaded = false;
    }
  }

  void startPolling() {
    if (_isPollingActive) return;
    
    _isPollingActive = true;
    _pollingTimer = Timer.periodic(_pollingInterval, (timer) {
      // Só atualiza se o app estiver ativo e carregado
      if (_loaded && WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
        refreshCount();
      }
    });
  }

  void stopPolling() {
    _isPollingActive = false;
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.resumed:
        // App voltou ao foco - reinicia polling e atualiza imediatamente
        if (_loaded) {
          refreshCount();
          if (!_isPollingActive) {
            startPolling();
          }
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // App foi para background - pausa polling para economizar bateria
        stopPolling();
        break;
      case AppLifecycleState.detached:
        stopPolling();
        break;
      case AppLifecycleState.hidden:
        stopPolling();
        break;
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stopPolling();
  }

  void clearCount() {
    _unreadCountNotifier.value = 0;
    _loaded = false;
  }

  void decrementCount() {
    if (_unreadCountNotifier.value > 0) {
      _unreadCountNotifier.value--;
    }
  }

  void incrementCount() {
    _unreadCountNotifier.value++;
  }

  Widget notificationGlobalWidget(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.notifications),
      child: Container(
        width: 40,
        height: 40,
        color: Colors.transparent,
        child: ValueListenableBuilder<int>(
          valueListenable: _unreadCountNotifier,
          builder: (context, unreadCount, child) {
            return Stack(
              children: [
                Center(
                  child: Icon(LucideIcons.bell300, color: Colors.black54),
                ),
                if (unreadCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          unreadCount > 99 ? '99+' : unreadCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
