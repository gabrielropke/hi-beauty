// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_dropdown.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/core/constants/formatters/phone.dart';
import 'package:hibeauty/core/constants/image_picker_helper.dart';
import 'package:hibeauty/core/data/subscription.dart';
import 'package:hibeauty/core/services/subscription/data/model.dart';
import 'package:hibeauty/features/team/data/model.dart';
import 'package:hibeauty/features/team/presentation/bloc/team_bloc.dart';
import 'package:hibeauty/features/team/presentation/components/colorpicker.dart';
import 'package:hibeauty/features/team/presentation/components/comissao.dart';
import 'package:hibeauty/features/team/presentation/components/working_hours_selector.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:hibeauty/core/components/app_floating_message.dart';

Future<void> showAddTeamMemberSheet({
  required BuildContext context,
  required TeamLoaded state,
  required AppLocalizations l10n,
  String? id,
  TextEditingController? nameCtrl,
  TextEditingController? emailCtrl,
  TextEditingController? phoneCtrl,
  String? role,
  String? status,
  String? themeColor,
  File? profileImage,
  String? profileImageUrl,
  List<Map<String, dynamic>>? workingHours, // novo parâmetro
  CommissionConfigModel? commissionConfig,
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
        value: context.read<TeamBloc>(),
        child: Container(
          color: Colors.white,
          child: _AddTeamModal(
            state: state,
            l10n: l10n,
            id: id ?? '',
            initialName: nameCtrl?.text ?? '',
            initialEmail: emailCtrl?.text ?? '',
            initialPhone: phoneCtrl?.text ?? '',
            initialRole: role,
            initialStatus: status,
            initialThemeColor: themeColor,
            initialProfileImage: profileImage,
            initialProfileImageUrl: profileImageUrl,
            initialWorkingHours: workingHours,
            initialCommissionConfig: commissionConfig,
          ),
        ),
      );
    },
  );
}

class _AddTeamModal extends StatefulWidget {
  const _AddTeamModal({
    required this.state,
    required this.l10n,
    this.id = '',
    this.initialName = '',
    this.initialEmail = '',
    this.initialPhone = '',
    this.initialRole,
    this.initialStatus,
    this.initialThemeColor,
    this.initialProfileImage,
    this.initialProfileImageUrl,
    this.initialWorkingHours,
    this.initialCommissionConfig,
  });

  final TeamLoaded state;
  final AppLocalizations l10n;
  final String id;
  final String initialName;
  final String initialEmail;
  final String initialPhone;
  final String? initialRole;
  final String? initialStatus;
  final String? initialThemeColor;
  final File? initialProfileImage;
  final String? initialProfileImageUrl;
  final List<Map<String, dynamic>>? initialWorkingHours;
  final CommissionConfigModel? initialCommissionConfig;

  @override
  State<_AddTeamModal> createState() => _AddTeamModalState();
}

class _AddTeamModalState extends State<_AddTeamModal> {
  final ScrollController _controller = ScrollController();
  bool _showHeaderTitle = false;

  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  String? _selectedRole;
  Color _themeColor = AppColors.secondary;
  File? _profileImage;

  late List<Map<String, dynamic>> _workingHours;

  final _imageHelper = ImagePickerHelper();
  bool _downloadingImage = false;

  // GlobalKey para acessar o componente de comissão
  final GlobalKey _comissaoKey = GlobalKey();

  String _mapRole(String value, AppLocalizations l10n) {
    switch (value.toLowerCase()) {
      case 'owner':
        return l10n.owner;
      case 'manager':
        return l10n.manager;
      case 'employee':
        return l10n.employee;
      case 'freelancer':
        return l10n.freelancer;
      default:
        return '—';
    }
  }

  List<Map<String, Object?>> _getRoleOptions(AppLocalizations l10n) {
    return [
      {'label': _mapRole('owner', l10n), 'value': 'OWNER'},
      {'label': _mapRole('manager', l10n), 'value': 'MANAGER'},
      {'label': _mapRole('employee', l10n), 'value': 'EMPLOYEE'},
      {'label': _mapRole('freelancer', l10n), 'value': 'FREELANCER'},
    ];
  }

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
    _emailCtrl = TextEditingController(text: widget.initialEmail);
    _phoneCtrl = TextEditingController(text: widget.initialPhone);
    _selectedRole = widget.initialRole;
    _profileImage = widget.initialProfileImage;

