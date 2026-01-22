import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/components/custom_app_bar.dart';
import 'package:hibeauty/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:hibeauty/features/catalog/data/model.dart';
import 'package:hibeauty/features/catalog/presentation/combos/add_combo.dart';
import 'package:hibeauty/features/customers/presentation/components/customer_tile.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CombosDetailsScreen extends StatelessWidget {
  final CombosModel combo;
  final CatalogBloc? bloc;

  const CombosDetailsScreen({super.key, required this.combo, this.bloc});

  @override
  Widget build(BuildContext context) {
    final catalogBloc =
        bloc ?? BlocProvider.of<CatalogBloc>(context, listen: false);

    return BlocProvider.value(
      value: catalogBloc,
      child: CombosView(combo: combo),
    );
  }
}

class CombosView extends StatefulWidget {
  final CombosModel combo;
  const CombosView({super.key, required this.combo});
  @override
  State<CombosView> createState() => _CombosViewState();
}

class _CombosViewState extends State<CombosView> {
  final ScrollController _scrollController = ScrollController();
  bool _comboExists = true;

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

                    // Pegar o estado atual para acessar dados do catálogo
                    final currentState = context.read<CatalogBloc>().state;
                    if (currentState is CatalogLoaded) {
                      showAddCombo(
                        context: context,
                        state: currentState,
                        l10n: AppLocalizations.of(context)!,
                        combo: widget.combo,
                      );
                    }
                  },
                ),
                const SizedBox(height: 4),
                OptionItem(
                  label: 'Deletar',
                  destructive: true,
                  onTap: () {
                    context.pop(); // Fechar modal primeiro
                    context.read<CatalogBloc>().add(
                      DeleteCombo(widget.combo.id),
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
          // Verifica se o combo ainda existe na lista
          final comboExists = state.combos.any(
            (c) => c.id == widget.combo.id,
          );
          if (_comboExists && !comboExists) {
            // Combo foi removido, volta para a tela anterior
            context.pop();
          }
          _comboExists = comboExists;
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
    final combo = widget.combo;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          CustomAppBar(
            title: combo.name,
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
                        _image(combo.coverImageUrl ?? ''),
                        SizedBox(height: 16),
                        Text(
                          combo.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.green.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 12,
                                ),
                                child: Text(
                                  'R\$ ${combo.price.toStringAsFixed(2).replaceAll('.', ',')}',
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            if (combo.discount > 0) ...[
                              SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.red.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 12,
                                  ),
                                  child: Text(
                                    '${combo.discount.toInt()}% OFF',
                                    style: TextStyle(
                                      color: Colors.red[700],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
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
                                'Informações do combo',
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
                                  showAddCombo(
                                    context: context,
                                    state: currentState,
                                    l10n: AppLocalizations.of(context)!,
                                    combo: widget.combo, // Passar o combo para edição
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
                          label: 'Nome do combo',
                          value: combo.name,
                        ),
                        SizedBox(height: 16),
                        _PreviewTile(
                          label: 'Descrição',
                          value: combo.description ?? '-',
                        ),
                        SizedBox(height: 16),
                        _PreviewTile(
                          label: 'Preço promocional',
                          value:
                              'R\$ ${combo.price.toStringAsFixed(2).replaceAll('.', ',')}',
                        ),
                        SizedBox(height: 16),
                        _PreviewTile(
                          label: 'Preço original',
                          value:
                              'R\$ ${combo.originalPrice.toStringAsFixed(2).replaceAll('.', ',')}',
                        ),
                        SizedBox(height: 16),
                        _PreviewTile(
                          label: 'Desconto',
                          value: combo.discount > 0 ? '${combo.discount.toInt()}%' : '-',
                        ),
                        SizedBox(height: 16),
                        _PreviewTile(
                          label: 'Duração total',
                          value: combo.totalDuration > 0 ? '${combo.totalDuration} min' : '-',
                        ),
                        SizedBox(height: 16),
                        _PreviewTile(
                          label: 'Visibilidade',
                          value: mapVisibility(
                            combo.visibility.toLowerCase(),
                          ),
                        ),
                        SizedBox(height: 16),
                        _PreviewTile(
                          label: 'Status',
                          value: combo.isActive ? 'Ativo' : 'Inativo',
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
                        Text(
                          'Serviços inclusos (${combo.services.length})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),
                        if (combo.services.isEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text(
                                'Nenhum serviço incluído',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                        else
                          ...combo.services.map((service) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(LucideIcons.scissors, size: 16, color: Colors.grey[600]),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          service.name,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '${service.duration} min • R\$ ${service.price.toStringAsFixed(2).replaceAll('.', ',')}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
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
                        Text(
                          'Produtos inclusos (${combo.products.length})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),
                        if (combo.products.isEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text(
                                'Nenhum produto incluído',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                        else
                          ...combo.products.map((product) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(LucideIcons.package, size: 16, color: Colors.grey[600]),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          'Qtd: ${product.quantity} • R\$ ${product.price.toStringAsFixed(2).replaceAll('.', ',')}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
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
              child: Icon(LucideIcons.packageOpen, color: Colors.black12, size: 40),
            ),
          )
        : Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12, width: 1),
            ),
            child: Icon(LucideIcons.packageOpen, color: Colors.black12, size: 40),
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
