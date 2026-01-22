import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/core/constants/formatters/phone.dart';
import 'package:hibeauty/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PersonalBusinessData extends StatefulWidget {
  final OnboardingLoaded state;
  final TextEditingController nameBusinessController;
  final TextEditingController slugBusinessController;
  final TextEditingController whatsappController;
  final TextEditingController instagramController;
  final TextEditingController descriptionController;
  const PersonalBusinessData({
    super.key,
    required this.nameBusinessController,
    required this.slugBusinessController,
    required this.state,
    required this.whatsappController,
    required this.instagramController,
    required this.descriptionController,
  });

  @override
  State<PersonalBusinessData> createState() => _PersonalBusinessDataState();
}

class _PersonalBusinessDataState extends State<PersonalBusinessData> {
  late final SlugGeneratorService _slugService;
  Timer? _debounce;
  bool _userEditedSlug = false;

  @override
  void initState() {
    super.initState();
    _slugService = SlugGeneratorService();

    widget.slugBusinessController.addListener(() {
      // Se o usuário alterar manualmente (não via geração automática), marcamos a flag.
      // Usamos Selection para diferenciar? Simples: se foco está no campo do slug.
      if (FocusScope.of(context).focusedChild?.context?.widget
          is EditableText) {
        _userEditedSlug = true;
      }
    });

    widget.nameBusinessController.addListener(_onNameChanged);
  }

  void _onNameChanged() {
    final name = widget.nameBusinessController.text;
    if (name.length < 3) return;

    if (_userEditedSlug) return; // Não sobrescrever edição manual.

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final suggestion = _slugService.generate(name);
      if (suggestion.isNotEmpty) {
        // Só atualiza se o usuário ainda não mexeu.
        if (!_userEditedSlug) {
          widget.slugBusinessController.text = suggestion;
          widget.slugBusinessController.selection = TextSelection.fromPosition(
            TextPosition(offset: widget.slugBusinessController.text.length),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.nameBusinessController.removeListener(_onNameChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final error = widget.state.message.values.first.isNotEmpty
        ? (widget.state.message.keys.first == 'isEmpty' ? null : '')
        : null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 42),
            Text(
              l10n.configAccount,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.black.withValues(alpha: 0.8),
              ),
            ),
            SizedBox(height: 20),
            Text(
              l10n.yourBusinessNametitle,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              l10n.dataNullDescription,
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
            SizedBox(height: 32),
            AppTextformfield(
              isrequired: true,
              title: l10n.yourBusinessName,
              hintText: l10n.yourBusinessNameHint,
              controller: widget.nameBusinessController,
              error: error,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onChanged: (val) =>
                  context.read<OnboardingBloc>().add(CloseMessage()),
            ),
            SizedBox(height: 24),
            _slug(l10n, widget.slugBusinessController, error),
            SizedBox(height: 24),
            AppTextformfield(
              isrequired: true,
              title: l10n.whatsapp,
              error: error,
              hintText: l10n.whatsappHint,
              controller: widget.whatsappController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              textInputFormatter: PhoneFormatter(
                mask: '(##) #####-####',
                maxDigits: 11,
              ),
              onChanged: (_) =>
                  context.read<OnboardingBloc>().add(CloseMessage()),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  _slug(l10n, controller, error) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 4,
          children: [
            Text(
              l10n.createYourLink,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Text(
              '*',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.01),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
              ),
              child: Text(
                'hibeauty.co/',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black.withValues(alpha: 0.6),
                ),
              ),
            ),
            Expanded(
              child: AppTextformfield(
                controller: controller,
                hintText: l10n.slugHint,
                error: error,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                textInputFormatter: FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z0-9]'),
                ),
                borderRadiusCustomized: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                onChanged: (val) =>
                    context.read<OnboardingBloc>().add(CloseMessage()),
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        Row(
          spacing: 6,
          children: [
            Icon(
              LucideIcons.link,
              size: 11,
              color: Colors.black.withValues(alpha: 0.6),
            ),
            Text(
              l10n.slugDescription,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SlugGeneratorService {
  String generate(String input) {
    var text = input.trim().toLowerCase();

    // Remover acentos (básico)
    const Map<String, String> map = {
      'á': 'a',
      'à': 'a',
      'â': 'a',
      'ã': 'a',
      'ä': 'a',
      'é': 'e',
      'è': 'e',
      'ê': 'e',
      'ë': 'e',
      'í': 'i',
      'ì': 'i',
      'î': 'i',
      'ï': 'i',
      'ó': 'o',
      'ò': 'o',
      'ô': 'o',
      'õ': 'o',
      'ö': 'o',
      'ú': 'u',
      'ù': 'u',
      'û': 'u',
      'ü': 'u',
      'ç': 'c',
    };
    final buffer = StringBuffer();
    for (final ch in text.characters) {
      buffer.write(map[ch] ?? ch);
    }
    text = buffer.toString();

    // Trocar espaços por hífen
    text = text.replaceAll(RegExp(r'\s+'), '');

    // Remover caracteres inválidos
    text = text.replaceAll(RegExp(r'[^a-z0-9\-]'), '');

    // Remover hífens duplicados
    text = text.replaceAll(RegExp(r'-{2,}'), '-');

    // Remover hífens nas extremidades
    text = text.replaceAll(RegExp(r'^-+'), '').replaceAll(RegExp(r'-+$'), '');

    return text;
  }
}
