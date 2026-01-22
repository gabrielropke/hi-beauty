import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/features/team/presentation/bloc/team_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'sort_option_tile.dart';

class FiltersDrawer extends StatefulWidget {
  final String sortOrder;
  final ValueChanged<String> onChangeSort;
  final Set<String> selectedStatuses;
  final Set<String> selectedRoles;
  final void Function(String) onToggleStatus;
  final void Function(String) onToggleRole;
  final VoidCallback onClear;
  final List<String> statusOptions;
  final List<String> roleOptions;
  const FiltersDrawer({
    super.key,
    required this.sortOrder,
    required this.onChangeSort,
    required this.selectedStatuses,
    required this.selectedRoles,
    required this.onToggleStatus,
    required this.onToggleRole,
    required this.onClear,
    required this.statusOptions,
    required this.roleOptions,
  });

  @override
  State<FiltersDrawer> createState() => _FiltersDrawerState();
}

class _FiltersDrawerState extends State<FiltersDrawer> {
  bool _sortExpanded = true;
  bool _statusExpanded = true;
  bool _roleExpanded = true;

  final ScrollController _controller = ScrollController();
  bool _showHeaderTitle = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final shouldShow = _controller.offset > 8;
      if (shouldShow != _showHeaderTitle) {
        setState(() => _showHeaderTitle = shouldShow);
      }
    });
  }

  String _mapStatus(String value, AppLocalizations l10n) {
    switch (value.toLowerCase()) {
      case 'active':
        return l10n.active;
      case 'inactive':
        return l10n.inactive;
      case 'suspended':
        return l10n.suspended;
      case 'on_vacation':
        return l10n.onVacation;
      default:
        return '—';
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Drawer(
      elevation: 0,
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                                l10n.filters,
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
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(LucideIcons.x300),
                            splashRadius: 20,
                          ),
                        ),
                      ],
                    ),

                    Expanded(
                      child: ListView(
                        controller: _controller,
                        children: [
                          Text(
                            l10n.filters,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 30),
                          _SectionHeader(
                            icon: LucideIcons.listEnd400,
                            label: l10n.sortBy,
                            expanded: _sortExpanded,
                            onTap: () =>
                                setState(() => _sortExpanded = !_sortExpanded),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            child: !_sortExpanded
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: EdgeInsets.only(
                                      top: !_sortExpanded ? 0 : 12,
                                    ),
                                    child: Column(
                                      key: const ValueKey('sort-open'),
                                      children: [
                                        SortOptionTile(
                                          label: 'Nome (A-Z)',
                                          selected: widget.sortOrder == 'name_asc',
                                          onTap: () => widget.onChangeSort('name_asc'),
                                        ),
                                        SortOptionTile(
                                          label: 'Nome (Z-A)',
                                          selected: widget.sortOrder == 'name_desc',
                                          onTap: () => widget.onChangeSort('name_desc'),
                                        ),
                                        SortOptionTile(
                                          label: 'Email (A-Z)',
                                          selected: widget.sortOrder == 'email_asc',
                                          onTap: () => widget.onChangeSort('email_asc'),
                                        ),
                                        SortOptionTile(
                                          label: 'Email (Z-A)',
                                          selected: widget.sortOrder == 'email_desc',
                                          onTap: () => widget.onChangeSort('email_desc'),
                                        ),
                                        SortOptionTile(
                                          label: 'Data de início (da mais antiga)',
                                          selected: widget.sortOrder == 'date_oldest',
                                          onTap: () => widget.onChangeSort('date_oldest'),
                                        ),
                                        SortOptionTile(
                                          label: 'Data de início (da mais recente)',
                                          selected: widget.sortOrder == 'date_newest',
                                          onTap: () => widget.onChangeSort('date_newest'),
                                        ),
                                        
                                      ],
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 24),
                          _SectionHeader(
                            icon: LucideIcons.shieldCheck,
                            label: l10n.status,
                            expanded: _statusExpanded,
                            selectedCount: widget.selectedStatuses.length,
                            onTap: () => setState(() => _statusExpanded = !_statusExpanded),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            child: !_statusExpanded
                                ? const SizedBox.shrink()
                                : Column(
                                    key: const ValueKey('status-open'),
                                    children: widget.statusOptions.map((s) {
                                      final selected = widget.selectedStatuses.contains(s);
                                      return _FilterListTile(
                                        label: _mapStatus(s, l10n),
                                        selected: selected,
                                        onTap: () => widget.onToggleStatus(s),
                                      );
                                    }).toList(),
                                  ),
                          ),
                          const SizedBox(height: 24),
                          _SectionHeader(
                            icon: LucideIcons.users,
                            label: 'Cargo',
                            expanded: _roleExpanded,
                            selectedCount: widget.selectedRoles.length,
                            onTap: () => setState(() => _roleExpanded = !_roleExpanded),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            child: !_roleExpanded
                                ? const SizedBox.shrink()
                                : Column(
                                    key: const ValueKey('role-open'),
                                    children: widget.roleOptions.map((r) {
                                      final selected = widget.selectedRoles.contains(r);
                                      return _FilterListTile(
                                        label: _mapRole(r, l10n),
                                        selected: selected,
                                        onTap: () => widget.onToggleRole(r),
                                      );
                                    }).toList(),
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
            BlocBuilder<TeamBloc, TeamState>(
              builder: (context, state) {
                final loading = state is TeamLoaded ? state.loading : false;
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
                  child: Row(
                    spacing: 12,
                    children: [
                      Expanded(
                        flex: 1,
                        child: AppButton(
                          label: l10n.clear,
                          loading: loading,
                          fillColor: Colors.white,
                          labelColor: Colors.black87,
                          borderColor: Colors.black12,
                          function: () {
                            widget.onClear();
                          },
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: AppButton(
                          label: l10n.apply,
                          loading: loading,
                          function: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool expanded;
  final VoidCallback onTap;
  final int? selectedCount;
  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.expanded,
    required this.onTap,
    this.selectedCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Row(
                spacing: 8,
                children: [
                  Icon(icon, size: 18),
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  if (selectedCount != null && selectedCount! > 0)
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '$selectedCount',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            AnimatedRotation(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeInOutBack,
              turns: expanded ? 0.0 : 0.25,
              child: const Icon(Icons.expand_more, size: 18, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

// SUBSTITUIR FilterChipCustom por _FilterListTile
class _FilterListTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterListTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(
              selected ? Icons.check_box : LucideIcons.square200,
              // size: 18,
              color: selected ? Colors.blueAccent : Colors.black45,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
