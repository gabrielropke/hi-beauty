import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_dropdown.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/core/data/business.dart';
import 'package:hibeauty/features/business/data/model.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/bloc/business_config_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

Future<void> showAddressDataEditSheet({
  required BuildContext context,
  required BusinessConfigLoaded state,
  required AppLocalizations l10n,
  required TextEditingController zipCodeCtrl,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    useSafeArea: true,
    barrierColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
    ),
    builder: (ctx) => BlocProvider.value(
      value: context.read<BusinessConfigBloc>(),
      child: _AddressEditSheet(
        state: state,
        l10n: l10n,
        zipCodeCtrl: zipCodeCtrl,
      ),
    ),
  );
}

class _AddressEditSheet extends StatefulWidget {
  final BusinessConfigLoaded state;
  final AppLocalizations l10n;
  final TextEditingController zipCodeCtrl;
  const _AddressEditSheet({
    required this.state,
    required this.l10n,
    required this.zipCodeCtrl,
  });

  @override
  State<_AddressEditSheet> createState() => _AddressEditSheetState();
}

class _AddressEditSheetState extends State<_AddressEditSheet> {
  final ScrollController _controller = ScrollController();
  bool _showHeaderTitle = false;
  bool _loadingCep = false;
  bool _cepLoaded = false;

  late final TextEditingController _addressCtrl;
  late final TextEditingController _neighborhoodCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _numberCtrl;
  late final TextEditingController _complementCtrl;

  String? _selectedState;
  String? _selectedCountry;

  final List<Map<String, Object?>> _states = [
    {'label': 'AC', 'value': 'AC'},
    {'label': 'AL', 'value': 'AL'},
    {'label': 'AP', 'value': 'AP'},
    {'label': 'AM', 'value': 'AM'},
    {'label': 'BA', 'value': 'BA'},
    {'label': 'CE', 'value': 'CE'},
    {'label': 'DF', 'value': 'DF'},
    {'label': 'ES', 'value': 'ES'},
    {'label': 'GO', 'value': 'GO'},
    {'label': 'MA', 'value': 'MA'},
    {'label': 'MG', 'value': 'MG'},
    {'label': 'PA', 'value': 'PA'},
    {'label': 'PB', 'value': 'PB'},
    {'label': 'PR', 'value': 'PR'},
    {'label': 'PE', 'value': 'PE'},
    {'label': 'PI', 'value': 'PI'},
    {'label': 'RJ', 'value': 'RJ'},
    {'label': 'RN', 'value': 'RN'},
    {'label': 'RS', 'value': 'RS'},
    {'label': 'RO', 'value': 'RO'},
    {'label': 'RR', 'value': 'RR'},
    {'label': 'SC', 'value': 'SC'},
    {'label': 'SP', 'value': 'SP'},
    {'label': 'SE', 'value': 'SE'},
    {'label': 'TO', 'value': 'TO'},
  ];
  final List<Map<String, Object?>> _countries = [
    {'label': 'Brasil', 'value': 'BR'},
  ];

