import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/data/business.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/bloc/business_config_bloc.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/views/whatsapp/components/whatsapp_view_content.dart';
import 'package:hibeauty/l10n/app_localizations.dart';

class BusinessWhatsappScreen extends StatelessWidget {
  const BusinessWhatsappScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BusinessWhatsappView();
  }
}

class BusinessWhatsappView extends StatefulWidget {
  const BusinessWhatsappView({super.key});

  @override
  State<BusinessWhatsappView> createState() => _BusinessWhatsappViewState();
}

class _BusinessWhatsappViewState extends State<BusinessWhatsappView> {
  late final TextEditingController _controller;
  bool _isCopied = false;
  String _selectedTone = BusinessData.aiToneOfVoice ?? 'AMIGAVEL';
  String _selectedLanguage = BusinessData.aiLanguage ?? 'PT_BR';
  String _selectedVerbosity = BusinessData.aiVerbosity ?? 'MEDIO';

  @override
  void initState() {
    super.initState();
    _initializePhoneController();
    _initializeAiSettings();
  }

  void _initializeAiSettings() {
    // Initialize with current business data or defaults
    _selectedTone = BusinessData.aiToneOfVoice ?? 'AMIGAVEL';
    _selectedLanguage = BusinessData.aiLanguage ?? 'PT_BR';
    _selectedVerbosity = BusinessData.aiVerbosity ?? 'MEDIO';
  }

  void _handleSave() {
    context.read<BusinessConfigBloc>().add(
      AiConfig(
        aiToneOfVoice: _selectedTone,
        aiLanguage: _selectedLanguage,
        aiVerbosity: _selectedVerbosity,
      ),
    );
  }

  void _initializePhoneController() {
    final phoneNumber = BusinessData.whatsapp;
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      final digits = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
      if (digits.length >= 10) {
        final masked = digits.length == 11
            ? '(${digits.substring(0, 2)}) ${digits.substring(2, 7)}-${digits.substring(7)}'
            : '(${digits.substring(0, 2)}) ${digits.substring(2, 6)}-${digits.substring(6)}';
        _controller = TextEditingController(text: masked);
      } else {
        _controller = TextEditingController(text: phoneNumber);
      }
    } else {
      _controller = TextEditingController();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<BusinessConfigBloc, BusinessConfigState>(
        builder: (context, state) {
          return switch (state) {
            BusinessConfigLoading _ => const AppLoader(),
            BusinessConfigLoaded s => WhatsappViewContent(
              state: s,
              controller: _controller,
              isCopied: _isCopied,
              onCopyStateChanged: (copied) =>
                  setState(() => _isCopied = copied),
              selectedTone: _selectedTone,
              selectedLanguage: _selectedLanguage,
              selectedVerbosity: _selectedVerbosity,
              onToneChanged: (tone) => setState(() => _selectedTone = tone),
              onLanguageChanged: (language) => setState(() => _selectedLanguage = language),
              onVerbosityChanged: (verbosity) => setState(() => _selectedVerbosity = verbosity),
            ),
            BusinessConfigState() => const AppLoader(),
          };
        },
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: BlocBuilder<BusinessConfigBloc, BusinessConfigState>(
          builder: (context, state) {
            final isLoading = state is BusinessConfigLoaded ? state.loading : false;
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: AppButton(
                label: l10n.save,
                loading: isLoading,
                function: isLoading ? null : _handleSave,
              ),
            );
          },
        ),
      ),
    );
  }
}
