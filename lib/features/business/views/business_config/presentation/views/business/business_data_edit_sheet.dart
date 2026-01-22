import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/core/data/business.dart';
import 'package:hibeauty/features/business/data/model.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/bloc/business_config_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

Future<void> showBusinessDataEditSheet({
  required BuildContext context,
  required BusinessConfigLoaded state,
  required AppLocalizations l10n,
  required TextEditingController nameCtrl,
  required TextEditingController instagramCtrl,
  required TextEditingController slugCtrl,
  required TextEditingController descriptionCtrl,
  required List<String> subSegments,
  required bool showAllSubSegments,
  required VoidCallback onToggleShowAll,
  required ValueChanged<String> onRemoveSubSegment,
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
        value: context.read<BusinessConfigBloc>(),
        child: Container(
          color: Colors.white,
          child: _BusinessDataEditSheet(
            state: state,
            l10n: l10n,
            nameCtrl: nameCtrl,
            instagramCtrl: instagramCtrl,
            slugCtrl: slugCtrl,
            descriptionCtrl: descriptionCtrl,
            subSegments: subSegments,
            showAllSubSegments: showAllSubSegments,
            onToggleShowAll: onToggleShowAll,
            onRemoveSubSegment: onRemoveSubSegment,
          ),
        ),
      );
    },
  );
}

class _BusinessDataEditSheet extends StatefulWidget {
  const _BusinessDataEditSheet({
    required this.state,
    required this.l10n,
    required this.nameCtrl,
    required this.instagramCtrl,
    required this.slugCtrl,
    required this.descriptionCtrl,
    required this.subSegments,
    required this.showAllSubSegments,
    required this.onToggleShowAll,
    required this.onRemoveSubSegment,
  });

  final BusinessConfigLoaded state;
  final AppLocalizations l10n;
  final TextEditingController nameCtrl;
  final TextEditingController instagramCtrl;
  final TextEditingController slugCtrl;
  final TextEditingController descriptionCtrl;
  final List<String> subSegments;
  final bool showAllSubSegments;
  final VoidCallback onToggleShowAll;
  final ValueChanged<String> onRemoveSubSegment;

  @override
  State<_BusinessDataEditSheet> createState() => _BusinessDataEditSheetState();
}

class _BusinessDataEditSheetState extends State<_BusinessDataEditSheet> {
  final ScrollController _controller = ScrollController();
  bool _showHeaderTitle = false;
  late List<String> _localSubSegments; // local
  late bool _localShowAll; // local

  /// Função para tratar as labels das especialidades
  String _getSubSegmentLabel(String key) {
    // Primeiro tenta encontrar no state.subsegments pelo id
    final subsegment = widget.state.subsegments.firstWhere(
      (sub) => sub.id == key,
      orElse: () => throw StateError('SubSegment not found'),
    );
    
    try {
      return subsegment.name;
    } catch (e) {
      // Fallback para o mapeamento manual se não encontrar no state
      final Map<String, String> specialtiesLabels = {
        'corte_masculino': 'Corte Masculino',
        'barba_bigode': 'Barba e Bigode',
        'sobrancelha_masculina': 'Sobrancelha Masculina',
        'coloracao_masculina': 'Coloração Masculina',
        'hot_towel': 'Toalha Quente',
        'tratamento_capilar_masculino': 'Tratamento Capilar Masculino',
        'relaxamento_masculino': 'Relaxamento Masculino',
        'produtos_masculinos': 'Produtos Masculinos',
      };
      return specialtiesLabels[key] ?? key.replaceAll('_', ' ').split(' ').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
    }
  }

  /// Obtém todas as especialidades disponíveis do state
  List<String> get _allAvailableSubSegments => widget.state.subsegments.map((sub) => sub.id).toList();

  @override
  void initState() {
    super.initState();
    // Inicializar com as especialidades atualmente selecionadas do BusinessData
    _localSubSegments = List<String>.from(BusinessData.subSegments);
    _localShowAll = widget.showAllSubSegments;
    _controller.addListener(() {
      final shouldShow = _controller.offset > 8;
      if (shouldShow != _showHeaderTitle) {
        setState(() => _showHeaderTitle = shouldShow);
      }
    });
  }

  void _removeLocal(String value) {
    setState(() {
      _localSubSegments.remove(value);
      if (_localSubSegments.length <= 2) _localShowAll = true;
    });
    widget.onRemoveSubSegment(value); // propaga para o pai
  }

  void _addLocal(String value) {
    setState(() {
      if (!_localSubSegments.contains(value)) {
        _localSubSegments.add(value);
      }
    });
  }