  @override
  void initState() {
    super.initState();
    _addressCtrl = TextEditingController(text: BusinessData.address ?? '');
    _neighborhoodCtrl = TextEditingController(
      text: BusinessData.neighborhood ?? '',
    );
    _cityCtrl = TextEditingController(text: BusinessData.city ?? '');
    _numberCtrl = TextEditingController(text: BusinessData.number ?? '');
    _complementCtrl = TextEditingController(text: BusinessData.complement ?? '');
    _selectedState = BusinessData.state;
    _selectedCountry = BusinessData.country ?? 'BR';
    if (widget.zipCodeCtrl.text.isNotEmpty) {
      _cepLoaded = true;
      if (BusinessData.zipCode == null) {
        _fetchCep(widget.zipCodeCtrl.text.replaceAll(RegExp(r'\D'), ''));
      }
    }
    if ((BusinessData.zipCode ?? '').isNotEmpty) {
      widget.zipCodeCtrl.text = BusinessData.zipCode!;
      _cepLoaded = true;
    }
    _controller.addListener(() {
      final shouldShow = _controller.offset > 8;
      if (shouldShow != _showHeaderTitle) {
        setState(() => _showHeaderTitle = shouldShow);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _addressCtrl.dispose();
    _neighborhoodCtrl.dispose();
    _cityCtrl.dispose();
    _numberCtrl.dispose();
    _complementCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchCep(String digits) async {
    setState(() {
      _loadingCep = true;
      _cepLoaded = false;
    });
    try {
      final res = await http.get(
        Uri.parse('https://viacep.com.br/ws/$digits/json/'),
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data['erro'] != true) {
          _addressCtrl.text = (data['logradouro'] ?? '').toString();
          _neighborhoodCtrl.text = (data['bairro'] ?? '').toString();
          _cityCtrl.text = (data['localidade'] ?? '').toString();
          _selectedState = (data['uf'] ?? '').toString();
          _selectedCountry = 'BR';
          _cepLoaded = true;
        }
      }
    } catch (_) {}
    setState(() => _loadingCep = false);
  }

  void _onSave() {
    context.read<BusinessConfigBloc>().add(
      UpdateSetupAddress(
        SetupAddressModel(
          zipCode: widget.zipCodeCtrl.text,
          address: _addressCtrl.text,
          neighborhood: _neighborhoodCtrl.text,
          city: _cityCtrl.text,
          state: _selectedState ?? BusinessData.state ?? '',
          country: _selectedCountry ?? 'BR',
          number: _numberCtrl.text,
          complement: _complementCtrl.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
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
                  children: [
                    Expanded(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,
                        opacity: _showHeaderTitle ? 1 : 0,
                        child: IgnorePointer(
                          ignoring: !_showHeaderTitle,
                          child: Text(
                            l10n.addressEdit,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
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
                opacity: _showHeaderTitle ? 1 : 0,
                child: Divider(
                  thickness: 1,
                  color: Colors.grey[300],
                  height: 8,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _controller,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.addressEdit,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        l10n.businessAddress,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 32),
                      AppTextformfield(
                        isrequired: true,
                        title: 'CEP',
                        hintText: '00000-000',
                        controller: widget.zipCodeCtrl,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.search,
                        textInputFormatter: CepInputFormatter(),
                        onChanged: (value) {
                          final digits = value.replaceAll(RegExp(r'\D'), '');
                          if (digits.length == 8) _fetchCep(digits);
                          if (digits.isEmpty) {
                            setState(() => _cepLoaded = false);
                          }
                        },
                        suffixIcon: _loadingCep
                            ? const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 8),
                      if (!_cepLoaded && !_loadingCep)
                        Text(
                          'Digite o CEP para continuar',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black.withValues(alpha: 0.6),
                          ),
                        ),
                      if (_loadingCep)
                        const Text(
                          'Buscando CEP...',
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                      const SizedBox(height: 24),
                      if (_cepLoaded) ...[
                        AppTextformfield(
                          isrequired: true,
                          title: 'Endereço',
                          hintText: 'Rua / Avenida',
                          controller: _addressCtrl,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: AppTextformfield(
                                isrequired: true,
                                title: 'Número',
                                hintText: '123',
                                controller: _numberCtrl,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 3,
                              child: AppTextformfield(
                                title: 'Complemento',
                                hintText: 'Apto / Sala',
                                controller: _complementCtrl,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        AppTextformfield(
                          isrequired: true,
                          title: 'Bairro',
                          hintText: 'Bairro',
                          controller: _neighborhoodCtrl,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        AppTextformfield(
                          isrequired: true,
                          title: 'Cidade',
                          hintText: 'Cidade',
                          controller: _cityCtrl,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: AppDropdown(
                                title: 'Estado',
                                items: _states,
                                labelKey: 'label',
                                valueKey: 'value',
                                selectedValue: _selectedState,
                                placeholder: const Text(
                                  'UF',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                onChanged: (v) => setState(
                                  () => _selectedState = v as String?,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: IgnorePointer(
                                child: Opacity(
                                  opacity: 0.6,
                                  child: AppDropdown(
                                    title: 'País',
                                    items: _countries,
                                    labelKey: 'label',
                                    valueKey: 'value',
                                    selectedValue: _selectedCountry,
                                    placeholder: const Text(
                                      'País',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    onChanged: (v) => setState(
                                      () => _selectedCountry = v as String?,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
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
        child: BlocBuilder<BusinessConfigBloc, BusinessConfigState>(
          builder: (context, state) {
            final loading = (state is BusinessConfigLoaded)
                ? state.loading
                : false;
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
                label: widget.l10n.save,
                loading: loading,
                function: _cepLoaded && !_loadingCep ? _onSave : null,
              ),
            );
          },
        ),
      ),
    );
  }
}

class CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 8) digits = digits.substring(0, 8);
    String masked = digits;
    if (digits.length > 5) {
      masked = '${digits.substring(0, 5)}-${digits.substring(5)}';
    }
    return TextEditingValue(
      text: masked,
      selection: TextSelection.collapsed(offset: masked.length),
    );
  }
}
