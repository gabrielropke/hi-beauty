import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/core/data/business.dart';
import 'package:hibeauty/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class FastActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const FastActionCard({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Icon(icon, size: 20), Spacer(), Text(title)],
          ),
        ),
      ),
    );
  }
}

class FastActions extends StatefulWidget {
  final DashboardLoaded state;
  const FastActions({super.key, required this.state});

  @override
  State<FastActions> createState() => _FastActionsState();
}

class _FastActionsState extends State<FastActions> {
  final ScrollController _scrollController = ScrollController();
  bool _hasScroll = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScrollability();
    });
  }

  void _checkScrollability() {
    if (_scrollController.hasClients) {
      final hasScroll = _scrollController.position.maxScrollExtent > 0;
      if (hasScroll != _hasScroll) {
        setState(() {
          _hasScroll = hasScroll;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> actions = [
      {
        'icon': LucideIcons.calendarRange300,
        'title': 'Meu Site',
        'onTap': () async {
          final Map<String, dynamic> brandMap = await BrandLoader.load();
          final String brandId = brandMap['id'];
          final Uri url = Uri.parse(
            'https://app.$brandId.co/b/${BusinessData.slug}',
          );
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          }
        },
      },
      {
        'icon': LucideIcons.building2300,
        'title': 'Negócio',
        'onTap': () {
          context.push(AppRoutes.businessConfig);
        },
      },

      {
        'icon': LucideIcons.userRoundCog300,
        'title': 'Equipe',
        'onTap': () {
          context.push(AppRoutes.team);
        },
      },

      {
        'icon': LucideIcons.timer300,
        'title': 'Turnos',
        'onTap': () {
          context.push(AppRoutes.businessHours);
        },
      },

      {
        'icon': LucideIcons.package300,
        'title': 'Serviços',
        'onTap': () {
          context.push(AppRoutes.services);
        },
      },
    ];

    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Navegação rápida',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              spacing: 8,
              children: actions
                  .map(
                    (action) => FastActionCard(
                      icon: action['icon'],
                      title: action['title'],
                      onTap: action['onTap'],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        SizedBox(height: 0),
      ],
    );
  }
}
