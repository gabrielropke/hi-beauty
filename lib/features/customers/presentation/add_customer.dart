// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/core/components/app_date_picker.dart';
import 'package:hibeauty/core/constants/formatters/phone.dart';
import 'package:hibeauty/features/customers/data/model.dart';
import 'package:hibeauty/features/customers/presentation/bloc/customers_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:hibeauty/core/components/app_floating_message.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

Future<void> showAddCustomerSheet({
  required BuildContext context,
  required CustomersLoaded state,
  required AppLocalizations l10n,
  CustomerModel? customer,
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
        value: context.read<CustomersBloc>(),
        child: Container(
          color: Colors.white,
          child: _AddCustomerModal(
            state: state,
            l10n: l10n,
            customer: customer,
          ),
        ),
      );
    },
  );
}

class _AddCustomerModal extends StatefulWidget {
  const _AddCustomerModal({
    required this.state,
    required this.l10n,
    this.customer,
  });

  final CustomersLoaded state;
  final AppLocalizations l10n;
  final CustomerModel? customer;

  @override
  State<_AddCustomerModal> createState() => _AddCustomerModalState();
}

class _AddCustomerModalState extends State<_AddCustomerModal> {
  final ScrollController _controller = ScrollController();
  bool _showHeaderTitle = false;

  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _notesCtrl;
  DateTime? _birthDate;
  bool _isActive = true;


  @override
  void initState() {
    super.initState();
    
    final customer = widget.customer;
    _nameCtrl = TextEditingController(text: customer?.name ?? '');
    _emailCtrl = TextEditingController(text: customer?.email ?? '');
    
    // Apply phone mask to initial value if editing
    final phoneValue = customer?.phone ?? '';
    final formatter = PhoneFormatter(mask: '(##) #####-####', maxDigits: 11);
    final maskedPhone = phoneValue.isNotEmpty ? formatter.formatEditUpdate(
      const TextEditingValue(),
      TextEditingValue(text: phoneValue),
    ).text : '';
    _phoneCtrl = TextEditingController(text: maskedPhone);
    
    _notesCtrl = TextEditingController(text: customer?.notes ?? '');
    _birthDate = customer?.birthDate;
    _isActive = customer?.isActive ?? true;

    _controller.addListener(() {
      final shouldShow = _controller.offset > 8;
      if (shouldShow != _showHeaderTitle) {
        setState(() => _showHeaderTitle = shouldShow);
      }
    });
  }


  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _notesCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }


  bool _isFormValid() {
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    return name.isNotEmpty && phone.isNotEmpty && email.isNotEmpty;
  }

  void _showValidationError() {
    AppFloatingMessage.show(
      context,
      message: 'Preencha todos os campos',
      type: AppFloatingMessageType.error,
    );
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          child: AppDatePicker(
            selectionMode: AppDateSelectionMode.single,
            firstDay: DateTime(1960),
            lastDay: DateTime.now(),
            selected: _birthDate ?? DateTime.now().subtract(const Duration(days: 365 * 25)),
            onSelected: (date) {
              Navigator.of(context).pop(date);
            },
          ),
        );
      },
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  void _submitForm() {
    if (!_isFormValid()) {
      _showValidationError();
      return;
    }

    final customer = widget.customer;
    
    if (customer == null) {
      // Create new customer
      context.read<CustomersBloc>().add(
        CreateCustomers(
          CreateCustomerModel(
            name: _nameCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
            birthDate: _birthDate,
            notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
            isActive: _isActive,
          ),
        ),
      );
    } else {
      // Update existing customer
      context.read<CustomersBloc>().add(
        UpdateCustomers(
          customer.id,
          CreateCustomerModel(
            name: _nameCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
            birthDate: _birthDate,
            notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
            isActive: _isActive,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final isEdit = widget.customer != null;

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
                        child: IgnorePointer(
                          ignoring: !_showHeaderTitle,
                          child: Text(
                            isEdit
                                ? 'Editar cliente'
                                : 'Cadastrar cliente',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
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
                      Text(
                        isEdit ? 'Editar cliente' : 'Cadastrar cliente',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Nome
                      AppTextformfield(
                        isrequired: true,
                        title: l10n.name,
                        hintText: '',
                        controller: _nameCtrl,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 32),

                      // Email
                      AppTextformfield(
                        isrequired: true,
                        title: 'E-mail',
                        hintText: '',
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 32),

                      // Telefone
                      AppTextformfield(
                        isrequired: true,
                        title: 'Telefone',
                        hintText: '(11) 99999-9999',
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        textInputFormatter: PhoneFormatter(
                          mask: '(##) #####-####',
                          maxDigits: 11,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Data de nascimento
                      GestureDetector(
                        onTap: _selectBirthDate,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Data de nascimento',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _birthDate != null
                                    ? '${_birthDate!.day.toString().padLeft(2, '0')}/${_birthDate!.month.toString().padLeft(2, '0')}/${_birthDate!.year}'
                                    : 'Clique para selecionar',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _birthDate != null ? Colors.black87 : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Notas
                      AppTextformfield(
                        title: 'Notas',
                        hintText: 'Observações sobre o cliente...',
                        controller: _notesCtrl,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        isMultiline: true,
                        multilineInitialLines: 2,
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
        child: BlocBuilder<CustomersBloc, CustomersState>(
          builder: (context, state) {
            final loading = state is CustomersLoaded ? state.loading : false;
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
              child: AppButton(
                spacing: 10,
                loading: loading,
                preffixIcon: Icon(LucideIcons.userPlus, color: Colors.white, size: 20),
                label: isEdit ? l10n.save : 'Criar Cliente',
                function: _submitForm,
              ),
            );
          },
        ),
      ),
    );
  }
}

