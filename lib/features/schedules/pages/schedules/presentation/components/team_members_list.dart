import 'package:flutter/material.dart';
import 'package:hibeauty/features/team/data/model.dart';

class TimelineMembers extends StatelessWidget {
  final List<TeamMemberModel> members;
  const TimelineMembers({super.key, required this.members});

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (int i = 0; i < members.length; i++) ...[
          _Member(
            url: members[i].profileImageUrl,
            fallback: members[i].name.isNotEmpty
                ? members[i].name.characters.first.toUpperCase()
                : '?',
            color: _parseColor(members[i].themeColor),
            name: members[i].name,
          ),
        ],
      ],
    );
  }
}

class _Member extends StatelessWidget {
  final String? url;
  final String fallback;
  final Color color;
  final String name;
  const _Member({
    required this.url,
    required this.fallback,
    required this.color,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Top avatar: only color, no image or fallback
                _AvatarCircle(
                  size: 40,
                  color: color.withValues(alpha: 0.15),
                  borderColor: color.withValues(alpha: 0.35),
                  borderWidth: 1,
                  url: null,
                  fallback: '',
                  textColor: Colors.transparent,
                ),
                // Main avatar: image or fallback
                _AvatarCircle(
                  size: 35,
                  color: color.withValues(alpha: 0.15),
                  borderColor: Colors.white,
                  borderWidth: 1,
                  url: url,
                  fallback: fallback,
                  textColor: color.withValues(alpha: 0.9),
                ),
              ],
            ),
          ),
        ),
        Text(
          name.split(' ')[0],
          style: TextStyle(
            fontSize: 11,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final double size;
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final String? url;
  final String fallback;
  final Color textColor;

  const _AvatarCircle({
    required this.size,
    required this.color,
    required this.borderColor,
    required this.borderWidth,
    required this.url,
    required this.fallback,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: borderColor, width: borderWidth),
        shape: BoxShape.circle,
      ),
      child: url != null && url!.isNotEmpty
          ? ClipOval(
              child: Image.network(url!, fit: BoxFit.cover, width: size, height: size),
            )
          : Center(
              child: Text(
                fallback,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
    );
  }
}

Color _parseColor(String hex) {
  if (hex.isEmpty) return Colors.blueGrey;
  final cleaned = hex.replaceFirst('#', '');
  final full = cleaned.length == 6 ? 'FF$cleaned' : cleaned;
  return Color(int.tryParse('0x$full') ?? 0xFF607D8B);
}
