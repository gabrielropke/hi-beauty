import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/bloc/add_schedule_bloc.dart';
import 'package:hibeauty/features/team/data/model.dart';
import 'package:hibeauty/l10n/app_localizations.dart';

class TeamMemberTile extends StatelessWidget {
  final BuildContext bcontext;
  final TeamMemberModel member;
  final AddScheduleLoaded state;
  const TeamMemberTile({super.key, required this.member, required this.state, required this.bcontext});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final themeColor = _parseColor(member.themeColor);
    final statusRaw = member.status; // enum original
    final roleRaw = member.role; // enum original
    final statusLabel = _mapStatus(statusRaw, l10n);
    final roleLabel = _mapRole(roleRaw, l10n);

    return GestureDetector(
      onTap: () {
        bcontext.read<AddScheduleBloc>().add(
          SelectMember(member: member),
        );
        context.pop();
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
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
          ],
        ),
      ),
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