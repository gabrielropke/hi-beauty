import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/components/custom_app_bar.dart';
import 'package:hibeauty/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:hibeauty/features/notifications/presentation/components/notification_card.dart';
import 'package:hibeauty/features/notifications/presentation/components/notifications_options_modal.dart';
import 'package:hibeauty/features/notifications/presentation/components/tabs_notifications.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          NotificationsBloc(context)..add(NotificationsLoadRequested()),
      child: NotificationsView(),
    );
  }
}

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});
  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedFilter = 'all';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      key: _scaffoldKey,
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) => switch (state) {
          NotificationsLoading _ => const AppLoader(),
          NotificationsLoaded s => _loaded(s, l10n, context),
          NotificationsState() => const AppLoader(),
        },
      ),
    );
  }

  Widget _loaded(
    NotificationsLoaded state,
    AppLocalizations l10n,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          CustomAppBar(
            title: 'Notificações',
            fixShowTitle: true,
            actions: [
              GestureDetector(
                onTap: () => showAllConfigurations(context: context),
                child: Container(
                  width: 40,
                  height: 40,
                  color: Colors.transparent,
                  child: Icon(LucideIcons.ellipsisVertical300),
                ),
              ),
            ],
          ),
          TabsNotifications(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          ),

          Expanded(
            child: _getFilteredNotifications(state.notifications).isEmpty
                ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.2),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                LucideIcons.megaphoneOff300,
                                size: 80,
                                color: Colors.grey.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Ainda não há notificações',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                : SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        SizedBox(),
                        ..._getFilteredNotifications(state.notifications).map(
                          (notification) =>
                              NotificationCard(notification: notification),
                        ),
                        SafeArea(child: SizedBox()),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  List<dynamic> _getFilteredNotifications(List<dynamic> notifications) {
    if (_selectedFilter == 'all') {
      return notifications;
    }
    return notifications
        .where(
          (notification) =>
              notification.type.toLowerCase() == _selectedFilter.toLowerCase(),
        )
        .toList();
  }
}
