import 'dart:developer' as developer;

import 'package:go_router/go_router.dart';
import 'package:hibeauty/core/data/business.dart';
import 'package:hibeauty/core/data/secure_storage.dart';
import 'package:hibeauty/core/data/subscription.dart';
import 'package:hibeauty/core/data/user.dart';
import 'package:hibeauty/core/services/subscription/data/data_source.dart';
import 'package:hibeauty/features/business/views/business_config/complete_whatsapp_initial_screen.dart';
import 'package:hibeauty/features/home/data/user/data_source.dart';
import 'package:hibeauty/features/onboarding/data/business/data_source.dart';
import 'package:hibeauty/core/data/api_error.dart';

import 'package:hibeauty/features/auth/login/presentation/login_screen.dart';
import 'package:hibeauty/features/auth/register/presentation/screens/register_screen.dart';
import 'package:hibeauty/features/auth/register/presentation/screens/register_enter_code_screen.dart';
import 'package:hibeauty/features/auth/forgot_password/presentation/screens/forgot_password_screen.dart';
import 'package:hibeauty/features/auth/forgot_password/presentation/screens/forgot_password_enter_code_screen.dart';
import 'package:hibeauty/features/auth/forgot_password/presentation/screens/new_password_screen.dart';

import 'package:hibeauty/features/onboarding/presentation/onboarding_screen.dart';
import 'package:hibeauty/features/home/presentation/home_screen.dart';
import 'package:hibeauty/features/dashboard/presentation/dashboard_screen.dart';
import 'package:hibeauty/features/signature/presentation/create_signature_screen.dart';

import 'package:hibeauty/features/customers/presentation/customers_screen.dart';
import 'package:hibeauty/features/functions/presentation/functions_screen.dart';
import 'package:hibeauty/features/catalog/presentation/services/services_screen.dart';
import 'package:hibeauty/features/catalog/presentation/combos/combos_screen.dart';
import 'package:hibeauty/features/catalog/presentation/products/products_screen.dart';
import 'package:hibeauty/features/signature/presentation/my_signature_screen.dart';
import 'package:hibeauty/features/team/presentation/team_screen.dart';
import 'package:hibeauty/features/notifications/presentation/notifications_screen.dart';
import 'package:hibeauty/features/user/presentation/user_screen.dart';

import 'package:hibeauty/features/business/views/business_config/presentation/business_config_screen.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/business_config_provider.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/views/address/business_address_view.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/views/business/business_data_view.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/views/customize/business_customization_view.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/views/whatsapp/business_whatsapp_view.dart';
import 'package:hibeauty/features/business/views/business_hours/presentation/business_hours_screen.dart';
import 'package:hibeauty/features/business/views/business_roles/presentation/business_roles_screen.dart';

import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/add_schedule_screen.dart';
import 'package:hibeauty/features/functions/presentation/components/pre_page_functions.dart';

