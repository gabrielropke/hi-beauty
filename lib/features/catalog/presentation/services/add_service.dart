// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_dropdown.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/core/components/app_toggle_switch.dart';
import 'package:hibeauty/core/constants/formatters/money.dart';
import 'package:hibeauty/core/constants/image_picker_helper.dart';
import 'package:hibeauty/features/catalog/data/model.dart';
import 'package:hibeauty/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:hibeauty/features/team/data/model.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:hibeauty/core/components/app_floating_message.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:hibeauty/features/catalog/presentation/components/add_category.dart';

String mapVisibility(String value) {
  switch (value) {
    case 'public':
      return 'Público';
    case 'private':
      return 'Privado';
    default:
      return value;
  }
}

Future<void> showAddService({
  required BuildContext context,
  required CatalogLoaded state,
  required AppLocalizations l10n,
  ServicesModel? service,
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
        value: context.read<CatalogBloc>(),
        child: Container(
          color: Colors.white,
          child: _AddServiceModal(state: state, l10n: l10n, service: service),
        ),
      );
    },
  );
}

class _AddServiceModal extends StatefulWidget {
  const _AddServiceModal({
    required this.state,
    required this.l10n,
    this.service,
  });

  final CatalogLoaded state;
  final AppLocalizations l10n;
  final ServicesModel? service;

  @override
  State<_AddServiceModal> createState() => _AddServiceModalState();
}

