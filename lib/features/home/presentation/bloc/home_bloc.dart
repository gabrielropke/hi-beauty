import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/core/data/business.dart';
import 'package:hibeauty/core/data/secure_storage.dart';
import 'package:hibeauty/core/data/subscription.dart';
import 'package:hibeauty/core/data/user.dart';
import 'package:hibeauty/features/home/data/user/data_source.dart';
import 'package:hibeauty/features/home/presentation/components/welmoce_tutorial.dart';
import 'package:hibeauty/features/onboarding/data/business/data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BuildContext context;
  HomeBloc(this.context) : super(HomeInitial()) {
    on<HomeLoadRequested>(_onHomeLoadedRequested);
    on<ChangeTab>(_onChangeTab);
    on<CloseMessage>(_onCloseMessage);
    on<LogoutRequested>(_onLogoutRequested);
    on<OpenSchedulesDrawer>(_onOpenSchedulesDrawer);
    on<CloseSchedulesDrawer>(_onCloseSchedulesDrawer);
  }

  Future<void> _onHomeLoadedRequested(
    HomeLoadRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    if (UserData.isLogged) {
      final req = GetUserRemoteDataSourceImpl();

      try {
        final userRemote = await req.fetchUser();
        final currentUser = UserService().currentUser;

        if (currentUser != null) {
          developer.log('User restored from cache', name: 'Auth');

          final updatedUser = currentUser.copyWith(
            id: userRemote.id,
            name: userRemote.name,
            email: userRemote.email,
            whatsapp: userRemote.whatsapp,
          );

          UserService().setUser(updatedUser);
          await SecureStorage.saveUser(updatedUser);
        }

        try {
          final req = OnboardingRemoteDataSourceImpl();
          await req.getBusiness();
        } catch (e) {
          if (e is ApiFailure) {
            developer.log('Unregistered business', name: 'Business');
            context.go(AppRoutes.onboarding);
            return;
          }
        }

        emit(HomeLoaded());
        
        // SÓ ABRIR SE ESTIVER VINDO DO ONBOARDING
        // Verificar após carregar a home
        final prefs = await SharedPreferences.getInstance();
        final fromOnboarding = prefs.getBool('from_onboarding') ?? false;
        
        if (fromOnboarding) {
          // Remove o flag após usar
          await prefs.remove('from_onboarding');
          
          Future.delayed(Duration(seconds: 1), () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showWelcomeTutorialSheet(context: context);
            });
          });
        }
        
        return;
      } catch (e) {
        await SecureStorage.clearAll();
        UserService().clearUser();
        BusinessService().clearBusiness();
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        context.go(AppRoutes.login);

        developer.log(
          'User successfully logged out due to error',
          name: 'Auth',
        );
        return;
      }
    }

    emit(HomeLoaded());
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<HomeState> emit,
  ) async {
    await SecureStorage.clearAll();
    UserService().clearUser();
    BusinessService().clearBusiness();
    SubscriptionService().resetService();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    context.go(AppRoutes.login);

    developer.log('User logged out successfully', name: 'Auth');
  }

  Future<void> _onCloseMessage(
    CloseMessage event,
    Emitter<HomeState> emit,
  ) async {
    emit((state as HomeLoaded).copyWith(message: () => ''));
  }

  Future<void> _onChangeTab(ChangeTab event, Emitter<HomeState> emit) async {
    emit((state as HomeLoaded).copyWith(tab: () => event.value));
  }

  Future<void> _onOpenSchedulesDrawer(
    OpenSchedulesDrawer event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      (state as HomeLoaded).copyWith(
        showSchedulesDrawer: () => true,
        schedulesState: () => event.schedulesState,
        schedulesContext: () => event.schedulesContext,
      ),
    );
  }

  Future<void> _onCloseSchedulesDrawer(
    CloseSchedulesDrawer event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      (state as HomeLoaded).copyWith(
        showSchedulesDrawer: () => false,
        schedulesState: () => null,
        schedulesContext: () => null,
      ),
    );
  }
}
