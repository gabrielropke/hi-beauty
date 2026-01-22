import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_floating_message.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/core/constants/formatters/phone.dart';
import 'package:hibeauty/features/auth/register/data/model.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/bloc/business_config_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CompleteWhatsappInitialScreen extends StatelessWidget {
  const CompleteWhatsappInitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          BusinessConfigBloc(context)..add(BusinessConfigLoadRequested()),
      child: const CompleteWhatsappInitialView(),
    );
  }
}

class CompleteWhatsappInitialView extends StatefulWidget {
  const CompleteWhatsappInitialView({super.key});

  @override
  State<CompleteWhatsappInitialView> createState() =>
      _CompleteWhatsappInitialViewState();
}

class _CompleteWhatsappInitialViewState
    extends State<CompleteWhatsappInitialView> {
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController reffererController = TextEditingController();
  final FocusNode _whatsappFocus = FocusNode();

  @override
  void dispose() {
    whatsappController.dispose();
    reffererController.dispose();
    _whatsappFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BusinessConfigBloc, BusinessConfigState>(
        builder: (context, state) {
          if (state is! BusinessConfigLoaded) return const AppLoader();

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    Text(
                      'Bem-vindo(a), Gabriel Ropke!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Para completar seu cadastro, precisamos do seu número do WhatsApp',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 32),
                    _WhatsappForm(
                      state: state,
                      whatsappController: whatsappController,
                      reffererController: reffererController,
                      whatsappFocus: _whatsappFocus,
                    ),
                    const SizedBox(height: 24),
                    _TrialCard(),
                    const SizedBox(height: 24),
                    _RequiredFieldNotice(),
                    const SizedBox(height: 32),
                    AppButton(
                      loading: state.loading,
                      label: 'Completar Perfil',
                      function: () => _completeProfile(context),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        '* Campo obrigatório para continuar',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _completeProfile(BuildContext context) {
    if (whatsappController.text.trim().isEmpty) {
      AppFloatingMessage.show(
        context,
        message: 'Por favor, insira seu número do WhatsApp',
        type: AppFloatingMessageType.error,
      );
      return;
    }

    // Usar o evento ConnectWhatsapp para completar perfil
    // Remover formatação para manter apenas números
    final cleanPhone = whatsappController.text.trim().replaceAll(
      RegExp(r'[^\d]'),
      '',
    );

    final cleanReferrerPhone = reffererController.text.trim().replaceAll(
      RegExp(r'[^\d]'),
      '',
    );
    context.read<BusinessConfigBloc>().add(
      StartTrial(
        cleanPhone,
        cleanReferrerPhone.isEmpty ? '' : cleanReferrerPhone,
      ),
    );
  }
}

class _WhatsappForm extends StatelessWidget {
  final BusinessConfigLoaded state;
  final TextEditingController whatsappController;
  final TextEditingController reffererController;
  final FocusNode whatsappFocus;

  const _WhatsappForm({
    required this.state,
    required this.whatsappController,
    required this.reffererController,
    required this.whatsappFocus,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextformfield(
          controller: whatsappController,
          focusNode: whatsappFocus,
          title: 'Número do WhatsApp',
          hintText: '(11) 99999-9999',
          textInputAction: TextInputAction.done,
          isrequired: true,
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 12, right: 4),
            child: Icon(LucideIcons.phone400, color: Colors.black54, size: 16),
          ),
          keyboardType: TextInputType.phone,
          textInputFormatter: PhoneFormatter(mask: '(##) #####-####'),
        ),
        const SizedBox(height: 8),
        Text(
          'Este número será usado para comunicação e funcionalidades do WhatsApp',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(height: 28),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 8,
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<BusinessConfigBloc>().add(
                      EnableIndicator(!state.indicatorEnabled),
                    );
                    reffererController.clear();
                  },
                  child: Icon(
                    state.indicatorEnabled
                        ? Icons.check_box
                        : LucideIcons.square300,
                    size: 24,
                    color: state.indicatorEnabled
                        ? AppColors.primary
                        : Colors.grey,
                  ),
                ),
                Text('Fui indicado(a) por alguém'),
              ],
            ),
            Text(
              'Selecione caso algum amigo(a) tenha indicado o app para você.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),

        if (state.indicatorEnabled) ...[
          if (state.referrerInfo == null ||
              state.referrerInfo!.referrerName.isEmpty) ...[
            const SizedBox(height: 18),

            AppTextformfield(
              controller: reffererController,
              title: 'Telefone de quem te indicou',
              hintText: l10n.whatsappHint,
              error: state.referrerMessage.isNotEmpty
                  ? state.referrerMessage
                  : null,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 4.0),
                child: Icon(
                  LucideIcons.usersRound300,
                  color: Colors.grey.shade700,
                  size: 20,
                ),
              ),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              textInputFormatter: PhoneFormatter(mask: '(##) #####-####'),
              onChanged: (value) {
                final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                if (cleanValue.length == 11) {
                  context.read<BusinessConfigBloc>().add(
                    ValidateReferrerPhone(cleanValue),
                  );
                }
              },
            ),
          ],

          SizedBox(height: 18),

          _referrerViewUser(state.referrerInfo),
        ],
      ],
    );
  }

  Widget _referrerViewUser(ReferrerData? referrer) {
    return Visibility(
      visible: referrer != null && referrer.referrerName.isNotEmpty,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xFFEFFDF4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Color(0xFF036630).withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          spacing: 12,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF036630).withValues(alpha: 0.1),
              ),
              child: Center(
                child: Icon(
                  LucideIcons.usersRound300,
                  size: 20,
                  color: Color(0xFF036630),
                ),
              ),
            ),
            Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Indicado(a) por',
                  style: TextStyle(
                    color: Color(0xFF036630),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
                Text(
                  referrer?.referrerName ?? '',
                  style: TextStyle(
                    color: Color(0xFF036630),
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TrialCard extends StatelessWidget {
  const _TrialCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎉 Trial Gratuito Ativado!',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Você terá acesso completo à plataforma por 7 dias. Experimente todos os recursos sem compromisso!',
            style: TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class _RequiredFieldNotice extends StatelessWidget {
  const _RequiredFieldNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.circleAlert500, color: Colors.orange[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Este campo é obrigatório para continuar usando a plataforma',
              style: TextStyle(fontSize: 12, color: Colors.orange[800]),
            ),
          ),
        ],
      ),
    );
  }
}