class _AddServiceModalState extends State<_AddServiceModal>
    with SingleTickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  bool _showHeaderTitle = false;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _durationCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _descriptionCtrl;

  // Formatador de dinheiro inline
  late final TextInputFormatter _moneyFormatter;

  String? _selectedLocationType;

  // Categoria selecionada
  String? _selectedCategoryId;

  // Visibilidade
  String _visibility = 'public';

  // Colaboradores selecionados
  Set<String> _selectedTeamMembers = {};

  // Imagem do serviço
  File? _serviceImage;
  bool _hideImageHint = false;
  final _imagePickerHelper = ImagePickerHelper();

  @override
  void initState() {
    super.initState();

    // Inicializar formatador de dinheiro
    _moneyFormatter = TextInputFormatter.withFunction((oldValue, newValue) {
      if (newValue.text.isEmpty) return newValue;

      final value =
          double.tryParse(newValue.text.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
      final formatted = safeMoneyFormat((value / 100).toString());

      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    });

    final service = widget.service;
    _nameCtrl = TextEditingController(text: service?.name ?? '');
    _durationCtrl = TextEditingController(
      text: service?.duration.toString() ?? '',
    );

    // Aplicar formatação de dinheiro no valor inicial
    final priceValue = service?.price ?? 0.0;
    _priceCtrl = TextEditingController(
      text: priceValue > 0 ? safeMoneyFormat(priceValue.toString()) : '',
    );

    _descriptionCtrl = TextEditingController(text: service?.description ?? '');

    // Inicializar todos os campos se estiver editando
    if (service != null) {
      _selectedTeamMembers = service.teamMembers
          .map((member) => member.id)
          .toSet();
      _selectedCategoryId = service.category?.id;
      _selectedLocationType = service.locationType.toLowerCase();
      _visibility = service.visibility.toLowerCase();
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
    _nameCtrl.dispose();
    _durationCtrl.dispose();
    _priceCtrl.dispose();
    _descriptionCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    final name = _nameCtrl.text.trim();
    final duration = _durationCtrl.text.trim();
    final price = _priceCtrl.text.trim();
    return name.isNotEmpty &&
        duration.isNotEmpty &&
        price.isNotEmpty &&
        _getPriceValue() > 0 &&
        _selectedTeamMembers.isNotEmpty;
  }

  double _getPriceValue() {
    final priceText = _priceCtrl.text
        .replaceAll(RegExp(r'[^\d,]'), '')
        .replaceAll(',', '.');
    return double.tryParse(priceText) ?? 0.0;
  }

  void _showValidationError() {
    String message = 'Preencha todos os campos';
    if (_selectedTeamMembers.isEmpty) {
      message = 'Selecione pelo menos um colaborador';
    }
    AppFloatingMessage.show(
      context,
      message: message,
      type: AppFloatingMessageType.error,
    );
  }

  void _toggleTeamMember(String memberId) {
    setState(() {
      if (_selectedTeamMembers.contains(memberId)) {
        _selectedTeamMembers.remove(memberId);
      } else {
        _selectedTeamMembers.add(memberId);
      }
    });
  }

  Future<void> _pickServiceImage() async {
    final l10n = widget.l10n;
    final file = await _imagePickerHelper.pickImage(
      context: context,
      l10n: l10n,
      imageSource: ImageSource.gallery,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    if (mounted && file != null) {
      setState(() {
        _serviceImage = file;
        _hideImageHint = true;
      });
    }
  }

  void _submitForm() {
    if (!_isFormValid()) {
      _showValidationError();
      return;
    }

    final model = CreateServiceModel(
      name: _nameCtrl.text.trim(),
      duration: int.parse(_durationCtrl.text.trim()),
      price: _getPriceValue(),
      currency: 'BRL',
      locationType: _selectedLocationType?.toUpperCase() ?? 'IN_PERSON',
      visibility: _visibility.toUpperCase(),
      teamMemberIds: _selectedTeamMembers.toList(),
      description:
          _descriptionCtrl.text.trim().isNotEmpty ? _descriptionCtrl.text.trim() : null,
      categoryId: _selectedCategoryId,
      coverImage: _serviceImage,
    );

    if (widget.service != null) {
      // Modo de edição - atualizar serviço existente
      context.read<CatalogBloc>().add(UpdateService(widget.service!.id, model));
    } else {
      // Modo de criação - criar novo serviço
      context.read<CatalogBloc>().add(CreateService(model));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.service != null;

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
                            isEdit ? 'Editar serviço' : 'Adicionar',
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEdit ? 'Editar serviço' : 'Adicionar',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 32),
                            // Foto do serviço
                            _ServiceImagePicker(
                              image: _serviceImage,
                              networkImage: widget.service?.coverImageUrl,
                              hideHint: _hideImageHint,
                              onPicked: (file) {
                                setState(() {
                                  _serviceImage = file;
                                  _hideImageHint = true;
                                });
                              },
                              onTap: _pickServiceImage,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        height: 16,
                        color: Colors.grey[50],
                      ),
                      SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            // Nome
                            AppTextformfield(
                              isrequired: true,
                              title: 'Nome do serviço',
                              hintText: 'Ex: Corte de cabelo',
                              controller: _nameCtrl,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 32),

                            // Duração
                            AppTextformfield(
                              isrequired: true,
                              title: 'Duração (min)',
                              hintText: '30',
                              controller: _durationCtrl,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              textInputFormatter:
                                  FilteringTextInputFormatter.digitsOnly,
                            ),
                            const SizedBox(height: 32),

                            // Preço
                            AppTextformfield(
                              isrequired: true,
                              title: 'Preço',
                              hintText: 'R\$ 0,00',
                              controller: _priceCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              textInputAction: TextInputAction.next,
                              textInputFormatter: _moneyFormatter,
                            ),
                            const SizedBox(height: 32),

                            // Categoria
                            BlocBuilder<CatalogBloc, CatalogState>(
                              builder: (context, state) {
                                final categories = state is CatalogLoaded 
                                    ? state.serviceCategories 
                                    : widget.state.serviceCategories;
                                    
                                return AppDropdown(
                                  title: 'Categoria',
                                  items: categories
                                      .map(
                                        (category) => {
                                          'label': category.name,
                                          'value': category.id,
                                          'color': category.color,
                                        },
                                      )
                                      .toList(),
                                  labelKey: 'label',
                                  valueKey: 'value',
                                  leadingKey: 'color',
                                  placeholder: const Text(
                                    'Selecione uma categoria',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                  selectedValue: _selectedCategoryId,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCategoryId = value as String?;
                                    });
                                  },
                                  onAddPressed: () {
                                    showAddCategory(
                                      context: context,
                                      l10n: widget.l10n,
                                      type: CategoryType.service,
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 32),

                            // Localização
                            AppDropdown(
                              isrequired: true,
                              title: 'Onde o serviço é realizado?',
                              items: const [
                                {
                                  'label': 'Presencial',
                                  'value': 'in_person',
                                  'subtitle': 'No local',
                                },
                                {
                                  'label': 'Remoto',
                                  'value': 'online',
                                  'subtitle': 'Remoto',
                                },
                                {
                                  'label': 'A combinar',
                                  'value': 'to_be_arranged',
                                  'subtitle': 'Flexível',
                                },
                              ],
                              labelKey: 'label',
                              valueKey: 'value',
                              extraLabelKey: 'subtitle',
                              placeholder: const Text(
                                'Selecione o tipo',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              ),
                              selectedValue: _selectedLocationType,
                              onChanged: (value) {
                                setState(() {
                                  _selectedLocationType = value as String?;
                                });
                              },
                            ),
                            const SizedBox(height: 32),

                            // Visibilidade
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        mapVisibility(_visibility),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _visibility == 'public'
                                            ? 'Visível no catálogo online para clientes'
                                            : 'Apenas para agendamentos internos',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  AppToggleSwitch(
                                    isTrue: _visibility == 'public',
                                    function: () {
                                      setState(() {
                                        _visibility = _visibility == 'private'
                                            ? 'public'
                                            : 'private';
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Descrição
                            AppTextformfield(
                              title: 'Descrição',
                              hintText: 'Descreva o serviço oferecido...',
                              controller: _descriptionCtrl,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              isMultiline: true,
                              multilineInitialLines: 3,
                            ),
                            const SizedBox(height: 32),

                            // Colaboradores
                            SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    spacing: 4,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Colaboradores',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
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
                                  Text(
                                    'Quem executa este serviço?',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _TeamMemberList(
                                    members: widget.state.team.teamMembers,
                                    state: widget.state,
                                    selectedMembers: _selectedTeamMembers,
                                    onToggleMember: _toggleTeamMember,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
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
        child: BlocBuilder<CatalogBloc, CatalogState>(
          builder: (context, state) {
            final loading = state is CatalogLoaded ? state.loading : false;
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
                preffixIcon: Icon(
                  widget.service != null ? LucideIcons.check : LucideIcons.plus,
                  color: Colors.white,
                  size: 20,
                ),
                label: widget.service != null ? 'Salvar alterações' : 'Adicionar serviço',
                function: _submitForm,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TeamMemberList extends StatelessWidget {
  final List<TeamMemberModel> members;
  final CatalogLoaded state;
  final Set<String> selectedMembers;
  final void Function(String) onToggleMember;
  const _TeamMemberList({
    required this.members,
    required this.state,
    required this.selectedMembers,
    required this.onToggleMember,
  });

  Color _parseColor(String colorStr) {
    try {
      if (colorStr.startsWith('#')) {
        colorStr = colorStr.substring(1);
      }
      if (colorStr.length == 6) {
        colorStr = 'FF$colorStr';
      }
      return Color(int.parse(colorStr, radix: 16));
    } catch (e) {
      return AppColors.primary;
    }
  }

  String _mapStatus(String status) {
    switch (status) {
      case 'active':
        return 'Ativo';
      case 'inactive':
        return 'Inativo';
      case 'suspended':
        return 'Suspenso';
      case 'on_vacation':
        return 'Em férias';
      default:
        return status;
    }
  }

  String _mapRole(String role) {
    switch (role) {
      case 'owner':
        return 'Proprietário';
      case 'manager':
        return 'Gerente';
      case 'employee':
        return 'Funcionário';
      case 'freelancer':
        return 'Freelancer';
      default:
        return role;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nenhum colaborador encontrado.',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
            AppButton(
              width: 200,
              mainAxisAlignment: MainAxisAlignment.start,
              preffixIcon: Icon(LucideIcons.plus, color: Colors.blue, size: 16),
              labelColor: Colors.blue,
              label: 'Adicionar',
              fillColor: Colors.transparent,
              function: () => context.push(AppRoutes.team),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < members.length; i++) ...[
          _TeamMemberListItem(
            member: members[i],
            parseColor: _parseColor,
            mapStatus: _mapStatus,
            mapRole: _mapRole,
            isSelected: selectedMembers.contains(members[i].id),
            onToggle: () => onToggleMember(members[i].id),
          ),
          if (i < members.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Divider(color: Colors.grey[200], thickness: 1, height: 1),
            ),
        ],
      ],
    );
  }
}

class _TeamMemberListItem extends StatelessWidget {
  final TeamMemberModel member;
  final Color Function(String) parseColor;
  final String Function(String) mapStatus;
  final String Function(String) mapRole;
  final bool isSelected;
  final VoidCallback onToggle;

  const _TeamMemberListItem({
    required this.member,
    required this.parseColor,
    required this.mapStatus,
    required this.mapRole,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = parseColor(member.themeColor);
    final roleLabel = mapRole(member.role);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        _Avatar(
          url: member.profileImageUrl,
          fallback: member.name.isNotEmpty
              ? member.name.characters.first.toUpperCase()
              : '?',
          color: themeColor,
        ),
        Expanded(
          child: Column(
            spacing: 6,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: Text(
                      member.name.isEmpty ? '—' : member.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              _RoleChip(role: roleLabel),
            ],
          ),
        ),
        AppToggleSwitch(isTrue: isSelected, function: onToggle),
      ],
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String role;

  const _RoleChip({required this.role});

  String _mapRole(String role) {
    switch (role) {
      case 'owner':
        return 'Proprietário';
      case 'manager':
        return 'Gerente';
      case 'employee':
        return 'Funcionário';
      case 'freelancer':
        return 'Freelancer';
      default:
        return role;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!, width: 1),
      ),
      child: Text(
        _mapRole(role.toLowerCase()),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Colors.blue[700],
        ),
      ),
    );
  }
}

// ignore: unused_element
class _StatusBadge extends StatelessWidget {
  final String status;
  final String mapped;

  const _StatusBadge({required this.status, required this.mapped});

  Color get statusColor {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.grey;
      case 'suspended':
        return Colors.red;
      case 'on_vacation':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        mapped,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: statusColor.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? url;
  final String fallback;
  final Color color;
  const _Avatar({
    required this.url,
    required this.fallback,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
          shape: BoxShape.circle,
        ),
        child: url != null && url!.isNotEmpty
            ? Image.network(url!, fit: BoxFit.cover)
            : Center(
                child: Text(
                  fallback,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: color.withValues(alpha: 0.9),
                  ),
                ),
              ),
      ),
    );
  }
}

class _ServiceImagePicker extends StatelessWidget {
  final File? image;
  final String? networkImage;
  final bool hideHint;
  final ValueChanged<File> onPicked;
  final VoidCallback onTap;

  const _ServiceImagePicker({
    required this.image,
    required this.networkImage,
    required this.hideHint,
    required this.onPicked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ImageProvider? imageProvider = image != null
        ? FileImage(image!)
        : (networkImage != null && networkImage!.isNotEmpty
              ? NetworkImage(networkImage!)
              : null);

    final showHint = !hideHint && imageProvider == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Foto do serviço',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  image: imageProvider != null
                      ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
                      : null,
                ),
              ),
              if (showHint)
                Positioned.fill(
                  child: AnimatedOpacity(
                    opacity: 1,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.imagePlus,
                              size: 20,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Adicionar uma foto',
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (imageProvider != null)
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              foregroundColor: Colors.blue,
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Alterar imagem',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ),
      ],
    );
  }
}
