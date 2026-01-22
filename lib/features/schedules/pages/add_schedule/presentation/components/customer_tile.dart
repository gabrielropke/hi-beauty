import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/features/customers/data/model.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/bloc/add_schedule_bloc.dart';

class CustomerTile extends StatelessWidget {
  final BuildContext bcontext;
  final CustomerModel customer;
  final AddScheduleLoaded state;
  const CustomerTile({
    super.key,
    required this.customer,
    required this.state,
    required this.bcontext,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        bcontext.read<AddScheduleBloc>().add(
          SelectCustomer(customer: customer),
        );
        context.pop();
      },
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
