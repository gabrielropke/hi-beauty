import 'package:flutter/foundation.dart';
import 'package:hibeauty/core/data/business.dart';

class ConfigurationStateManager {
  static final ConfigurationStateManager _instance = ConfigurationStateManager._internal();
  factory ConfigurationStateManager() => _instance;
  ConfigurationStateManager._internal();

  final ValueNotifier<bool> _isConfigurationComplete = ValueNotifier<bool>(false);

  ValueNotifier<bool> get isConfigurationCompleteNotifier => _isConfigurationComplete;

  bool get isConfigurationComplete => _isConfigurationComplete.value;

  void updateConfigurationState() {
    // Verifica se todos os passos da configuração estão completos
    final businessDataComplete =
        BusinessData.name.isNotEmpty &&
        (BusinessData.segment?.isNotEmpty ?? false) &&
        (BusinessData.description?.isNotEmpty ?? false);

    final whatsappComplete = BusinessData.whatsappConnected;

    final customizationComplete =
        (BusinessData.logoUrl?.isNotEmpty ?? false) &&
        (BusinessData.themeColor?.isNotEmpty ?? false);

    final addressComplete =
        (BusinessData.address?.isNotEmpty ?? false) &&
        (BusinessData.city?.isNotEmpty ?? false) &&
        (BusinessData.state?.isNotEmpty ?? false) &&
        (BusinessData.zipCode?.isNotEmpty ?? false);

    final isComplete = businessDataComplete &&
        whatsappComplete &&
        customizationComplete &&
        addressComplete;

    if (_isConfigurationComplete.value != isComplete) {
      _isConfigurationComplete.value = isComplete;
    }
  }

  void dispose() {
    _isConfigurationComplete.dispose();
  }
}