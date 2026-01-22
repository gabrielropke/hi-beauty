import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/services/business_options/data/model.dart';
import 'package:hibeauty/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MainObjectiveBusinessData extends StatelessWidget {
  final OnboardingLoaded state;
  const MainObjectiveBusinessData({super.key, required this.state});

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
            SizedBox(height: 20),
            Text(
              l10n.configAccount,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.black.withValues(alpha: 0.8),
              ),
            ),
            SizedBox(height: 20),
            Row(
              spacing: 10,
              children: [
                Icon(LucideIcons.target),
                Text(
                  'Principal Objetivo',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            _MainObjectiveWrap(mainObjectives: state.mainObjectives),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _MainObjectiveWrap extends StatelessWidget {
  final List<MainObjectiveModel> mainObjectives;
  const _MainObjectiveWrap({required this.mainObjectives});

  @override
  Widget build(BuildContext context) {
    if (mainObjectives.isEmpty) {
      return const SizedBox.shrink();
    }
    const horizontalSpacing = 12.0;
    const verticalSpacing = 12.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final itemWidth = (maxWidth - (horizontalSpacing * 1)) / 1;
        return Wrap(
          spacing: horizontalSpacing,
          runSpacing: verticalSpacing,
          children: mainObjectives.map((s) {
            final selectedKey =
                (context.read<OnboardingBloc>().state as OnboardingLoaded)
                    .selectedMainObjectiveKey;
            final isSelected = selectedKey == s.key;
            return SizedBox(
              width: itemWidth,
              child: _Item(
                label: s.label,
                keyValue: s.key,
                isSelected: isSelected,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _Item extends StatelessWidget {
  final String label;
  final String keyValue;
  final bool isSelected;
  const _Item({
    required this.label,
    required this.keyValue,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () =>
          context.read<OnboardingBloc>().add(SelectMainObjective(keyValue)),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? AppColors.secondary.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.08),
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
          color: isSelected
              ? AppColors.secondary.withValues(alpha: 0.03)
              : Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: Colors.black.withValues(alpha: 0.8),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
