import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/core/components/app_floating_message.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/core/data/business.dart';
import 'package:hibeauty/core/data/secure_storage.dart';
import 'package:hibeauty/core/services/business_options/data/model.dart';
import 'package:hibeauty/core/services/configuration_state_manager.dart';
import 'package:hibeauty/features/auth/register/data/data_source.dart';
import 'package:hibeauty/features/auth/register/data/model.dart';
import 'package:hibeauty/features/business/data/data_source.dart';
import 'package:hibeauty/features/business/data/model.dart';
import 'package:hibeauty/features/home/data/user/data_source.dart';
import 'package:hibeauty/features/home/presentation/components/welmoce_tutorial.dart';
import 'package:hibeauty/features/onboarding/data/business/data_source.dart';
import 'package:hibeauty/l10n/app_localizations.dart';

part 'business_config_event.dart';
part 'business_config_state.dart';

class BusinessConfigBloc
    extends Bloc<BusinessConfigEvent, BusinessConfigState> {
  final BuildContext context;
  Timer? _connectionCheckTimer;

  BusinessConfigBloc(this.context) : super(BusinessConfigBusinessConfig()) {
    on<BusinessConfigLoadRequested>(_onBusinessConfigLoadedRequested);
    on<CloseMessage>(_onCloseMessage);
    on<UpdateSetupBasic>(_onUpdateSetupBasic);
    on<UpdateSetupAddress>(_onUpdateSetupAddress);
    on<UpdateSetupCustomization>(_onUpdateSetupCustomization);
    on<ConnectWhatsapp>(_onConnectWhatsapp);
    on<DisconnectWhatsapp>(_onDisconnectWhatsapp);
    on<WhatsAppConnectionDetected>(_onWhatsAppConnectionDetected);
    on<AiConfig>(_onAiConfig);
    on<StartTrial>(_onStartTrial);
    on<ValidateReferrerPhone>(_onValidateReferrerPhone);
    on<EnableIndicator>(_onEnableIndicator);
  }

  @override
  Future<void> close() {
    _connectionCheckTimer?.cancel();
    return super.close();
  }

  Future<void> _onBusinessConfigLoadedRequested(
    BusinessConfigLoadRequested event,
    Emitter<BusinessConfigState> emit,
  ) async {
    try {
      final brand = await BrandLoader.load();
      final rawSegments = brand['segments'] as List<dynamic>? ?? [];

      final req = OnboardingRemoteDataSourceImpl();
      await req.getBusiness();

      final segments = rawSegments
          .map((e) => SubSegmentsModel.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(
        BusinessConfigLoaded(
          whatsappConnected: BusinessData.whatsappConnected,
          subsegments: segments,
        ),
      );
    } catch (e) {
      if (e is ApiFailure) {
        emit(BusinessConfigLoaded(loading: false, subsegments: []));
        return;
      }
    }
  }

  Future<void> _onValidateReferrerPhone(
    ValidateReferrerPhone event,
    Emitter<BusinessConfigState> emit,
  ) async {
    emit(
      (state as BusinessConfigLoaded).copyWith(
        loading: () => false,
        referrerMessage: () => '',
      ),
    );

    try {
      final referrer = await RegisterRemoteDataSourceImpl()
          .validateReferrerPhone(event.phone);

      emit(
        (state as BusinessConfigLoaded).copyWith(
          loading: () => false,
          referrerMessage: () => '',
          referrerInfo: () => referrer,
        ),
      );
    } catch (e) {
      if (e is ApiFailure) {
        emit(
          (state as BusinessConfigLoaded).copyWith(
            loading: () => false,
            referrerMessage: () => e.message,
          ),
        );
        return;
      }
    }
  }

  Future<void> _onEnableIndicator(
    EnableIndicator event,
    Emitter<BusinessConfigState> emit,
  ) async {
    final current = state;
    if (current is BusinessConfigLoaded) {
      emit(
        current.copyWith(
          indicatorEnabled: () => event.value,
          referrerInfo: event.value == false
              ? () => ReferrerModel(referrerName: '', referrerPhone: '')
              : () => current.referrerInfo,
        ),
      );
    }
  }

  Future<void> _onAiConfig(
    AiConfig event,
    Emitter<BusinessConfigState> emit,
  ) async {
    emit(
      (state as BusinessConfigLoaded).copyWith(
        loading: () => true,
        message: () => {'': ''},
      ),
    );

    try {
      await SetupBusinessRemoteDataSourceImpl().aiConfig(
        event.aiToneOfVoice,
        event.aiLanguage,
        event.aiVerbosity,
      );

      emit(
        (state as BusinessConfigLoaded).copyWith(
          loading: () => false,
          message: () => {'': ''},
        ),
      );

      // Show success message
      AppFloatingMessage.show(
        context,
        message: AppLocalizations.of(context)!.messageSuccess,
        type: AppFloatingMessageType.success,
      );

      // Atualiza o estado de configuração
      ConfigurationStateManager().updateConfigurationState();

      developer.log('AI Setting updated successfully', name: 'Business');
    } catch (e) {
      developer.log('Error during Ai Setting save: $e', name: 'Business');
      if (e is ApiFailure) {
        emit(
          (state as BusinessConfigLoaded).copyWith(
            loading: () => false,
            message: () => {'error': e.message},
          ),
        );
        return;
      }
    }
  }

  Future<void> _onCloseMessage(
    CloseMessage event,
    Emitter<BusinessConfigState> emit,
  ) async {
    emit(
      (state as BusinessConfigLoaded).copyWith(
        message: () => {'': ''},
        whatsappConnected: () => BusinessData.whatsappConnected,
      ),
    );
  }

  Future<void> _onUpdateSetupBasic(
    UpdateSetupBasic event,
    Emitter<BusinessConfigState> emit,
  ) async {
    emit(
      (state as BusinessConfigLoaded).copyWith(
        loading: () => true,
        message: () => {'': ''},
        whatsappConnected: () => BusinessData.whatsappConnected,
      ),
    );

    try {
      await SetupBusinessRemoteDataSourceImpl().updateSetupBasic(event.body);
      developer.log('Business updated with successfuly', name: 'Business');

      final currentBusiness = BusinessService().currentBusiness;

      if (currentBusiness != null) {
        final updatedBusiness = currentBusiness.copyWith(
          name: event.body.name,
          instagram: event.body.instagram,
          slug: event.body.slug,
          description: event.body.description,
          subSegments: event.body.subSegments,
        );

        BusinessService().setBusiness(updatedBusiness);
        await SecureStorage.saveBusiness(updatedBusiness);
      }

      developer.log('Business data updated locally.', name: 'Business');

      // Atualiza o estado de configuração
      ConfigurationStateManager().updateConfigurationState();

      AppFloatingMessage.show(
        context,
        message: 'Dados do negócio atualizados com sucesso',
        type: AppFloatingMessageType.success,
      );
      emit(
        (state as BusinessConfigLoaded).copyWith(
          loading: () => false,
          message: () => {'': ''},
        ),
      );
      context.pop();
    } catch (e) {
      if (e is ApiFailure) {
        emit(
          (state as BusinessConfigLoaded).copyWith(
            loading: () => false,
            message: () => {'error': e.message},
          ),
        );
        return;
      }
    }
  }

  Future<void> _onUpdateSetupAddress(
    UpdateSetupAddress event,
    Emitter<BusinessConfigState> emit,
  ) async {
    emit(
      (state as BusinessConfigLoaded).copyWith(
        loading: () => true,
        message: () => {'': ''},
      ),
    );

    try {
      await SetupBusinessRemoteDataSourceImpl().updateSetupAddress(event.body);
      developer.log('Address updated with successfuly', name: 'Business');

      final currentBusiness = BusinessService().currentBusiness;

      if (currentBusiness != null) {
        final updatedBusiness = currentBusiness.copyWith(
          zipCode: event.body.zipCode,
          address: event.body.address,
          number: event.body.number,
          complement: event.body.complement,
          neighborhood: event.body.neighborhood,
          city: event.body.city,
          state: event.body.state,
          country: event.body.country,
        );

        BusinessService().setBusiness(updatedBusiness);
        await SecureStorage.saveBusiness(updatedBusiness);
      }

      developer.log('Business data updated locally.', name: 'Business');

      // Atualiza o estado de configuração
      ConfigurationStateManager().updateConfigurationState();

      AppFloatingMessage.show(
        context,
        message: 'Dados do negócio atualizados com sucesso',
        type: AppFloatingMessageType.success,
      );
      emit(
        (state as BusinessConfigLoaded).copyWith(
          loading: () => false,
          message: () => {'': ''},
        ),
      );
      context.pop();
    } catch (e) {
      if (e is ApiFailure) {
        emit(
          (state as BusinessConfigLoaded).copyWith(
            loading: () => false,
            message: () => {'error': e.message},
          ),
        );
        return;
      }
    }
  }

  Future<void> _onUpdateSetupCustomization(
    UpdateSetupCustomization event,
    Emitter<BusinessConfigState> emit,
  ) async {
    emit(
      (state as BusinessConfigLoaded).copyWith(
        loading: () => true,
        message: () => {'': ''},
      ),
    );

    try {
      await SetupBusinessRemoteDataSourceImpl().updateSetupCustomization(
        themeColor: event.themeColor,
        logoImage: event.logoImage,
        coverImage: event.coverImage,
      );

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

      developer.log('Customization updated with successfuly', name: 'Business');

      // Atualiza o estado de configuração
      ConfigurationStateManager().updateConfigurationState();

      AppFloatingMessage.show(
        context,
        message: 'Visual do negócio atualizado com sucesso',
        type: AppFloatingMessageType.success,
      );
      emit(
        (state as BusinessConfigLoaded).copyWith(
          loading: () => false,
          message: () => {'': ''},
        ),
      );
      context.pop();
    } catch (e) {
      if (e is ApiFailure) {
        emit(
          (state as BusinessConfigLoaded).copyWith(
            loading: () => false,
            message: () => {'error': e.message},
          ),
        );
        return;
      }
    }
  }

  Future<void> _onStartTrial(
    StartTrial event,
    Emitter<BusinessConfigState> emit,
  ) async {
    emit(
      (state as BusinessConfigLoaded).copyWith(
        loading: () => true,
        message: () => {'': ''},
      ),
    );

    try {
      await SetupBusinessRemoteDataSourceImpl().startTrial(
        event.phone,
        event.referrerPhone,
      );

      emit(
        (state as BusinessConfigLoaded).copyWith(
          loading: () => false,
          message: () => {'': ''},
        ),
      );
      developer.log('Trial started', name: 'Signature');

      context.go(AppRoutes.home);
      // Aguarda a navegação terminar antes de mostrar o tutorial
      Future.delayed(Duration(seconds: 3), () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showWelcomeTutorialSheet(context: context);
        });
      });
    } catch (e) {
      final userRemote = await GetUserRemoteDataSourceImpl().fetchUser();

      if (userRemote.whatsapp != null && userRemote.whatsapp!.isNotEmpty) {
        developer.log('Trial started', name: 'Signature');

        context.go(AppRoutes.home);
        // Aguarda a navegação terminar antes de mostrar o tutorial
        Future.delayed(Duration(seconds: 3), () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showWelcomeTutorialSheet(context: context);
          });
        });
        return;
      }

      developer.log('Error during number insert: $e', name: 'Signature');
      if (e is ApiFailure) {
        emit(
          (state as BusinessConfigLoaded).copyWith(
            loading: () => false,
            message: () => {'error': e.message},
          ),
        );
        return;
      }
    }
  }

  Future<void> _onConnectWhatsapp(
    ConnectWhatsapp event,
    Emitter<BusinessConfigState> emit,
  ) async {
    developer.log(
      'Starting WhatsApp connect process for phone: ${event.phone}',
      name: 'Business',
    );
    emit(
      (state as BusinessConfigLoaded).copyWith(
        loading: () => true,
        message: () => {'': ''},
        code: () => '',
        whatsappConnected: () => BusinessData.whatsappConnected,
      ),
    );

    try {
      developer.log('Calling connect API...', name: 'Business');
      final response = await SetupBusinessRemoteDataSourceImpl()
          .connectWhatsappMobile(phone: event.phone);

      developer.log(
        'WhatsApp code generated successfully: ${response.pairingCode}',
        name: 'Business',
      );

      emit(
        (state as BusinessConfigLoaded).copyWith(
          loading: () => false,
          code: () => response.pairingCode,
          whatsappConnected: () => BusinessData.whatsappConnected,
        ),
      );

      developer.log(
        'Starting WhatsApp connection polling...',
        name: 'Business',
      );
      // Start polling for WhatsApp connection status
      _startWhatsAppConnectionPolling(emit);
    } catch (e) {
      developer.log('Error during WhatsApp connect: $e', name: 'Business');
      if (e is ApiFailure) {
        emit(
          (state as BusinessConfigLoaded).copyWith(
            loading: () => false,
            message: () => {'error': e.message},
            code: () => '',
            whatsappConnected: () => BusinessData.whatsappConnected,
          ),
        );
        return;
      }
    }
  }

  void _startWhatsAppConnectionPolling(Emitter<BusinessConfigState> emit) {
    _connectionCheckTimer?.cancel(); // Cancel any existing timer

    final startTime = DateTime.now();
    const maxDuration = Duration(minutes: 10);
    const checkInterval = Duration(seconds: 2);

    _connectionCheckTimer = Timer.periodic(checkInterval, (timer) async {
      final elapsed = DateTime.now().difference(startTime);

      if (elapsed >= maxDuration) {
        developer.log(
          'WhatsApp connection polling timeout after 10 minutes',
          name: 'Business',
        );
        timer.cancel();
        return;
      }

      try {
        developer.log(
          'Polling: Checking WhatsApp connection status...',
          name: 'Business',
        );
        // Get updated business data
        final req = OnboardingRemoteDataSourceImpl();
        await req.getBusiness();

        developer.log(
          'Polling: BusinessData.whatsappConnected = ${BusinessData.whatsappConnected}',
          name: 'Business',
        );

        // Check if WhatsApp is now connected
        if (BusinessData.whatsappConnected) {
          developer.log('WhatsApp successfully connected!', name: 'Business');
          timer.cancel();

          // Show success message
          AppFloatingMessage.show(
            context,
            message: 'WhatsApp conectado com sucesso!',
            type: AppFloatingMessageType.success,
          );

          // Atualiza o estado de configuração
          ConfigurationStateManager().updateConfigurationState();

          // Add event instead of calling emit directly
          add(const WhatsAppConnectionDetected());
        }
      } catch (e) {
        developer.log(
          'Error checking WhatsApp connection status: $e',
          name: 'Business',
        );
        // Continue polling despite errors
      }
    });
  }

  Future<void> _onWhatsAppConnectionDetected(
    WhatsAppConnectionDetected event,
    Emitter<BusinessConfigState> emit,
  ) async {
    developer.log(
      'Processing WhatsApp connection detected event',
      name: 'Business',
    );

    if (state is BusinessConfigLoaded) {
      emit(
        (state as BusinessConfigLoaded).copyWith(
          loading: () => false,
          message: () => {'': ''},
          code: () => '', // Clear the pairing code
          whatsappConnected: () => true, // Explicitly set to true
        ),
      );
    }
  }

  Future<void> _onDisconnectWhatsapp(
    DisconnectWhatsapp event,
    Emitter<BusinessConfigState> emit,
  ) async {
    developer.log('Starting WhatsApp disconnect process...', name: 'Business');

    // Cancel any active polling
    _connectionCheckTimer?.cancel();

    emit(
      (state as BusinessConfigLoaded).copyWith(
        loading: () => true,
        message: () => {'': ''},
      ),
    );

    try {
      developer.log('Calling disconnect API...', name: 'Business');
      // Call disconnect API
      await SetupBusinessRemoteDataSourceImpl().disconnectWhatsappMobile();

      developer.log('WhatsApp disconnected successfully', name: 'Business');

      developer.log('Refreshing business data...', name: 'Business');
      // Refresh business data to get updated whatsappConnected status
      final req = OnboardingRemoteDataSourceImpl();
      await req.getBusiness();

      developer.log(
        'Business data refreshed after disconnect',
        name: 'Business',
      );

      // Atualiza o estado de configuração
      ConfigurationStateManager().updateConfigurationState();

      AppFloatingMessage.show(
        context,
        message: 'WhatsApp desconectado com sucesso',
        type: AppFloatingMessageType.success,
      );

      emit(
        (state as BusinessConfigLoaded).copyWith(
          loading: () => false,
          message: () => {'': ''},
          code: () => '', // Clear pairing code
          whatsappConnected: () => false,
        ),
      );
    } catch (e) {
      developer.log('Error during WhatsApp disconnect: $e', name: 'Business');
      if (e is ApiFailure) {
        emit(
          (state as BusinessConfigLoaded).copyWith(
            loading: () => false,
            message: () => {'error': e.message},
          ),
        );
        return;
      }
    }
  }
}
