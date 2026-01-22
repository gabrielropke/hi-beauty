import 'package:flutter/material.dart';
import 'package:hibeauty/theme/app_colors.dart';

class TabsNotifications extends StatefulWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const TabsNotifications({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  State<TabsNotifications> createState() => _TabsNotificationsState();
}

class _TabsNotificationsState extends State<TabsNotifications> {
  final List<Map<String, String>> tabs = [
    {'key': 'all', 'label': 'Tudo'},
    {'key': 'booking', 'label': 'Agendamentos'},
    {'key': 'notice', 'label': 'Informativos'},
    {'key': 'payment', 'label': 'Pagamentos'},
    {'key': 'system', 'label': 'Sistema'},
    {'key': 'commission_calculated', 'label': 'Comissões'},
    {'key': 'commission_paid', 'label': 'Pagos'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        children: [
          // Linha base que cruza toda a largura
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 1,
              color: Colors.grey.withValues(alpha: 0.3),
            ),
          ),
          // Tabs
          ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: tabs.length,
            itemBuilder: (context, index) {
              final tab = tabs[index];
              final isSelected = widget.selectedFilter == tab['key'];

              return GestureDetector(
                onTap: () => widget.onFilterChanged(tab['key']!),
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(right: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        tab['label']!,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey[600],
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 2,
                        width: isSelected ? tab['label']!.length * 8.0 : 0,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
