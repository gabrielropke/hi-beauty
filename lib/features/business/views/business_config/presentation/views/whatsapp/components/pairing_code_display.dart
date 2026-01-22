import 'package:flutter/material.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/bloc/business_config_bloc.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/views/whatsapp/components/code_box.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/views/whatsapp/components/copy_button.dart';

class PairingCodeDisplay extends StatelessWidget {
  final String code;
  final bool isCopied;
  final ValueChanged<bool> onCopyStateChanged;
  final BusinessConfigLoaded state;

  const PairingCodeDisplay({
    super.key,
    required this.code,
    required this.isCopied,
    required this.onCopyStateChanged,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return state.whatsappConnected
        ? const Text(
            'WhatsApp conectado com sucesso!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.green,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          )
        : Column(
            children: [
              const Text(
                'Abra seu WhatsApp no telefone e utilize o código abaixo para se conectar:',
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...code.split('-').map((part) => CodeBox(part: part)),
                  const SizedBox(width: 16),
                  CopyButton(
                    code: code,
                    isCopied: isCopied,
                    onCopyStateChanged: onCopyStateChanged,
                  ),
                ],
              ),
            ],
          );
  }
}