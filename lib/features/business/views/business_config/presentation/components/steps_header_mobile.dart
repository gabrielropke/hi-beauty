import 'package:flutter/material.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/components/step_data.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/components/step_chip.dart';

class StepsHeaderMobile extends StatelessWidget {
  final List<StepData> steps;
  final int currentStep;
  final ValueChanged<int> onSelect;
  final Color activeColor;
  final bool vertical;
  const StepsHeaderMobile({
    super.key,
    required this.steps,
    required this.currentStep,
    required this.onSelect,
    required this.activeColor,
    this.vertical = false,
  });

  @override
  Widget build(BuildContext context) {
    if (vertical) {
      return Column(
        children: [
          for (int i = 0; i < steps.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == steps.length - 1 ? 0 : 16),
              child: StepChip(
                data: steps[i],
                selected: i == currentStep,
                onTap: () => onSelect(i),
                activeColor: activeColor,
              ),
            ),
        ],
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          spacing: 8,
          children: [
            for (int i = 0; i < steps.length; i++)
              StepChip(
                data: steps[i],
                selected: i == currentStep,
                onTap: () => onSelect(i),
                activeColor: activeColor,
              ),
          ],
        ),
      ),
    );
  }
}
