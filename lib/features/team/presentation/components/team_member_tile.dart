import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/features/team/data/model.dart';
import 'package:hibeauty/features/team/presentation/add_team.dart';
import 'package:hibeauty/features/team/presentation/bloc/team_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TeamMemberTile extends StatelessWidget {
  final TeamMemberModel member;
  final TeamLoaded state;
  const TeamMemberTile({super.key, required this.member, required this.state});

  void _showMemberOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            // reduz padding geral
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // botão fechar com menos padding
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () => context.pop(),
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: const Icon(LucideIcons.x200),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // opção Editar sem efeito de toque
                _OptionItem(
                  label: 'Editar',
                  onTap: () {
                    context.pop();

                    // Criar controllers com dados existentes
                    final nameCtrl = TextEditingController(text: member.name);
                    final emailCtrl = TextEditingController(text: member.email);
                    final phoneCtrl = TextEditingController(text: member.phone);

                    // Converter workingHours do modelo para formato Map
                    final workingHoursData = member.workingHours
                        .map(
                          (wh) => {
                            "day": wh.day,
                            "startAt": wh.startAt,
                            "endAt": wh.endAt,
                            "isWorking": wh.isWorking,
                          },
                        )
                        .toList();

                    showAddTeamMemberSheet(
                      context: context,
                      state: state,
                      l10n: AppLocalizations.of(context)!,
                      id: member.id,
                      nameCtrl: nameCtrl,
                      emailCtrl: emailCtrl,
                      phoneCtrl: phoneCtrl,
                      role: member.role,
                      status: member.status,
                      themeColor: member.themeColor,
                      profileImageUrl: member.profileImageUrl,
                      workingHours:
                          workingHoursData, // passar horários existentes
                      commissionConfig: member
                          .commissionConfig, // passar configuração de comissão
                    );
                  },
                ),
                const SizedBox(height: 4),
                // opção Deletar sem efeito de toque
                _OptionItem(
                  label: 'Deletar',
                  destructive: true,
                  onTap: () => _showDeleteConfirmation(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: Text(
            'Tem certeza que deseja excluir ${member.name}? Esta ação não pode ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // fechar modal de opções
                context.read<TeamBloc>().add(DeleteTeamMember(member.id));
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final themeColor = _parseColor(member.themeColor);
    final statusRaw = member.status; // enum original
    final roleRaw = member.role; // enum original
    final statusLabel = _mapStatus(statusRaw, l10n);
    final roleLabel = _mapRole(roleRaw, l10n);

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
              Row(
                spacing: 12,
                children: [
                  _RoleChip(role: roleLabel),
                  _StatusBadge(status: statusRaw, mapped: statusLabel),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => _showMemberOptions(context),
          icon: const Icon(LucideIcons.ellipsisVertical300, size: 20),
        ),
      ],
    );
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

  Color _parseColor(String hex) {
    if (hex.isEmpty) return Colors.blueGrey;
    final cleaned = hex.replaceFirst('#', '');
    final full = cleaned.length == 6 ? 'FF$cleaned' : cleaned;
    return Color(int.tryParse('0x$full') ?? 0xFF607D8B);
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

class _StatusBadge extends StatelessWidget {
  final String status; // raw enum
  final String mapped; // label traduzido
  const _StatusBadge({required this.status, required this.mapped});

  @override
  Widget build(BuildContext context) {
    final active = status.toLowerCase() == 'active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: active
            ? Colors.green.withValues(alpha: 0.12)
            : Colors.red.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: active
              ? Colors.green.withValues(alpha: 0.5)
              : Colors.red.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Text(
        mapped,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: active ? Colors.green[700] : Colors.red[700],
        ),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String role; // já mapeado
  const _RoleChip({required this.role});

  @override
  Widget build(BuildContext context) {
    final normalized = role.isEmpty ? '—' : role;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withValues(alpha: 0.12)),
      ),
      child: Text(
        normalized,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool destructive;
  const _OptionItem({
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = Colors.black;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 40,
        width: double.infinity,
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
