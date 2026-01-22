import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'services_list.dart';
import 'products_list.dart';

class ComboItemsSelector extends StatefulWidget {
  final Set<String> selectedServiceIds;
  final Map<String, int> selectedProductQuantities;
  final Function(String) onServiceToggle;
  final Function(String) onProductToggle;
  final Function(String, int) onProductQuantityChange;
  final CatalogLoaded initialState;

  const ComboItemsSelector({
    super.key,
    required this.selectedServiceIds,
    required this.selectedProductQuantities,
    required this.onServiceToggle,
    required this.onProductToggle,
    required this.onProductQuantityChange,
    required this.initialState,
  });

  @override
  State<ComboItemsSelector> createState() => _ComboItemsSelectorState();
}

class _ComboItemsSelectorState extends State<ComboItemsSelector> {
  int _currentTab = 0; // 0 = Serviços, 1 = Produtos

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Itens do combo',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '*',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Tabs
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _currentTab = 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _currentTab == 0 ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.tag,
                          color: _currentTab == 0 ? Colors.white : Colors.black,
                          size: 16,
                        ),
                        Text(
                          'Serviços${widget.selectedServiceIds.isNotEmpty ? ' (${widget.selectedServiceIds.length})' : ''}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _currentTab == 0
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _currentTab = 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _currentTab == 1 ? Colors.black : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.package,
                          color: _currentTab == 1 ? Colors.white : Colors.black,
                          size: 16,
                        ),
                        Text(
                          'Produtos${widget.selectedProductQuantities.isNotEmpty ? ' (${widget.selectedProductQuantities.length})' : ''}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _currentTab == 1
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Lista de items
        BlocBuilder<CatalogBloc, CatalogState>(
          builder: (context, state) {
            final catalogState = state is CatalogLoaded
                ? state
                : widget.initialState;

            // Calcula a quantidade de items baseado na aba ativa
            final itemCount = _currentTab == 0
                ? catalogState.services.length
                : catalogState.products.length;

            // Se não há items, usa altura fixa para mensagem de vazio
            if (itemCount == 0) {
              return Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _currentTab == 0
                    ? ComboServicesList(
                        services: catalogState.services,
                        selectedIds: widget.selectedServiceIds,
                        onToggle: widget.onServiceToggle,
                      )
                    : ComboProductsList(
                        products: catalogState.products,
                        selectedQuantities: widget.selectedProductQuantities,
                        onToggle: widget.onProductToggle,
                        onQuantityChange: widget.onProductQuantityChange,
                      ),
              );
            }

            // Altura dinâmica: cresce até 4 items, depois fixa para permitir scroll
            final itemHeight = 68.0; // Altura fixa de cada item (Container)
            final listPadding =
                24.0; // padding da ListView (12 top + 12 bottom)
            final maxVisibleItems = 4;

            final contentHeight = itemCount <= maxVisibleItems
                ? (itemCount * itemHeight) + listPadding
                : (maxVisibleItems * itemHeight) + listPadding;

            return Container(
              height: contentHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _currentTab == 0
                  ? ComboServicesList(
                      services: catalogState.services,
                      selectedIds: widget.selectedServiceIds,
                      onToggle: widget.onServiceToggle,
                    )
                  : ComboProductsList(
                      products: catalogState.products,
                      selectedQuantities: widget.selectedProductQuantities,
                      onToggle: widget.onProductToggle,
                      onQuantityChange: widget.onProductQuantityChange,
                    ),
            );
          },
        ),

        if (widget.selectedServiceIds.length +
                widget.selectedProductQuantities.length <
            2) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.red.withValues(alpha: 0.06),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                spacing: 10,
                children: [
                  Icon(LucideIcons.triangleAlert, color: Colors.red, size: 16),
                  Flexible(
                    child: Text(
                      'Selecione pelo menos 2 itens (serviços ou produtos)',
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
