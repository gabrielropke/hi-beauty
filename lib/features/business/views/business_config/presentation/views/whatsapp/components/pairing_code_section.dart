import 'package:flutter/material.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/bloc/business_config_bloc.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/views/whatsapp/components/pairing_code_display.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/views/whatsapp/components/status_message.dart';

class PairingCodeSection extends StatelessWidget {
  final BusinessConfigLoaded state;
  final bool isCopied;
  final ValueChanged<bool> onCopyStateChanged;

  const PairingCodeSection({
    super.key,
    required this.state,
    required this.isCopied,
    required this.onCopyStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (state.code.isNotEmpty) {
      return PairingCodeDisplay(
        code: state.code,
        isCopied: isCopied,
        onCopyStateChanged: onCopyStateChanged,
        state: state,
      );
    }

    return StatusMessage(state);
  }
}