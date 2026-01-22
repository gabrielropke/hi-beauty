import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/components/custom_app_bar.dart';
import 'package:hibeauty/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:hibeauty/features/catalog/data/model.dart';
import 'package:hibeauty/features/catalog/presentation/products/add_product.dart';
import 'package:hibeauty/features/customers/presentation/components/customer_tile.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ProductsDetailsScreen extends StatelessWidget {
  final ProductsModel products;
  final CatalogBloc? bloc;

  const ProductsDetailsScreen({super.key, required this.products, this.bloc});

  @override
  Widget build(BuildContext context) {
    final catalogBloc =
        bloc ?? BlocProvider.of<CatalogBloc>(context, listen: false);

    return BlocProvider.value(
      value: catalogBloc,
      child: ProductsView(products: products),
    );
  }
}

class ProductsView extends StatefulWidget {
  final ProductsModel products;
  const ProductsView({super.key, required this.products});
  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final ScrollController _scrollController = ScrollController();
  bool _productExists = true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showCustomerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            // reduz padding geral
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // botão fechar com menos padding
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () => context.pop(),
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: const Icon(LucideIcons.x200),
                    ),
                  ),
                ),
                const SizedBox(height: 4),

                OptionItem(
                  label: 'Editar',
                  onTap: () {
                    context.pop(); // Fechar modal primeiro

                    // Pegar o estado atual para acessar team data
                    final currentState = context.read<CatalogBloc>().state;
                    if (currentState is CatalogLoaded) {
                      showAddProduct(
                        context: context,
                        state: currentState,
                        l10n: AppLocalizations.of(context)!,
                        product: widget.products,
                      );
                    }
                  },
                ),
                const SizedBox(height: 4),
                // opção Deletar sem efeito de toque
                OptionItem(
                  label: 'Deletar',
                  destructive: true,
                  onTap: () {
                    context.pop(); // Fechar modal primeiro
                    context.read<CatalogBloc>().add(
                      DeleteProduct(widget.products.id),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<CatalogBloc, CatalogState>(
      listener: (context, state) {
        if (state is CatalogLoaded) {
          // Verifica se o produto ainda existe na lista
          final productExists = state.products.any(
            (p) => p.id == widget.products.id,
          );
          if (_productExists && !productExists) {
            // Produto foi removido, volta para a tela anterior
            context.pop();
          }
          _productExists = productExists;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<CatalogBloc, CatalogState>(
          builder: (context, state) => switch (state) {
            CatalogLoading _ => const AppLoader(),
            CatalogLoaded s => _loaded(s, l10n, context), // passar context
            CatalogState() => const AppLoader(),
          },
        ),
      ),
    );
  }

  Widget _loaded(
    CatalogLoaded state,
    AppLocalizations l10n,
    BuildContext context,
  ) {
    final product = widget.products;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          CustomAppBar(
            title: product.name,
            controller: _scrollController,
            backgroundColor: Colors.white,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 8),
                        _image(product.imageUrl ?? ''),
                        SizedBox(height: 16),
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        if (widget.products.controllingStock == true) ...[
                          SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                              color: widget.products.isLowStock
                                  ? Colors.red.withValues(alpha: 0.05)
                                  : Colors.blue.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: Colors.black12,
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 12,
                              ),
                              child: Text(
                                '${widget.products.stock} em estoque',
                                style: TextStyle(
                                  color: widget.products.isLowStock
                                      ? Colors.red
                                      : Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 12),
                        AppButton(
                          label: 'Ações',
                          fillColor: Colors.transparent,
                          labelColor: Colors.black87,
                          borderColor: Colors.black12,
                          function: () => _showCustomerOptions(context),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.grey[50],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Informações do produto',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            TextButton(
                             onPressed: () {
                                final currentState = context
                                    .read<CatalogBloc>()
                                    .state;
                                if (currentState is CatalogLoaded) {
                                  showAddProduct(
                                    context: context,
                                    state: currentState,
                                    l10n: AppLocalizations.of(context)!,
                                    product: widget
                                        .products, // Passar o produto para edição
                                  );
                                }
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                              ),
                              child: const Text(
                                'Editar',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        _PreviewTile(
                          label: 'Nome do produto',
                          value: product.name,
                        ),
                        SizedBox(height: 16),
                        _PreviewTile(
                          label: 'Descrição',
                          value: product.description ?? '-',
                        ),
                        SizedBox(height: 16),
                        _PreviewTile(
                          label: 'Código de barras',
                          value: product.barcode ?? '-',
                        ),
                        SizedBox(height: 16),
                        _PreviewTile(
                          label: 'Preço de venda',
                          value:
                              'R\$ ${product.price.toStringAsFixed(2).replaceAll('.', ',')}',
                        ),
                        SizedBox(height: 16),
                        _PreviewTile(
                          label: 'Preço de custo',
                          value:
                              'R\$ ${product.costPrice.toStringAsFixed(2).replaceAll('.', ',')}',
                        ),
                        SizedBox(height: 16),
                        _PreviewTile(
                          label: 'Visibilidade',
                          value: mapVisibility(
                            product.visibility.toLowerCase(),
                          ),
                        ),
                        SizedBox(height: 16),
                        _PreviewTile(
                          label: 'Status',
                          value: product.isActive ? 'Ativo' : 'Inativo',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.grey[50],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Dados de estoque',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            TextButton(
                             onPressed: () {
                                final currentState = context
                                    .read<CatalogBloc>()
                                    .state;
                                if (currentState is CatalogLoaded) {
                                  showAddProduct(
                                    context: context,
                                    state: currentState,
                                    l10n: AppLocalizations.of(context)!,
                                    product: widget
                                        .products, // Passar o produto para edição
                                  );
                                }
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                              ),
                              child: const Text(
                                'Editar',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        _PreviewTile(label: 'SKU', value: product.sku ?? '-'),
                        SizedBox(height: 16),
                        _PreviewTile(
                          label: 'Quantidade',
                          value: product.measurementQuantity == 0
                              ? '-'
                              : '${product.measurementQuantity.toInt()} ${product.measurementUnit}',
                        ),
                        SizedBox(height: 16),
                        _PreviewTile(
                          label: 'Estoque atual',
                          value: product.stock == 0
                              ? '-'
                              : '${product.stock} unidades',
                        ),
                        SizedBox(height: 16),
                        _PreviewTile(
                          label: 'Estoque mínimo',
                          value: product.lowStockThreshold == 0
                              ? '-'
                              : '${product.lowStockThreshold} unidades',
                        ),
                        SizedBox(height: 16),
                        _PreviewTile(
                          label: 'Controle de estoque',
                          value: product.controllingStock ? 'Ativo' : 'Inativo',
                        ),
                        SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onAdd;
  // ignore: unused_element_parameter
  const _PreviewTile({required this.label, required this.value, this.onAdd});
  @override
  Widget build(BuildContext context) {
    final isEmpty = value.isEmpty;
    return Row(
      spacing: 64,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        if (!isEmpty)
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
          )
        else
          TextButton(
            onPressed: onAdd,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: Colors.blue,
            ),
            child: const Text(
              'Adicionar',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }
}

_image(String url) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: url.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: url,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12, width: 1),
              ),
              child: Icon(LucideIcons.package, color: Colors.black12, size: 40),
            ),
          )
        : Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12, width: 1),
            ),
            child: Icon(LucideIcons.package, color: Colors.black12, size: 40),
          ),
  );
}

String mapLocationType(String value) {
  switch (value) {
    case 'in_person':
      return 'Presencial';
    case 'online':
      return 'Remoto';
    case 'to_be_arranged':
      return 'A combinar';
    default:
      return value;
  }
}

String mapVisibility(String value) {
  switch (value) {
    case 'public':
      return 'Público';
    case 'private':
      return 'Privado';
    default:
      return value;
  }
}