    // Usar workingHours do membro existente se disponível, senão usar padrão
    _workingHours =
        widget.initialWorkingHours ??
        [
          {
            "day": "Segunda-feira",
            "startAt": "08:00",
            "endAt": "17:00",
            "isWorking": true,
          },
          {
            "day": "Terça-feira",
            "startAt": "08:00",
            "endAt": "17:00",
            "isWorking": true,
          },
          {
            "day": "Quarta-feira",
            "startAt": "08:00",
            "endAt": "17:00",
            "isWorking": true,
          },
          {
            "day": "Quinta-feira",
            "startAt": "08:00",
            "endAt": "17:00",
            "isWorking": true,
          },
          {
            "day": "Sexta-feira",
            "startAt": "08:00",
            "endAt": "17:00",
            "isWorking": true,
          },
          {
            "day": "Sábado",
            "startAt": "08:00",
            "endAt": "17:00",
            "isWorking": true,
          },
          {
            "day": "Domingo",
            "startAt": "08:00",
            "endAt": "17:00",
            "isWorking": false,
          },
        ];

    // Baixar imagem da URL se fornecida (modo edição)
    if (widget.initialProfileImageUrl != null &&
        widget.initialProfileImageUrl!.isNotEmpty &&
        widget.initialProfileImage == null) {
      _downloadProfileImage();
    }

    if (widget.initialThemeColor != null &&
        widget.initialThemeColor!.isNotEmpty) {
      try {
        _themeColor = Color(
          int.parse(widget.initialThemeColor!.replaceFirst('#', '0xff')),
        );
      } catch (_) {
        _themeColor = Colors.blue;
      }
    }

