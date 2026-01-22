import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SubSegmentsBusinessData extends StatelessWidget {
  final OnboardingLoaded state;
  const SubSegmentsBusinessData({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              l10n.configAccount,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.black.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              spacing: 10,
              children: [
                const Icon(LucideIcons.sparkles),
                Text(
                  l10n.subSegments,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.subSegmentBusiness,
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
            const SizedBox(height: 32),

            _SubSegmentsWrap(
              subSegments: state.subsegments,
              selectedSubSegmentKeys: state.selectedSubSegmentKey,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SubSegmentsWrap extends StatelessWidget {
  final List<dynamic> subSegments;
  final List<String>? selectedSubSegmentKeys;

  const _SubSegmentsWrap({
    required this.subSegments,
    required this.selectedSubSegmentKeys,
  });

  @override
  Widget build(BuildContext context) {
    const hSpacing = 12.0;
    const vSpacing = 12.0;

    return LayoutBuilder(
      builder: (context, constraints) {

        // Organizar itens em pares para cada linha
        final List<Widget> rows = [];
        for (int i = 0; i < subSegments.length; i += 2) {
          final List<Widget> rowItems = [];
          
          // Primeiro item da linha
          final firstItem = subSegments[i];
          final firstId = _field(firstItem, 'id');
          final firstName = _field(firstItem, 'name');
          final firstDescription = _field(firstItem, 'description');
          final firstIsSelected = selectedSubSegmentKeys?.contains(firstId) ?? false;
          
          rowItems.add(
            Expanded(
              child: _SubSegmentItem(
                id: firstId,
                name: firstName,
                description: firstDescription,
                isSelected: firstIsSelected,
              ),
            ),
          );
          
          // Segundo item da linha (se existir)
          if (i + 1 < subSegments.length) {
            rowItems.add(const SizedBox(width: hSpacing));
            
            final secondItem = subSegments[i + 1];
            final secondId = _field(secondItem, 'id');
            final secondName = _field(secondItem, 'name');
            final secondDescription = _field(secondItem, 'description');
            final secondIsSelected = selectedSubSegmentKeys?.contains(secondId) ?? false;
            
            rowItems.add(
              Expanded(
                child: _SubSegmentItem(
                  id: secondId,
                  name: secondName,
                  description: secondDescription,
                  isSelected: secondIsSelected,
                ),
              ),
            );
          } else {
            // Se só há um item na linha, adiciona espaço vazio
            rowItems.add(const SizedBox(width: hSpacing));
            rowItems.add(const Expanded(child: SizedBox()));
          }
          
          rows.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: rowItems,
              ),
            ),
          );
          
          // Adicionar espaçamento vertical entre linhas (exceto na última)
          if (i + 2 < subSegments.length) {
            rows.add(const SizedBox(height: vSpacing));
          }
        }

        return Column(
          children: rows,
        );
      },
    );
  }

  String _field(dynamic obj, String name) {
    try {
      if (obj is Map) return obj[name]?.toString() ?? '';
      final v = obj as dynamic;
      switch (name) {
        case 'id':
          return v.id?.toString() ?? '';
        case 'name':
          return v.name?.toString() ?? '';
        case 'description':
          return v.description?.toString() ?? '';
        default:
          return '';
      }
    } catch (_) {
      return '';
    }
  }
}

class _SubSegmentItem extends StatelessWidget {
  final String id;
  final String name;
  final String description;
  final bool isSelected;

  const _SubSegmentItem({
    required this.id,
    required this.name,
    required this.description,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.secondary;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.read<OnboardingBloc>().add(SelectSubSegment(id)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? color.withValues(alpha: 0.4)
                : Colors.black.withValues(alpha: 0.08),
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? color.withValues(alpha: 0.06) : Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: Colors.black.withValues(alpha: 0.9),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                description,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 11,
                  height: 1.3,
                  color: Colors.black.withValues(alpha: 0.6),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}