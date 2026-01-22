import 'package:flutter/material.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/bloc/business_config_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';

class StatusMessage extends StatelessWidget {
  final BusinessConfigLoaded state;
  
  const StatusMessage(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Text(
      state.whatsappConnected
          ? l10n.whatsappConnected
          : state.loading
          ? 'Estamos preparando tudo para você...'
          : 'Conecte seu WhatsApp para gerar o código',
      style: TextStyle(fontSize: 13, color: Colors.black54),
    );
  }
}