    _controller.addListener(() {
      final shouldShow = _controller.offset > 8;
      if (shouldShow != _showHeaderTitle) {
        setState(() => _showHeaderTitle = shouldShow);
      }
    });
  }

  Future<void> _downloadProfileImage() async {
    if (widget.initialProfileImageUrl == null) return;

    setState(() => _downloadingImage = true);

    try {
      final model = CreateTeamModel(
        name: '',
        email: '',
        phone: '',
        role: '',
        status: '',
        themeColor: '',
        workingHours: [],
        profileImageUrl: widget.initialProfileImageUrl,
      );

      final file = await model.getProfileImageFile();
      if (mounted && file != null) {
        setState(() => _profileImage = file);
      }
    } catch (_) {
      // Falha silenciosa no download
    } finally {
      if (mounted) {
        setState(() => _downloadingImage = false);
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final file = await _imageHelper.pickImage(
      context: context,
      l10n: widget.l10n,
      imageSource: ImageSource.gallery,
    );
    if (file != null) {
      setState(() => _profileImage = file);
    }
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
      message: 'Nome, email e telefone são obrigatórios',
      type: AppFloatingMessageType.error,
    );
  }

  void _submitForm() {
    if (!_isFormValid()) {
      _showValidationError();
      return;
    }

    // Obter configuração de comissão do componente
    final commissionConfig = (_comissaoKey.currentState as dynamic)
        ?.getCommissionConfig();

    if (widget.id.isEmpty) {
      context.read<TeamBloc>().add(
        CreateTeamMember(
          CreateTeamModel(
            name: _nameCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
            role: _selectedRole ?? 'EMPLOYEE',
            status: 'ACTIVE',
            themeColor: '#${_themeColor.value.toRadixString(16).substring(2)}',
            workingHours: _workingHours,
            profileImage: _profileImage,
            commissionConfig: commissionConfig,
          ),
        ),
      );
      return;
    }

    if (widget.id.isNotEmpty) {
      context.read<TeamBloc>().add(
        UpdateTeamMember(
          widget.id,
          CreateTeamModel(
            name: _nameCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
            role: _selectedRole ?? 'EMPLOYEE',
            status: 'ACTIVE',
            themeColor: '#${_themeColor.value.toRadixString(16).substring(2)}',
            workingHours: _workingHours,
            profileImage: _profileImage,
            commissionConfig: commissionConfig,
          ),
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final isEdit =
        widget.initialName.isNotEmpty ||
        widget.initialEmail.isNotEmpty ||
        widget.initialPhone.isNotEmpty;

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
                                ? 'Editar colaborador'
                                : 'Adicionar colaborador',
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
                    const SizedBox(height: 16),
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
                        isEdit ? 'Editar colaborador' : 'Adicionar colaborador',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),

                      if (SubscriptionData.statusEnum ==
                          SubscriptionStatus.ACTIVE) ...[
                        SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                LucideIcons.info,
                                color: Color.fromARGB(255, 14, 75, 105),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Impacto na Assinatura',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(255, 14, 75, 105),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color.fromARGB(
                                            255,
                                            14,
                                            75,
                                            105,
                                          ),
                                          height: 1.4,
                                          fontFamily: 'SORA',
                                          letterSpacing: 0.5,
                                        ),
                                        children: [
                                          TextSpan(
                                            text:
                                                'Cada colaborador adicional aumenta sua assinatura em ',
                                          ),
                                          TextSpan(
                                            text: 'R\$ 19,90/mês',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'SORA',
                                              letterSpacing: 1,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '. Este valor será cobrado automaticamente na próxima fatura.',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),

                      // Imagem de perfil
                      _ProfileImageSection(
                        profileImage: _profileImage,
                        themeColor: _themeColor,
                        name: _nameCtrl.text,
                        onTap: _pickProfileImage,
                        downloading: _downloadingImage,
                      ),
                      const SizedBox(height: 32),

                      TeamColorSelector(
                        initial: _themeColor,
                        onChanged: (c) => setState(() => _themeColor = c),
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
                        onChanged: (_) =>
                            setState(() {}), // atualiza avatar com inicial
                      ),
                      const SizedBox(height: 32),

                      // // Email
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

                      // Cargo
                      AppDropdown(
                        title: 'Cargo',
                        items: _getRoleOptions(l10n),
                        labelKey: 'label',
                        valueKey: 'value',
                        selectedValue: _selectedRole,
                        placeholder: const Text('Selecione o cargo'),
                        onChanged: (v) =>
                            setState(() => _selectedRole = v as String?),
                      ),
                      const SizedBox(height: 32),

                      // Horários de trabalho
                      WorkingHoursSelector(
                        initialWorkingHours: _workingHours,
                        onChanged: (hours) =>
                            setState(() => _workingHours = hours),
                      ),
                      const SizedBox(height: 32),

                      // Comissões
                      ComissaoTeamMember(
                        key: _comissaoKey,
                        initialCommissionConfig: widget.initialCommissionConfig,
                      ),

                      const SizedBox(height: 32),
                      Container(),
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
        child: BlocBuilder<TeamBloc, TeamState>(
          builder: (context, state) {
            final loading = state is TeamLoaded ? state.loading : false;
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
                label: isEdit ? l10n.save : l10n.add,
                loading: loading,
                function: _submitForm,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProfileImageSection extends StatelessWidget {
  final File? profileImage;
  final Color themeColor;
  final String name;
  final VoidCallback onTap;
  final bool downloading;

  const _ProfileImageSection({
    required this.profileImage,
    required this.themeColor,
    required this.name,
    required this.onTap,
    this.downloading = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.profile,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Text(
          l10n.profileEditDescription,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 16),
        GestureDetector(
          onTap: downloading ? null : onTap,
          child: Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeColor.withOpacity(0.1),
                  image: profileImage != null
                      ? DecorationImage(
                          image: FileImage(profileImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: profileImage == null
                    ? Center(
                        child: downloading
                            ? CircularProgressIndicator(
                                strokeWidth: 2,
                                color: themeColor,
                              )
                            : name.isNotEmpty
                            ? Text(
                                name[0].toUpperCase(),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w600,
                                  color: themeColor,
                                ),
                              )
                            : Icon(
                                LucideIcons.userRound,
                                size: 40,
                                color: themeColor,
                              ),
                      )
                    : null,
              ),
              if (!downloading)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                      border: Border.all(width: 4, color: Colors.white),
                    ),
                    child: Icon(
                      LucideIcons.pencil600,
                      size: 14,
                      color: Colors.black26,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
