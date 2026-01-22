part of 'business_config_bloc.dart';

abstract class BusinessConfigEvent extends Equatable {
  const BusinessConfigEvent();

  @override
  List<Object?> get props => [];
}

class BusinessConfigLoadRequested extends BusinessConfigEvent {}

class CloseMessage extends BusinessConfigEvent {}

class UpdateSetupBasic extends BusinessConfigEvent {
  final SetupBasicModel body;

  const UpdateSetupBasic(this.body);

  @override
  List<Object?> get props => [body];
}

class UpdateSetupAddress extends BusinessConfigEvent {
  final SetupAddressModel body;

  const UpdateSetupAddress(this.body);

  @override
  List<Object?> get props => [body];
}

class UpdateSetupCustomization extends BusinessConfigEvent {
  final String themeColor;
  final File? logoImage;
  final File? coverImage;

  const UpdateSetupCustomization({
    required this.themeColor,
    this.logoImage,
    this.coverImage,
  });

  @override
  List<Object?> get props => [themeColor, logoImage, coverImage];
}

class ConnectWhatsapp extends BusinessConfigEvent {
  final String phone;

  const ConnectWhatsapp(this.phone);

  @override
  List<Object?> get props => [phone];
}

class DisconnectWhatsapp extends BusinessConfigEvent {
  const DisconnectWhatsapp();

  @override
  List<Object?> get props => [];
}

class WhatsAppConnectionDetected extends BusinessConfigEvent {
  const WhatsAppConnectionDetected();

  @override
  List<Object?> get props => [];
}

class AiConfig extends BusinessConfigEvent {
  final String aiToneOfVoice;
  final String aiLanguage;
  final String aiVerbosity;

  const AiConfig({
    required this.aiToneOfVoice,
    required this.aiLanguage,
    required this.aiVerbosity,
  });

  @override
  List<Object?> get props => [aiToneOfVoice, aiLanguage, aiVerbosity];
}

class StartTrial extends BusinessConfigEvent {
  final String phone;
  final String referrerPhone;

  const StartTrial(this.phone, this.referrerPhone);

  @override
  List<Object?> get props => [phone, referrerPhone];
}

class ValidateReferrerPhone extends BusinessConfigEvent {
  final String phone;

  const ValidateReferrerPhone(this.phone);

  @override
  List<Object?> get props => [phone];
}

class EnableIndicator extends BusinessConfigEvent {
  final bool value;

  const EnableIndicator(this.value);

  @override
  List<Object?> get props => [value];
}
