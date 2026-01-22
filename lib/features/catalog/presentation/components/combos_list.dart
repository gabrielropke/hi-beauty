import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/constants/formatters/money.dart';
import 'package:hibeauty/features/catalog/data/model.dart';
import 'package:hibeauty/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:hibeauty/features/catalog/presentation/combos/combos_details_screen.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CombosList extends StatelessWidget {
  final List<CombosModel> combos;
  final CatalogLoaded state;

  const CombosList({super.key, required this.combos, required this.state});

  @override
  Widget build(BuildContext context) {
    if (combos.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(LucideIcons.package, size: 48, color: Colors.black26),
              SizedBox(height: 16),
              Text(
                'Nenhum combo encontrado',
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
      itemCount: combos.length,
      itemBuilder: (context, index) {
        final combo = combos[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ComboCard(combos: combo),
        );
      },
    );
  }
}

class ComboCard extends StatelessWidget {
  final CombosModel combos;

  const ComboCard({super.key, required this.combos});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final catalogBloc = context.read<CatalogBloc>();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CombosDetailsScreen(
              combo: combos,
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
                  combos.coverImageUrl != null &&
                      combos.coverImageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: combos.coverImageUrl!,
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
                          LucideIcons.gift,
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
                        LucideIcons.gift,
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
                    combos.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  if (combos.description != null &&
                      combos.description!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      combos.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                  SizedBox(height: 6),
                  Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        moneyFormat(context, combos.price.toString()),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '-${moneyFormat(context, combos.discount.toString())}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
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
