import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/features/customers/data/model.dart';
import 'package:hibeauty/features/customers/presentation/add_customer.dart';
import 'package:hibeauty/features/customers/presentation/bloc/customers_bloc.dart';
import 'package:hibeauty/features/customers/presentation/customer_view.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CustomerTile extends StatelessWidget {
  final CustomerModel customer;
  final CustomersLoaded state;
  const CustomerTile({super.key, required this.customer, required this.state});

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
                // opção Editar sem efeito de toque
                OptionItem(
                  label: 'Editar',
                  onTap: () {
                    context.pop();
                    showAddCustomerSheet(
                      context: context,
                      state: state,
                      l10n: AppLocalizations.of(context)!,
                      customer: customer,
                    );
                  },
                ),
                const SizedBox(height: 4),
                // opção Deletar sem efeito de toque
                OptionItem(
                  label: 'Deletar',
                  destructive: true,
                  onTap: () => _showDeleteConfirmation(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: Text(
            'Tem certeza que deseja excluir ${customer.name}? Esta ação não pode ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // fechar modal de opções
                context.read<CustomersBloc>().add(DeleteCustomers(customer.id));
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showCustomerView(
        context: context,
        state: state,
        l10n: AppLocalizations.of(context)!,
        customerId: customer.id,
      ),
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 12,
          children: [
            _Avatar(
              fallback: customer.name.isNotEmpty
                  ? customer.name.characters.first.toUpperCase()
                  : '?',
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: Text(
                          customer.name.isEmpty ? '—' : customer.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (customer.email.isNotEmpty)
                  Row(
                    spacing: 12,
                    children: [
                      Text(
                        customer.email,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      // _StatusBadge(isActive: customer.isActive),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _showCustomerOptions(context),
              icon: const Icon(LucideIcons.ellipsisVertical300, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String fallback;
  const _Avatar({required this.fallback});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.blueGrey.withValues(alpha: 0.15),
          border: Border.all(
            color: Colors.blueGrey.withValues(alpha: 0.35),
            width: 1,
          ),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            fallback,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey.withValues(alpha: 0.9),
            ),
          ),
        ),
      ),
    );
  }
}

class OptionItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool destructive;
  const OptionItem({super.key, 
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = Colors.black;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 40,
        width: double.infinity,
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
