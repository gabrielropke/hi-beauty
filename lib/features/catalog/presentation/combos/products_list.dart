import 'package:flutter/material.dart';
import 'package:hibeauty/features/catalog/data/model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ComboProductsList extends StatelessWidget {
  final List<ProductsModel> products;
  final Map<String, int> selectedQuantities;
  final Function(String) onToggle;
  final Function(String, int) onQuantityChange;

  const ComboProductsList({
    super.key,
    required this.products,
    required this.selectedQuantities,
    required this.onToggle,
    required this.onQuantityChange,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.package,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Nenhum produto encontrado',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(6),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final isSelected = selectedQuantities.containsKey(product.id);
        final quantity = selectedQuantities[product.id] ?? 1;

        return GestureDetector(
          onTap: () => onToggle(product.id),
          child: SizedBox(
            height: 68,
            child: ListTile(
            leading: SizedBox(
              width: 24,
              child: Center(
                child: GestureDetector(
                  onTap: () => onToggle(product.id),
                  child: Icon(
                    isSelected ? Icons.check_box : LucideIcons.square200,
                    color: isSelected ? Theme.of(context).primaryColor : Colors.black,
                  ),
                ),
              ),
            ),
            title: Text(
              product.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'R\$ ${product.price.toStringAsFixed(2).replaceAll('.', ',')}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: isSelected 
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => onQuantityChange(product.id, quantity - 1),
                        icon: Icon(LucideIcons.minus, size: 16),
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        padding: EdgeInsets.zero,
                      ),
                      SizedBox(
                        child: Text(
                          quantity.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => onQuantityChange(product.id, quantity + 1),
                        icon: Icon(LucideIcons.plus, size: 16),
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  )
                : null,
            ),
          ),
        );
      },
    );
  }
}