  void _toggleShowAll() {
    setState(() => _localShowAll = !_localShowAll);
    widget.onToggleShowAll();
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
                            l10n.editBusiness,
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
                child: Divider(thickness: 1, color: Colors.grey[300], height: 5),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _controller,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.editBusiness,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 22),
                      Text(
                        l10n.businessData,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        l10n.editBusinessDescription,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 32),
                      AppTextformfield(
                        isrequired: true,
                        title: l10n.yourBusinessName,
                        hintText: l10n.yourBusinessNameHint,
                        controller: widget.nameCtrl,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                        ),
                        child: Text('O seu pais está definido como ${BusinessData.country} com ${BusinessData.currency} como moeda.'),
                      ),
                      Divider(thickness: 1, color: Colors.grey[300], height: 60),
                      _InstagramField(
                        l10n: l10n,
                        controller: widget.instagramCtrl,
                      ),
                      SizedBox(height: 32),
                      _SlugField(l10n: l10n, controller: widget.slugCtrl),
                      SizedBox(height: 32),
                      AppTextformfield(
                        isrequired: true,
                        title: l10n.descriptionBusiness,
                        hintText: '',
                        controller: widget.descriptionCtrl,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        isMultiline: true,
                        multilineInitialLines: 3,
                      ),
                      SizedBox(height: 32),
                      _SubSegmentsBox(
                        l10n: l10n,
                        allAvailableSubSegments: _allAvailableSubSegments,
                        selectedSubSegments: _localSubSegments,
                        showAll: _localShowAll,
                        onToggleShowAll: _toggleShowAll,
                        onRemove: _removeLocal,
                        onAdd: _addLocal,
                        getLabel: _getSubSegmentLabel,
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
        child: BlocBuilder<BusinessConfigBloc, BusinessConfigState>(
          builder: (context, state) {
            final loading = state is BusinessConfigLoaded ? state.loading : false;
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black.withValues(alpha: 0.1), width: 1),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: AppButton(
                label: l10n.save,
                loading: loading,
                function: () => context.read<BusinessConfigBloc>().add(
                      UpdateSetupBasic(
                        SetupBasicModel(
                          name: widget.nameCtrl.text.trim(),
                          instagram: widget.instagramCtrl.text.trim(),
                          slug: widget.slugCtrl.text.trim(),
                          description: widget.descriptionCtrl.text.trim(),
                          whatsapp: BusinessData.whatsapp ?? '',
                          segment: BusinessData.segment ?? '',
                          subSegments: _localSubSegments,
                          mainObjective: BusinessData.mainObjective ?? '',
                          teamSize: BusinessData.teamSize ?? '',
                        ),
                      ),
                    ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InstagramField extends StatelessWidget {
  final AppLocalizations l10n;
  final TextEditingController controller;
  const _InstagramField({required this.l10n, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 6,
          children: [
            Text(
              l10n.instagram,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const Text('*', style: TextStyle(fontSize: 10, color: Colors.red)),
          ],
        ),
        Row(
          children: [
            Container(
              height: 48,
              width: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.02),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
              ),
              child: Icon(
                LucideIcons.atSign,
                size: 18,
                color: Colors.black.withValues(alpha: 0.6),
              ),
            ),
            Expanded(
              child: AppTextformfield(
                controller: controller,
                hintText: l10n.instagramHint,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                borderRadiusCustomized: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SlugField extends StatelessWidget {
  final AppLocalizations l10n;
  final TextEditingController controller;
  const _SlugField({required this.l10n, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
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
            const Text('*', style: TextStyle(fontSize: 10, color: Colors.red)),
          ],
        ),
        Row(
          children: [
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.02),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
              ),
              child: Text(
                'hibeauty.co/',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withValues(alpha: 0.6),
                ),
              ),
            ),
            Expanded(
              child: AppTextformfield(
                controller: controller,
                hintText: l10n.slugHint,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                textInputFormatter: FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z0-9]'),
                ),
                borderRadiusCustomized: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
            ),
          ],
        ),
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

class _SubSegmentsBox extends StatelessWidget {
  final AppLocalizations l10n;
  final List<String> allAvailableSubSegments;
  final List<String> selectedSubSegments;
  final bool showAll;
  final VoidCallback onToggleShowAll;
  final ValueChanged<String> onRemove;
  final ValueChanged<String> onAdd;
  final String Function(String) getLabel;
  
  const _SubSegmentsBox({
    required this.l10n,
    required this.allAvailableSubSegments,
    required this.selectedSubSegments,
    required this.showAll,
    required this.onToggleShowAll,
    required this.onRemove,
    required this.onAdd,
    required this.getLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Row(
            children: [
              Text(
                l10n.subSegments,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              if (allAvailableSubSegments.length > 4)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    showAll ? Icons.expand_less : Icons.expand_more,
                    size: 18,
                  ),
                  onPressed: onToggleShowAll,
                ),
            ],
          ),
          if (allAvailableSubSegments.isEmpty)
            const Text(
              'Nenhuma especialidade disponível.',
              style: TextStyle(color: Colors.black45, fontSize: 12),
            )
            else
            Wrap(
              spacing: 8,
              runSpacing: 12,
              children: (showAll ? allAvailableSubSegments : allAvailableSubSegments.take(4)).map((specialty) {
              final isSelected = selectedSubSegments.contains(specialty);
              final label = getLabel(specialty);

              return GestureDetector(
                onTap: () {
                if (isSelected) {
                  onRemove(specialty);
                } else {
                  onAdd(specialty);
                }
                },
                child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blueGrey : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                  color: isSelected
                    ? Colors.transparent
                    : Colors.black.withValues(alpha: 0.1),
                  width: 0.6,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  Text(
                    label,
                    style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  if (!isSelected) ...[
                    const SizedBox(width: 4),
                    const Icon(
                    Icons.add,
                    size: 14,
                    color: Colors.black54,
                    ),
                  ],
                  if (isSelected) ...[
                    const SizedBox(width: 4),
                    const Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.white,
                    ),
                  ],
                  ],
                ),
                ),
              );
              }).toList(),
            ),
          if (selectedSubSegments.isNotEmpty && !showAll && allAvailableSubSegments.length > 4) 
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '${selectedSubSegments.length} especialidade(s) selecionada(s)',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
