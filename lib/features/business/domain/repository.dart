import 'dart:io';
import 'package:hibeauty/features/business/data/model.dart';
import 'package:hibeauty/features/onboarding/data/business/model.dart';

abstract class SetupBusinessRepository {
  Future<void> updateSetupBasic(SetupBasicModel body);
  Future<void> updateSetupAddress(SetupAddressModel body);
  Future<void> updateSetupCustomization({
    required String themeColor,
    File? logoImage,
    File? coverImage,
  });
  Future<void> updateBusinessHours(List<OpeningHour> body);
  Future<BusinessRulesResponseModel> getBusinessRules();
  Future<WhatsAppPairingResponse> connectWhatsappMobile({required String phone});
  Future<void> disconnectWhatsappMobile();
  Future<void> aiConfig(
    String aiToneOfVoice,
    String aiLanguage,
    String aiVerbosity,
  );
  Future<void> startTrial(String phone, String referrerPhone);
}

class AiConfig {
  final SetupBusinessRepository repository;
  AiConfig(this.repository);

  Future<void> call(
    String aiToneOfVoice,
    String aiLanguage,
    String aiVerbosity,
  ) {
    return repository.aiConfig(aiToneOfVoice, aiLanguage, aiVerbosity);
  }
}

class GetBusinessRules {
  final SetupBusinessRepository repository;
  GetBusinessRules(this.repository);

  Future<BusinessRulesResponseModel> call() {
    return repository.getBusinessRules();
  }
}

class BusinessHours {
  final SetupBusinessRepository repository;
  BusinessHours(this.repository);

  Future<void> call(List<OpeningHour> body) {
    return repository.updateBusinessHours(body);
  }
}

class SetupBusiness {
  final SetupBusinessRepository repository;
  SetupBusiness(this.repository);

  Future<void> call(SetupBasicModel body) {
    return repository.updateSetupBasic(body);
  }
}

class SetupBusinessAddress {
  final SetupBusinessRepository repository;
  SetupBusinessAddress(this.repository);

  Future<void> call(SetupAddressModel body) {
    return repository.updateSetupAddress(body);
  }
}

class SetupBusinessCustomization {
  final SetupBusinessRepository repository;
  SetupBusinessCustomization(this.repository);

  Future<void> call({
    required String themeColor,
    File? logoImage,
    File? coverImage,
  }) {
    return repository.updateSetupCustomization(
      themeColor: themeColor,
      logoImage: logoImage,
      coverImage: coverImage,
    );
  }
}

class ConnectWhatsappMobile {
  final SetupBusinessRepository repository;
  ConnectWhatsappMobile(this.repository);

  Future<WhatsAppPairingResponse> call({required String phone}) {
    return repository.connectWhatsappMobile(phone: phone);
  }
}

class StartTrial {
  final SetupBusinessRepository repository;
  StartTrial(this.repository);

  Future<void> call(String phone, String referrerPhone) {
    return repository.startTrial(phone, referrerPhone);
  }
}