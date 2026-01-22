import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/core/components/custom_app_bar.dart';
import 'package:hibeauty/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:hibeauty/features/catalog/data/model.dart';
import 'package:hibeauty/features/catalog/presentation/combos/add_combo.dart';
import 'package:hibeauty/features/catalog/presentation/components/combos_list.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../components/filters_drawer.dart';

class CombosScreen extends StatelessWidget {
  const CombosScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CatalogBloc(context)..add(CatalogLoadRequested()),
      child: const CombosView(),
    );
  }
}

class CombosView extends StatefulWidget {
  const CombosView({super.key});
  @override
  State<CombosView> createState() => _CombosViewState();
}

class _CombosViewState extends State<CombosView> {
  final ScrollController _scrollController = ScrollController();
  late final TextEditingController _searchCtrl;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _sortOrder = 'name_asc';
  final Set<bool> _selectedActiveStatus = {};
  final Set<String> _selectedVisibility = {};
  final Set<String> _selectedLocationType = {};

  static const List<bool> activeStatusOptions = [true, false];
  static const List<String> visibilityOptions = ['PUBLIC', 'PRIVATE'];
  static const List<String> locationTypeOptions = [
    'IN_PERSON',
    'REMOTE',
    'HYBRID',
  ];

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<CombosModel> _filtered(CatalogLoaded state) {
    final q = _searchCtrl.text.trim().toLowerCase();
    var list = state.combos.where((s) {
      final matchesQuery =
          q.isEmpty ||
          s.name.toLowerCase().contains(q) ||
          (s.description != null && s.description!.toLowerCase().contains(q));
      final matchesActiveStatus =
          _selectedActiveStatus.isEmpty ||
          _selectedActiveStatus.contains(s.isActive);
      final matchesVisibility =
          _selectedVisibility.isEmpty ||
          _selectedVisibility.contains(s.visibility);
      final matchesLocationType = _selectedLocationType.isEmpty;
      return matchesQuery &&
          matchesActiveStatus &&
          matchesVisibility &&
          matchesLocationType;
    }).toList();

    // ordenação
    switch (_sortOrder) {
      case 'name_asc':
        list.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;
      case 'name_desc':
        list.sort(
          (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
        );
        break;
      case 'date_newest':
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'date_oldest':
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }
    return list;
  }

  void _toggleActiveStatus(bool value) {
    setState(() {
      if (_selectedActiveStatus.contains(value)) {
        _selectedActiveStatus.remove(value);
      } else {
        _selectedActiveStatus.add(value);
      }
    });
  }

  void _toggleVisibility(String value) {
    setState(() {
      if (_selectedVisibility.contains(value)) {
        _selectedVisibility.remove(value);
      } else {
        _selectedVisibility.add(value);
      }
    });
  }

  void _toggleLocationType(String value) {
    setState(() {
      if (_selectedLocationType.contains(value)) {
        _selectedLocationType.remove(value);
      } else {
        _selectedLocationType.add(value);
      }
    });
  }

  void _clearFilters() {
    setState(() {
      _sortOrder = 'name_asc';
      _selectedActiveStatus.clear();
      _selectedVisibility.clear();
      _selectedLocationType.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      endDrawer: FiltersDrawer(
        sortOrder: _sortOrder,
        type: CategoryType.product,
        onChangeSort: (v) => setState(() => _sortOrder = v),
        selectedActiveStatus: _selectedActiveStatus,
        onToggleActiveStatus: _toggleActiveStatus,
        selectedVisibility: _selectedVisibility,
        onToggleVisibility: _toggleVisibility,
        selectedLocationType: _selectedLocationType,
        onToggleLocationType: _toggleLocationType,
        onClear: _clearFilters,
        activeStatusOptions: activeStatusOptions,
        visibilityOptions: visibilityOptions,
        locationTypeOptions: locationTypeOptions,
      ),
      body: BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, state) => switch (state) {
          CatalogLoading _ => const AppLoader(),
          CatalogLoaded s => _loaded(s, l10n, context), // passar context
          CatalogState() => const AppLoader(),
        },
      ),
    );
  }

  Widget _loaded(
    CatalogLoaded state,
    AppLocalizations l10n,
    BuildContext context,
  ) {
    final combos = _filtered(state);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          CustomAppBar(
            title: 'Combos',
            controller: _scrollController,
            backgroundColor: Colors.white,
            actions: [
              AppButton(
                width: 120,
                height: 30,
                label: l10n.add,
                fillColor: Colors.white,
                labelStyle: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
                borderColor: Colors.black12,
                suffixIcon: Icon(LucideIcons.plus300, size: 16),
                function: () {
                  showAddCombo(
                    context: context,
                    state: state,
                    l10n: AppLocalizations.of(context)!,
                  );
                },
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Text(
                    'Combos',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: AppTextformfield(
                          controller: _searchCtrl,
                          borderRadius: 32,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 4),
                            child: Icon(
                              LucideIcons.search,
                              size: 18,
                              color: Colors.black54,
                            ),
                          ),
                          hintText: 'Buscar combos',
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.black12, width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(11.5),
                            child: Icon(
                              LucideIcons.gitPullRequestDraft300,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  CombosList(combos: combos, state: state),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
