import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/features/home/presentation/bloc/home_bloc.dart';
import 'package:hibeauty/features/home/presentation/components/add_options_modal.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class Navbar extends StatelessWidget {
  final HomeTabs currentTab;
  const Navbar({super.key, required this.currentTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.withValues(alpha: 0.2), width: 1),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavbarItem(
              icon: LucideIcons.house,
              currentTab: currentTab,
              itemTab: HomeTabs.dashboard,
            ),
            _NavbarItem(
              icon: LucideIcons.calendarRange,
              currentTab: currentTab,
              itemTab: HomeTabs.schedules,
            ),

            Expanded(
              child: GestureDetector(
                onTap: () => showAddressDataEditSheet(context: context),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Icon(
                        LucideIcons.plus,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _NavbarItem(
              icon: LucideIcons.smile,
              currentTab: currentTab,
              itemTab: HomeTabs.clients,
            ),
            _NavbarItem(
              icon: LucideIcons.layoutGrid,
              currentTab: currentTab,
              itemTab: HomeTabs.business,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavbarItem extends StatelessWidget {
  final IconData icon;
  final HomeTabs currentTab;
  final HomeTabs itemTab;

  const _NavbarItem({
    required this.icon,
    required this.currentTab,
    required this.itemTab,
  });

  @override
  Widget build(BuildContext context) {
    bool selected = itemTab == currentTab;
    Color selectedColor = selected
        ? AppColors.secondary
        : Colors.black.withValues(alpha: 0.6);

    return Expanded(
      child: GestureDetector(
        onTap: () => context.read<HomeBloc>().add(ChangeTab(itemTab)),
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(color: Colors.transparent),
          child: Icon(icon, size: 24, color: selectedColor),
        ),
      ),
    );
  }
}
