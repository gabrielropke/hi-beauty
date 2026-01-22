import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/constants/formatters/money.dart';
import 'package:hibeauty/features/catalog/data/model.dart';
import 'package:hibeauty/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:hibeauty/features/catalog/presentation/products/products_details_screen.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ProductsList extends StatelessWidget {
  final List<ProductsModel> products;
  final CatalogLoaded state;

  const ProductsList({super.key, required this.products, required this.state});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(LucideIcons.package, size: 48, color: Colors.black26),
              SizedBox(height: 16),
              Text(
                'Nenhum produto encontrado',
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
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ProductCard(products: product),
        );
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductsModel products;

  const ProductCard({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final catalogBloc = context.read<CatalogBloc>();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductsDetailsScreen(products: products, bloc: catalogBloc),
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
              child: products.imageUrl != null && products.imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: products.imageUrl!,
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
                          LucideIcons.package,
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
                        LucideIcons.package,
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
                    products.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  if (products.description != null &&
                      products.description!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      products.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  if (products.controllingStock) ...[
                    Text(
                      'Estoque: ${products.stock}',
                      style: TextStyle(
                        fontSize: 12,
                        color: products.isLowStock ? Colors.red : Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  Text(
                    moneyFormat(context, products.price.toString()),
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
