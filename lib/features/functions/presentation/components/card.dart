import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/core/data/business.dart';
import 'package:hibeauty/l10n/app_localizations.dart';

// Dev flag: altere para true manualmente para ver opções Pro mesmo em trial.
const bool kDevForceShowTrialOptions = true;

class FunctionsCardOption {
  final IconData icon;
  final String label;
  final String? route;
  final bool disable;
  final bool inDevelopment;
  final VoidCallback? onTap;
  final Color? iconColor;
  final bool isPro;
  final bool? visible;
  const FunctionsCardOption({
    required this.icon,
    required this.label,
    this.route,
    this.disable = false,
    this.inDevelopment = false,
    this.onTap,
    this.iconColor,
    this.isPro = false,
    this.visible = true,
  });
}

class FunctionsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<FunctionsCardOption> options;
  const FunctionsCard({
    super.key,
    required this.icon,
    required this.title,
    this.options = const [],
  });

  @override
  Widget build(BuildContext context) {
    bool trialOn = false;
    final createdAt = BusinessData.createdAt;
    if (createdAt != null) {
      trialOn = DateTime.now().difference(createdAt).inDays < 15;
    }
    final visibleOptions = (trialOn && !kDevForceShowTrialOptions)
        ? options.where((o) => o.isPro == false).toList()
        : options;
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: visibleOptions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2,
      ),
      itemBuilder: (context, index) {
        final o = visibleOptions[index];
        return _OptionCard(option: o);
      },
    );
  }
}

class _OptionCard extends StatelessWidget {
  final FunctionsCardOption option;
  const _OptionCard({required this.option});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final disabled = option.disable;
    return Visibility(
      visible: option.visible ?? true,
      child: Material(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.black.withValues(alpha: 0.08), width: 1),
        ),
        child: InkWell(
          onTap: (option.route == null && option.onTap == null) || option.disable
              ? null
              : () {
                  option.onTap?.call();
                  if (option.route != null) context.push(option.route!);
                },
          splashColor: disabled ? Colors.transparent : null,
          highlightColor: disabled ? Colors.transparent : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Opacity(
                      opacity: disabled ? 0.4 : 1,
                      child: Icon(
                        option.icon,
                        size: 24,
                        color:
                            option.iconColor ??
                            (option.isPro ? Colors.orange : Colors.black54),
                      ),
                    ),
                    if (option.inDevelopment)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: Colors.orange.withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          l10n.inDevelopment,
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    if (option.isPro)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                              (option.iconColor == Colors.green
                                      ? Colors.green
                                      : Colors.orange)
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color:
                                (option.iconColor == Colors.green
                                        ? Colors.green
                                        : Colors.orange)
                                    .withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          option.iconColor == Colors.green ? 'Ativa' : 'Pro',
                          style: TextStyle(
                            color: option.iconColor == Colors.green
                                ? Colors.green
                                : Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                Expanded(
                  child: Opacity(
                    opacity: disabled ? 0.4 : 1,
                    child: Text(
                      option.label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
