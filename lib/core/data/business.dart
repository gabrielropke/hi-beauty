import 'package:flutter/foundation.dart';
import 'package:hibeauty/core/data/secure_storage.dart';
import 'package:hibeauty/features/onboarding/data/business/model.dart';

class BusinessData {
  static BusinessModel? get _b => BusinessService().currentBusiness;

  static String get id => _b?.id ?? '';
  static String get name => _b?.name ?? '';
  static String get slug => _b?.slug ?? '';
  static String? get description => _b?.description;
  static String? get email => _b?.email;
  static String? get whatsapp => _b?.whatsapp;
  static bool get whatsappConnected => _b?.whatsappConnected ?? false;
  static String? get address => _b?.address;
  static String? get neighborhood => _b?.neighborhood;
  static String? get number => _b?.number;
  static String? get city => _b?.city;
  static String? get state => _b?.state;
  static String? get zipCode => _b?.zipCode;
  static String? get country => _b?.country;
  static String? get instagram => _b?.instagram;
  static String? get segment => _b?.segment;
  static List<String> get subSegments => _b?.subSegments ?? [];
  static String? get mainObjective => _b?.mainObjective;
  static String? get teamSize => _b?.teamSize;
  static String? get themeColor => _b?.themeColor;
  static String? get logoUrl => _b?.logoUrl;
  static String? get coverUrl => _b?.coverUrl;
  static List<OpeningHour> get openingHours => _b?.openingHours ?? [];
  static String? get timezone => _b?.timezone;
  static String? get currency => _b?.currency;
  static String? get aiToneOfVoice => _b?.aiToneOfVoice;
  static String? get aiLanguage => _b?.aiLanguage;
  static String? get aiVerbosity => _b?.aiVerbosity;
  static bool get isActive => _b?.isActive ?? false;
  static DateTime? get createdAt => _b?.createdAt;
  static DateTime? get updatedAt => _b?.updatedAt;
  static String? get complement => _b?.complement;

  static bool get isLoaded => _b != null;
}

class BusinessService extends ChangeNotifier {
  static final BusinessService _instance = BusinessService._internal();
  factory BusinessService() => _instance;
  BusinessService._internal();

  BusinessModel? _currentBusiness;
  bool _loaded = false;

  BusinessModel? get currentBusiness => _currentBusiness;

  /// Inicializa lendo o negócio salvo no SecureStorage (caso exista)
  Future<void> initialize() async {
    if (_loaded) return;
    _currentBusiness = await SecureStorage.getBusiness();
    _loaded = true;
    notifyListeners();
  }

  /// Define o negócio atual em memória
  void setBusiness(BusinessModel business) {
    _currentBusiness = business;
    notifyListeners();
  }

  /// Remove o negócio atual da memória
  void clearBusiness() {
    _currentBusiness = null;
    notifyListeners();
  }

  /// Getter direto do status ativo
  bool get isActive => _currentBusiness?.isActive ?? false;

  /// Atualiza dinamicamente o status de ativo
  void setIsActive(bool value) {
    final current = _currentBusiness;
    if (current != null) {
      _currentBusiness = current.copyWith(isActive: value);
      notifyListeners();
    }
  }

  /// Atualiza qualquer campo do negócio atual e mantém o resto
  void updateBusiness(BusinessModel Function(BusinessModel current) updateFn) {
    final current = _currentBusiness;
    if (current != null) {
      _currentBusiness = updateFn(current);
      notifyListeners();
    }
  }
}
