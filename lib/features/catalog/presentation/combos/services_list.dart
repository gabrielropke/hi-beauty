import 'package:flutter/material.dart';
import 'package:hibeauty/features/catalog/data/model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ComboServicesList extends StatelessWidget {
  final List<ServicesModel> services;
  final Set<String> selectedIds;
  final Function(String) onToggle;

  const ComboServicesList({
    super.key,
    required this.services,
    required this.selectedIds,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.scissors, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Nenhum serviço encontrado',
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
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        final isSelected = selectedIds.contains(service.id);

        return GestureDetector(
          onTap: () => onToggle(service.id),
          child: SizedBox(
            height: 68,
            child: ListTile(
            leading: SizedBox(
              width: 24,
              child: Center(
                child: GestureDetector(
                  onTap: () => onToggle(service.id),
                  child: Icon(
                    isSelected ? Icons.check_box : LucideIcons.square200,
                    color: isSelected ? Theme.of(context).primaryColor : Colors.black,
                  ),
                ),
              ),
            ),
            title: Text(
              service.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'R\$ ${service.price.toStringAsFixed(2).replaceAll('.', ',')}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ),
        );
      },
    );
  }
}
