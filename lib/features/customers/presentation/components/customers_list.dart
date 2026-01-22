import 'package:flutter/material.dart';
import 'package:hibeauty/features/customers/data/model.dart';
import 'package:hibeauty/features/customers/presentation/bloc/customers_bloc.dart';
import 'customer_tile.dart';

class CustomersList extends StatelessWidget {
  final List<CustomerModel> customers;
  final CustomersLoaded state;
  const CustomersList({super.key, required this.customers, required this.state});

  @override
  Widget build(BuildContext context) {
    if (customers.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 8),
        child: Text(
          'Nenhum cliente encontrado.',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
        ),
      );
    }
    return Column(
      children: [
        for (int i = 0; i < customers.length; i++) ...[
          CustomerTile(customer: customers[i], state: state),
          if (i < customers.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                height: 20,
                thickness: 1,
                color: Colors.black.withValues(alpha: 0.06),
              ),
            ),
        ],
      ],
    );
  }
}
