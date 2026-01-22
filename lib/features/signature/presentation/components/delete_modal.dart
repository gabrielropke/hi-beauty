// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_dropdown.dart';
import 'package:hibeauty/core/components/app_floating_message.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/features/signature/bloc/signature_bloc.dart';

Future<void> showCancelSubscriptionSheet({
  required BuildContext context,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    useSafeArea: true,
    barrierColor: Colors.transparent,
    clipBehavior: Clip.hardEdge,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
    ),
    builder: (ctx) {
      return BlocProvider.value(
        value: context.read<SignatureBloc>(),
        child: Container(
          color: Colors.white,
          child: _CancelSubscriptionModal(),
        ),
      );
    },
  );
}

class _CancelSubscriptionModal extends StatefulWidget {
  const _CancelSubscriptionModal();

  @override
  State<_CancelSubscriptionModal> createState() =>
      _CancelSubscriptionModalState();
}

class _CancelSubscriptionModalState extends State<_CancelSubscriptionModal> {
  final ScrollController _controller = ScrollController();
  bool _showHeaderTitle = false;

  late final TextEditingController _commentsCtrl;
  String? _selectedReason;

  List<Map<String, Object?>> _getCancelReasons() {
    return [
      {'label': 'Muito caro para o meu orçamento', 'value': 'TOO_EXPENSIVE'},
      {'label': 'Não estou usando os recursos', 'value': 'NOT_USING'},
      {'label': 'Faltam recursos que eu preciso', 'value': 'MISSING_FEATURES'},
      {
        'label': 'Suporte não atende minhas necessidades',
        'value': 'TECHNICAL_ISSUES',
      },
      {'label': 'Mudando para o concorrente', 'value': 'BUSINESS_CHANGE'},
      {'label': 'Fechando meu negócio', 'value': 'CLOSING_BUSINESS'},
      {'label': 'Outro motivo', 'value': 'OTHER'},
    ];
  }

  @override
  void initState() {
    super.initState();
    _commentsCtrl = TextEditingController();

    _controller.addListener(() {
      final shouldShow = _controller.offset > 8;
      if (shouldShow != _showHeaderTitle) {
        setState(() => _showHeaderTitle = shouldShow);
      }
    });
  }

  @override
  void dispose() {
    _commentsCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    return _selectedReason != null && _selectedReason!.isNotEmpty;
  }

  void _submitForm() {
    if (!_isFormValid()) {
      AppFloatingMessage.show(
        context,
        message: 'Preencha o motivo do cancelamento para continuar.',
        type: AppFloatingMessageType.error,
      );
      return;
    }

    context.read<SignatureBloc>().add(CancelSignature());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,
                        opacity: _showHeaderTitle ? 1 : 0,
                        child: const Text(
                          'Cancelar Assinatura',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                opacity: _showHeaderTitle ? 1 : 0,
                child: Divider(
                  thickness: 1,
                  color: Colors.grey[300],
                  height: 5,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _controller,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cancelar Assinatura',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Sua assinatura será cancelada no final do período atual. Nos ajude a melhorar contando o motivo do cancelamento.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Motivo do cancelamento
                      AppDropdown(
                        title: 'Motivo do cancelamento',
                        isrequired: true,
                        items: _getCancelReasons(),
                        labelKey: 'label',
                        valueKey: 'value',
                        selectedValue: _selectedReason,
                        placeholder: const Text(
                          'Selecione um motivo',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selectedReason = value as String?;
                          });
                        },
                      ),
                      const SizedBox(height: 32),

                      // Comentários adicionais
                      AppTextformfield(
                        title: 'Comentários adicionais (opcional)',
                        controller: _commentsCtrl,
                        hintText: 'Conte-nos como podemos melhorar...',
                        isMultiline: true,
                        multilineInitialLines: 3,
                        maxLength: 500,
                        textInputAction: TextInputAction.done,
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: BlocBuilder<SignatureBloc, SignatureState>(
          builder: (context, state) {
            final loading = state is SignatureLoaded ? state.loading : false;
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 12,
                children: [
                  AppButton(
                    label: 'Manter Assinatura',
                    fillColor: Colors.white,
                    borderColor: Colors.black45,
                    borderWidth: 0.5,
                    function: () => Navigator.of(context).pop(),
                    labelStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  AppButton(
                    label: 'Confirmar',
                    fillColor: Colors.red,
                    loading: loading,
                    function: _submitForm,
                    labelColor: Colors.white,
                    borderColor: Colors.white,
                    assetColor: Colors.white,
                    borderWidth: 0.5,
                    labelStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