// 🔹 MODELS
import 'package:hibeauty/features/auth/register/data/model.dart';
import 'package:hibeauty/features/auth/forgot_password/data/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRoutes {
  // 🔹 Auth
  static const String login = '/';
  static const String register = '/register';
  static const String registerEnterCode = '/registerEnterCode';
  static const String forgotPassword = '/forgotPassword';
  static const String forgotPasswordEnterCode = '/forgotPasswordEnterCode';
  static const String newPassword = '/newPassword';

  // 🔹 Core
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String signature = '/signature';
  static const String mysignature = '/mysignature';

  // 🔹 Stripe
  static const String checkoutSuccess = '/checkout/success';
  static const String checkoutCancel = '/checkout/cancel';

  // 🔹 App
  static const String customers = '/customers';
  static const String functions = '/functions';
  static const String services = '/services';
  static const String combos = '/combos';
  static const String products = '/products';
  static const String team = '/team';
  static const String notifications = '/notifications';
  static const String user = '/user';

  // 🔹 Business
  static const String businessConfig = '/businessConfig';
  static const String businessData = '/businessData';
  static const String businessWhatsapp = '/businessWhatsapp';
  static const String businessAddress = '/businessAddress';
  static const String businessCustomization = '/businessCustomization';
  static const String businessHours = '/businessHours';
  static const String businessRoles = '/businessRoles';
  static const String prePageFunctions = '/prePageFunctions';
  static const String completeWhatsappInitialScreen =
      '/completeWhatsappInitialScreen';
  static const String addSchedule = '/addSchedule';

  static GoRouter router = GoRouter(
    initialLocation: home,
    // debugLogDiagnostics: true,

    /// � REDIRECT GLOBAL
    redirect: (context, state) async {
      final currentPath = state.fullPath;

      // 🔓 Libera callbacks da Stripe
      if (currentPath == checkoutSuccess || currentPath == checkoutCancel) {
        return null;
      }

      // 🔐 Não logado - libera todas as rotas de autenticação
      if (!UserData.isLogged) {
        final authRoutes = [
          login,
          register,
          registerEnterCode,
          forgotPassword,
          forgotPasswordEnterCode,
          newPassword,
        ];

        if (authRoutes.contains(currentPath)) return null;
        return login;
      }

      // 🔓 Página de assinatura sempre acessível
      if (currentPath == signature) return null;

      // 🔓 Página de onboarding sempre acessível
      if (currentPath == onboarding) return null;
      // 🔓 Página de complete whatsapp sempre acessível
      if (currentPath == completeWhatsappInitialScreen) return null;

      // 📱 Verificar se usuário tem whatsapp configurado (primeiro)
      try {
        await GetUserRemoteDataSourceImpl().fetchUser();
        final currentUser = UserService().currentUser;
        final whatsapp = currentUser?.whatsapp ?? '';
        if (whatsapp.isEmpty) {
          return completeWhatsappInitialScreen;
        }
      } catch (e) {
        await SecureStorage.clearAll();
        UserService().clearUser();
        BusinessService().clearBusiness();
        SubscriptionService().resetService();
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        context.go(AppRoutes.login);

        developer.log('User logged out with Error', name: 'GoRouter');
      }

      // 🏢 Verificar se usuário tem business (depois do whatsapp)
      try {
        await OnboardingRemoteDataSourceImpl().getBusiness();
        // Se chegou aqui, business existe, pode continuar para verificação de subscription
      } catch (e) {
        if (e is ApiFailure) {
          // Se não tem business, vai para onboarding
          return onboarding;
        }
        // Se erro de rede ou outro problema, permite continuar
      }

      try {
        final subscriptionStatus = await SubscriptionRemoteDataSourceImpl()
            .getSubscriptionStatus();

        if (!subscriptionStatus.isActive && !subscriptionStatus.isSubscriber) {
          return signature;
        }

        return null;
      } catch (_) {
        return null;
      }
    },

    routes: [
      // 🔹 Auth
      GoRoute(path: login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: register, builder: (_, __) => const RegisterScreen()),
      GoRoute(
        path: registerEnterCode,
        builder: (_, state) =>
            RegisterEnterCodeScreen(args: state.extra as RegisterRequestModel),
      ),
      GoRoute(
        path: forgotPassword,
        builder: (_, __) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: forgotPasswordEnterCode,
        builder: (_, state) => ForgotPasswordEnterCodeScreen(
          args: state.extra as ForgotPasswordModel,
        ),
      ),
      GoRoute(
        path: newPassword,
        builder: (_, state) =>
            NewPasswordScreen(args: state.extra as ForgotPasswordModel),
      ),

      // 🔹 Core
      GoRoute(path: onboarding, builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: home, builder: (_, __) => const HomeScreen()),
      GoRoute(path: dashboard, builder: (_, __) => const DashboardScreen()),
      GoRoute(
        path: signature,
        builder: (_, __) => const CreateSignatureScreen(),
      ),
      GoRoute(path: mysignature, builder: (_, __) => const MySignatureScreen()),

      // 🔹 App
      GoRoute(path: customers, builder: (_, __) => const CustomersScreen()),
      GoRoute(path: functions, builder: (_, __) => const FunctionsScreen()),
      GoRoute(path: services, builder: (_, __) => const ServicesScreen()),
      GoRoute(path: combos, builder: (_, __) => const CombosScreen()),
      GoRoute(path: products, builder: (_, __) => const ProductsScreen()),
      GoRoute(path: team, builder: (_, __) => const TeamScreen()),
      GoRoute(
        path: completeWhatsappInitialScreen,
        builder: (_, __) => const CompleteWhatsappInitialScreen(),
      ),
      GoRoute(
        path: notifications,
        builder: (_, __) => const NotificationsScreen(),
      ),
      GoRoute(path: user, builder: (_, __) => const UserScreen()),

      // 🔹 Business
      GoRoute(
        path: businessConfig,
        builder: (_, __) =>
            const BusinessConfigProvider(child: BusinessConfigScreen()),
      ),
      GoRoute(
        path: businessData,
        builder: (_, __) =>
            const BusinessConfigProvider(child: BusinessDataScreen()),
      ),
      GoRoute(
        path: businessWhatsapp,
        builder: (_, __) =>
            const BusinessConfigProvider(child: BusinessWhatsappScreen()),
      ),
      GoRoute(
        path: businessAddress,
        builder: (_, __) =>
            const BusinessConfigProvider(child: BusinessAddressScreen()),
      ),
      GoRoute(
        path: businessCustomization,
        builder: (_, __) =>
            const BusinessConfigProvider(child: BusinessCustomizationScreen()),
      ),
      GoRoute(
        path: businessHours,
        builder: (_, __) => const BusinessHoursScreen(),
      ),
      GoRoute(
        path: businessRoles,
        builder: (_, __) => const BusinessRolesScreen(),
      ),

      GoRoute(
        path: prePageFunctions,
        builder: (_, state) =>
            PrePageFunctions(args: state.extra as PrePageFunctionsArgs),
      ),

      GoRoute(
        path: addSchedule,
        builder: (_, state) {
          final args = state.extra as AddScheduleArgs;
          return AddScheduleScreen(
            addScheduleType: args.addScheduleType,
            initialDate: args.initialDate,
            id: args.bookingId,
          );
        },
      ),
    ],
  );
}
