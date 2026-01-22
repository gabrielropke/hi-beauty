import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/constants/formatters/money.dart';
import 'package:hibeauty/features/catalog/data/model.dart';
import 'package:hibeauty/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:hibeauty/features/catalog/presentation/services/services_details_screen.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ServicesList extends StatelessWidget {
  final List<ServicesModel> services;
  final CatalogLoaded state;

  const ServicesList({super.key, required this.services, required this.state});

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(LucideIcons.package, size: 48, color: Colors.black26),
              SizedBox(height: 16),
              Text(
                'Nenhum serviço encontrado',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ServiceCard(service: service),
        );
      },
    );
  }
}

class ServiceCard extends StatelessWidget {
  final ServicesModel service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final catalogBloc = context.read<CatalogBloc>();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServicesDetailsScreen(
              service: service,
              bloc: catalogBloc,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  service.coverImageUrl != null &&
                      service.coverImageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: service.coverImageUrl!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black12, width: 1),
                        ),
                        child: Icon(
                          LucideIcons.scissors300,
                          color: Colors.black12,
                          size: 40,
                        ),
                      ),
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black12, width: 1),
                      ),
                      child: Icon(
                        LucideIcons.scissors300,
                        color: Colors.black12,
                        size: 40,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  if (service.description != null &&
                      service.description!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                        service.description!.length <= 20
                          ? service.description!
                          : '${service.description!.substring(0, 20)}...',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                  SizedBox(height: 12),
                  Text(
                    moneyFormat(context, service.price.toString()),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
