part of 'business_config_bloc.dart';

abstract class BusinessConfigState extends Equatable {
  const BusinessConfigState();

  @override
  List<Object?> get props => [];
}

class BusinessConfigBusinessConfig extends BusinessConfigState {}

class BusinessConfigLoading extends BusinessConfigState {}

class BusinessConfigLoaded extends BusinessConfigState {
  final Map<String, String> message;
  final bool loading;
  final String code;
  final bool whatsappConnected;
  final List<SubSegmentsModel> subsegments;
  final ReferrerModel? referrerInfo;
  final String referrerMessage;
  final bool indicatorEnabled;

  const BusinessConfigLoaded({
    this.message = const {'': ''},
    this.loading = false,
    this.code = '',
    this.whatsappConnected = false,
    this.subsegments = const [],
    this.referrerInfo,
    this.referrerMessage = '',
    this.indicatorEnabled = false,
  });

  BusinessConfigLoaded copyWith({
    ValueGetter<Map<String, String>>? message,
    ValueGetter<bool>? loading,
    ValueGetter<String>? code,
    ValueGetter<bool>? whatsappConnected,
    ValueGetter<List<SubSegmentsModel>>? subsegments,
    ValueGetter<ReferrerModel?>? referrerInfo,
    ValueGetter<String>? referrerMessage,
    ValueGetter<bool>? indicatorEnabled,
  }) {
    return BusinessConfigLoaded(
      message: message != null ? message() : this.message,
      loading: loading != null ? loading() : this.loading,
      code: code != null ? code() : this.code,
      whatsappConnected: whatsappConnected != null ? whatsappConnected() : this.whatsappConnected,
      subsegments: subsegments != null ? subsegments() : this.subsegments,
      referrerInfo: referrerInfo != null ? referrerInfo() : this.referrerInfo,
      referrerMessage: referrerMessage != null ? referrerMessage() : this.referrerMessage,
      indicatorEnabled: indicatorEnabled != null ? indicatorEnabled() : this.indicatorEnabled,
    );
  }

  @override
  List<Object?> get props => [message, loading, code, whatsappConnected, subsegments, referrerInfo, referrerMessage, indicatorEnabled];
}

class BusinessConfigEmpty extends BusinessConfigState {}

class BusinessConfigFailure extends BusinessConfigState {}
