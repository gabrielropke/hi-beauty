import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:hibeauty/core/components/custom_app_bar.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/bloc/business_config_bloc.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/views/whatsapp/components/error_message.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/views/whatsapp/components/phone_input_section.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/views/whatsapp/components/pairing_code_section.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/views/whatsapp/components/ai_tone_dropdown.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/views/whatsapp/components/ai_verbosity_dropdown.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/views/whatsapp/components/ai_language_dropdown.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/views/whatsapp/components/quick_tone_guide.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class WhatsappViewContent extends StatefulWidget {
  final BusinessConfigLoaded state;
  final TextEditingController controller;
  final bool isCopied;
  final ValueChanged<bool> onCopyStateChanged;
  final String selectedTone;
  final String selectedLanguage;
  final String selectedVerbosity;
  final ValueChanged<String> onToneChanged;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<String> onVerbosityChanged;

  const WhatsappViewContent({
    super.key,
    required this.state,
    required this.controller,
    required this.isCopied,
    required this.onCopyStateChanged,
    required this.selectedTone,
    required this.selectedLanguage,
    required this.selectedVerbosity,
    required this.onToneChanged,
    required this.onLanguageChanged,
    required this.onVerbosityChanged,
  });

  @override
  State<WhatsappViewContent> createState() => _WhatsappViewContentState();
}

class _WhatsappViewContentState extends State<WhatsappViewContent> {
  final ScrollController _scrollController = ScrollController();

  String _getToneDescription(String tone, AppLocalizations l10n) {
    switch (tone) {
      case 'AMIGAVEL':
        return l10n.exampleFriendly1;
      case 'PROFISSIONAL':
        return l10n.exampleProfessional;
      case 'DESCONTRAIDO':
        return l10n.exampleCasual;
      case 'FORMAL':
        return l10n.exampleFormal;
      case 'ENGRACADO':
        return l10n.exampleFunny;
      default:
        return l10n.toneFriendlyDesc;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        CustomAppBar(
                  title: '${l10n.whatsapp} + ${l10n.ai}',
                  controller: _scrollController,
                  backgroundColor: Colors.white,
                ),
        Expanded(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ErrorMessage(state: widget.state),
                    const SizedBox(height: 20),
                    PhoneInputSection(
                      controller: widget.controller,
                      state: widget.state,
                    ),
                    const SizedBox(height: 12),
                    PairingCodeSection(
                      state: widget.state,
                      isCopied: widget.isCopied,
                      onCopyStateChanged: widget.onCopyStateChanged,
                    ),
                    const SizedBox(height: 32),
            
                    Row(
                      children: [
                        Icon(LucideIcons.sparkles400),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.aiSettings,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
            
                    const SizedBox(height: 12),
            
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              spacing: 12,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(LucideIcons.circleUser300, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        l10n.personalityStyle,
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                
                                Text(
                                  l10n.aiPersonalityAdjust,
                                  style: TextStyle(fontSize: 11, color: Colors.black54),
                                ),
                
                                AiToneDropdown(
                                  initialValue: widget.selectedTone,
                                  onChanged: widget.onToneChanged,
                                ),

                                AiVerbosityDropdown(
                                  initialValue: widget.selectedVerbosity,
                                  onChanged: widget.onVerbosityChanged,
                                ),
                                const SizedBox(),

                                AiLanguageDropdown(
                                  initialValue: widget.selectedLanguage,
                                  onChanged: widget.onLanguageChanged,
                                ),
                                const SizedBox(height: 12),
                
                                Row(
                                  children: [
                                    Icon(LucideIcons.sparkles400, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        l10n.generatedExample,
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.04),
                                        blurRadius: 3,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      _getToneDescription(widget.selectedTone, l10n),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black87,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ),
                
                                SizedBox(height: 12),
                
                                QuickToneGuide(
                                  selectedTone: widget.selectedTone,
                                  onToneChanged: widget.onToneChanged,
                                ),
                              ],
                            ),
                          ),
                          if (!widget.state.whatsappConnected)
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.6),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            LucideIcons.lock400,
                                            size: 32,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            l10n.connectWhatsappToEditPersonality,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
