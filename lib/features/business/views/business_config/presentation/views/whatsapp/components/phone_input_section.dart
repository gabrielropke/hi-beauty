import 'package:flutter/material.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/core/constants/formatters/phone.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/bloc/business_config_bloc.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/views/whatsapp/components/connect_button.dart';
import 'package:hibeauty/l10n/app_localizations.dart';

class PhoneInputSection extends StatelessWidget {
  final TextEditingController controller;
  final BusinessConfigLoaded state;

  const PhoneInputSection({
    super.key,
    required this.controller,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      spacing: 12,
      children: [
        Expanded(
          flex: 2,
          child: _PhoneTextField(
            controller: controller,
            enabled: !state.loading,
            l10n: l10n,
          ),
        ),
        ConnectButton(state: state, controller: controller, l10n: l10n),
      ],
    );
  }
}

class _PhoneTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final AppLocalizations l10n;

  const _PhoneTextField({
    required this.controller,
    required this.enabled,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextformfield(
      isrequired: true,
      title: l10n.whatsappNumber,
      hintText: l10n.yourBusinessNameHint,
      controller: controller,
      enabled: enabled,
      borderOn: true,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      textInputFormatter: PhoneFormatter(
        mask: '(##) #####-####',
        maxDigits: 11,
      ),
    );
  }
}