import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/bloc/add_schedule_bloc.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/components/team_member_tile.dart';
import 'package:hibeauty/features/team/data/model.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

Future<void> showSelectTeamMemberSheet({
  required BuildContext context,
  required AddScheduleLoaded state,
  TeamMemberModel? member,
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
        value: context.read<AddScheduleBloc>(),
        child: Container(
          color: Colors.white,
          child: AddScheduleTeamMembersList(
            members: state.team,
            state: state,
          ),
        ),
      );
    },
  );
}

class AddScheduleTeamMembersList extends StatefulWidget {
  final List<TeamMemberModel> members;
  final AddScheduleLoaded state;
  const AddScheduleTeamMembersList({
    super.key,
    required this.members,
    required this.state,
  });

  @override
  State<AddScheduleTeamMembersList> createState() =>
      _AddScheduleTeamMembersListState();
}

class _AddScheduleTeamMembersListState extends State<AddScheduleTeamMembersList> {
  final ScrollController _controller = ScrollController();
  late final TextEditingController _searchCtrl;
  bool _showHeaderTitle = false;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
    _controller.addListener(() {
      final shouldShow = _controller.offset > 8;
      if (shouldShow != _showHeaderTitle) {
        setState(() => _showHeaderTitle = shouldShow);
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  List<TeamMemberModel> _filteredMembers() {
    final query = _searchCtrl.text.trim().toLowerCase();
    if (query.isEmpty) {
      return widget.members;
    }
    
    return widget.members.where((member) {
      return member.name.toLowerCase().contains(query) ||
             member.email.toLowerCase().contains(query) ||
             member.phone.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredMembers = _filteredMembers();
    
    if (widget.members.isEmpty) {
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
    
    return GestureDetector(
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
                        'Selecione um colaborador',
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
                    'Selecione um colaborador',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      context.push(AppRoutes.team);
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              spacing: 4,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Não encontrou?'),
                                Text(
                                  'Clique aqui para adicionar um\nnovo colaborador',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(LucideIcons.userRoundPlus300, size: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppTextformfield(
                    controller: _searchCtrl,
                    borderRadius: 12,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 4),
                      child: Icon(
                        LucideIcons.search,
                        size: 18,
                        color: Colors.black54,
                      ),
                    ),
                    hintText: 'Buscar colaboradores',
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 32),
                  if (filteredMembers.isEmpty && _searchCtrl.text.isNotEmpty)
                     Text(
                       'Nenhum resultado encontrado',
                       style: TextStyle(
                         fontSize: 13,
                         fontWeight: FontWeight.w400,
                         color: Colors.black54,
                       ),
                     )
                  else
                    for (int i = 0; i < filteredMembers.length; i++) ...[
                      TeamMemberTile(
                        bcontext: context,
                        member: filteredMembers[i],
                        state: widget.state,
                      ),
                      if (i < filteredMembers.length - 1)
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
