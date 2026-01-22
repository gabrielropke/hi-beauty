import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_popup.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/bloc/business_config_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ConnectButton extends StatelessWidget {
  final BusinessConfigLoaded state;
  final TextEditingController controller;
  final AppLocalizations l10n;

  const ConnectButton({
    super.key,
    required this.state,
    required this.controller,
    required this.l10n,
  });

  void _onConnectPressed(BuildContext context) {
    final phone = controller.text.replaceAll(RegExp(r'[^\d]'), '');
    if (phone.length >= 10) {
      context.read<BusinessConfigBloc>().add(ConnectWhatsapp(phone));
    }
  }

  void _onDisconnectPressed(BuildContext context) {
    AppPopup.show(
      context: context,
      type: AppPopupType.delete,
      title: 'Desconectar WhatsApp',
      description: 'Esta ação irá desconectar seu WhatsApp e desativar todas as funcionalidades relacionadas.',
      actionLabel: 'Desconectar',
      onConfirm: () {
        context.read<BusinessConfigBloc>().add(const DisconnectWhatsapp());
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        children: [
          const Text(''),
          const SizedBox(height: 4),
          AppButton(
            function: state.loading
                ? null
                : state.whatsappConnected
                ? () => _onDisconnectPressed(context)
                : () => _onConnectPressed(context),
            borderRadius: 10,
            loading: state.loading,
            labelStyle: TextStyle(
              fontSize: 14,
              color: state.whatsappConnected ? Colors.red : Colors.white,
              fontWeight: FontWeight.w500,
            ),
            preffixIcon: state.whatsappConnected
                ? Icon(LucideIcons.power400, color: Colors.red, size: 20)
                : Icon(LucideIcons.qrCode, color: Colors.white, size: 20),
            borderColor: state.whatsappConnected
                ? Colors.red
                : Colors.black,
            fillColor: state.whatsappConnected
                ? Colors.transparent
                : Colors.black,
            label: state.whatsappConnected
                ? l10n.discconnect
                : l10n.connect,
          ),
        ],
      ),
    );
  }
}