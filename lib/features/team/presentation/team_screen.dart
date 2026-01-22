import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/core/components/custom_app_bar.dart';
import 'package:hibeauty/features/team/presentation/bloc/team_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:hibeauty/features/team/data/model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'components/team_members_list.dart';
import 'components/filters_drawer.dart';
import 'add_team.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeamBloc(context)..add(TeamLoadRequested()),
      child: const TeamView(),
    );
  }
}

class TeamView extends StatefulWidget {
  const TeamView({super.key});
  @override
  State<TeamView> createState() => _TeamViewState();
}

class _TeamViewState extends State<TeamView> {
  final ScrollController _scrollController = ScrollController();
  late final TextEditingController _searchCtrl;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _sortOrder = 'name_asc'; // alterar padrão para incluir tipo
  final Set<String> _selectedStatuses = {};
  final Set<String> _selectedRoles = {};

  static const statusOptions = [
    'active',
    'inactive',
    'suspended',
    'on_vacation',
  ];
  static const roleOptions = ['owner', 'manager', 'employee', 'freelancer'];

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

  List<TeamMemberModel> _filtered(TeamLoaded state) {
    final q = _searchCtrl.text.trim().toLowerCase();
    var list = state.team.teamMembers.where((m) {
      final matchesQuery =
          q.isEmpty ||
          m.name.toLowerCase().contains(q) ||
          m.email.toLowerCase().contains(q) ||
          m.phone.toLowerCase().contains(q);
      final matchesStatus =
          _selectedStatuses.isEmpty ||
          _selectedStatuses.contains(m.status.toLowerCase());
      final matchesRole =
          _selectedRoles.isEmpty ||
          _selectedRoles.contains(m.role.toLowerCase());
      return matchesQuery && matchesStatus && matchesRole;
    }).toList();

    // ordenação expandida
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
      case 'email_asc':
        list.sort(
          (a, b) => a.email.toLowerCase().compareTo(b.email.toLowerCase()),
        );
        break;
      case 'email_desc':
        list.sort(
          (a, b) => b.email.toLowerCase().compareTo(a.email.toLowerCase()),
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

  void _toggleStatus(String value) {
    setState(() {
      if (_selectedStatuses.contains(value)) {
        _selectedStatuses.remove(value);
      } else {
        _selectedStatuses.add(value);
      }
    });
  }

  void _toggleRole(String value) {
    setState(() {
      if (_selectedRoles.contains(value)) {
        _selectedRoles.remove(value);
      } else {
        _selectedRoles.add(value);
      }
    });
  }

  void _clearFilters() {
    setState(() {
      _sortOrder = 'name_asc'; // resetar para padrão
      _selectedStatuses.clear();
      _selectedRoles.clear();
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
        onChangeSort: (v) => setState(() => _sortOrder = v),
        selectedStatuses: _selectedStatuses,
        selectedRoles: _selectedRoles,
        onToggleStatus: _toggleStatus,
        onToggleRole: _toggleRole,
        onClear: _clearFilters,
        statusOptions: statusOptions,
        roleOptions: roleOptions,
      ),
      body: BlocBuilder<TeamBloc, TeamState>(
        builder: (context, state) => switch (state) {
          TeamLoading _ => const AppLoader(),
          TeamLoaded s => _loaded(s, l10n, context), // passar context
          TeamState() => const AppLoader(),
        },
      ),
    );
  }

  Widget _loaded(
    TeamLoaded state,
    AppLocalizations l10n,
    BuildContext context,
  ) {
    final members = _filtered(state);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          CustomAppBar(
            title: l10n.teamMembers,
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
                function: () => showAddTeamMemberSheet(
                  context: context,
                  state: state,
                  l10n: AppLocalizations.of(context)!,
                ),
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
                    l10n.teamMembers,
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
                          hintText: l10n.searchTeams,
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
                  TeamMembersList(members: members, state: state),
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
