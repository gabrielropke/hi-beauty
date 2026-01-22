import 'dart:io';
import 'package:hibeauty/core/constants/failures.dart';
import 'package:hibeauty/features/business/data/model.dart';
import 'package:hibeauty/features/business/domain/repository.dart';
import 'package:hibeauty/features/business/data/data_source.dart';
import 'package:hibeauty/features/onboarding/data/business/model.dart';

class SetupBusinessRepositoryImpl implements SetupBusinessRepository {
  final SetupBusinessRemoteDataSource remote;
  SetupBusinessRepositoryImpl(this.remote);

  @override
  Future<void> updateBusinessHours(List<OpeningHour> body) async {
    try {
      return await remote.updateBusinessHours(body);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<BusinessRulesResponseModel> getBusinessRules() async {
    try {
      return await remote.getBusinessRules();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateSetupBasic(SetupBasicModel body) async {
    try {
      return await remote.updateSetupBasic(body);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateSetupAddress(SetupAddressModel body) async {
    try {
      return await remote.updateSetupAddress(body);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateSetupCustomization({
    required String themeColor,
    File? logoImage,
    File? coverImage,
  }) async {
    try {
      return await remote.updateSetupCustomization(
        themeColor: themeColor,
        logoImage: logoImage,
        coverImage: coverImage,
      );
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<WhatsAppPairingResponse> connectWhatsappMobile({
    required String phone,
  }) async {
    try {
      return await remote.connectWhatsappMobile(phone: phone);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> disconnectWhatsappMobile() async {
    try {
      return await remote.disconnectWhatsappMobile();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> aiConfig(
    String aiToneOfVoice,
    String aiLanguage,
    String aiVerbosity,
  ) async {
    try {
      return await remote.aiConfig(aiToneOfVoice, aiLanguage, aiVerbosity);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> startTrial(String phone, String referrerPhone) async {
    try {
      return await remote.startTrial(phone, referrerPhone);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
