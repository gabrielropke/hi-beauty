import 'package:flutter/material.dart';
import 'package:hibeauty/features/schedules/pages/schedules/presentation/bloc/schedules_bloc.dart';
import 'package:hibeauty/features/schedules/pages/schedules/presentation/components/timeline.dart';
import 'package:hibeauty/theme/app_colors.dart';

class TeamWeekView extends StatelessWidget {
  final SchedulesLoaded state;
  const TeamWeekView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final teamMembers = state.team.teamMembers;

    return Expanded(
      child: Row(
        children: [
          // Coluna da esquerda para membros da equipe
          Container(
            width: 50,
            color: Colors.white,
            child: Column(
              children: [
                // Lista de membros da equipe
                Expanded(
                  child: Column(
                    children: teamMembers.map((member) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Avatar ou inicial
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: parseColor(member.themeColor),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: parseColor(member.themeColor),
                                      spreadRadius: 1.5,
                                      blurRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child:
                                      member.profileImageUrl != null &&
                                          member.profileImageUrl!.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          child: Image.network(
                                            member.profileImageUrl!,
                                            width: 32,
                                            height: 32,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Text(
                                              member.name.isNotEmpty
                                                  ? member.name.characters.first
                                                        .toUpperCase()
                                                  : '?',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Text(
                                          member.name.isNotEmpty
                                              ? member.name.characters.first
                                                    .toUpperCase()
                                              : '?',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Nome do membro
                              Text(
                                member.name.split(' ')[0],
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, color: Colors.grey.shade200),
          // Área principal (timeline)
          Expanded(
            child: Column(
              children: teamMembers.map((member) {
                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade300,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: TimelineCalendar(state: state, teamMemberId: member.id),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
