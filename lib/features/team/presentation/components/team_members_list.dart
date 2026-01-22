import 'package:flutter/material.dart';
import 'package:hibeauty/features/team/data/model.dart';
import 'package:hibeauty/features/team/presentation/bloc/team_bloc.dart';
import 'team_member_tile.dart';

class TeamMembersList extends StatelessWidget {
  final List<TeamMemberModel> members;
  final TeamLoaded state;
  const TeamMembersList({super.key, required this.members, required this.state});

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 8),
        child: Text(
          'Nenhum colaborador encontrado.',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
        ),
      );
    }
    return Column(
      children: [
        for (int i = 0; i < members.length; i++) ...[
          TeamMemberTile(member: members[i], state: state),
          if (i < members.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                height: 20,
                thickness: 1,
                color: Colors.black.withValues(alpha: 0.06),
              ),
            ),
        ],
      ],
    );
  }
}
