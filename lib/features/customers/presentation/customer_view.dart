// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/constants/formatters/date.dart';
import 'package:hibeauty/core/constants/formatters/money.dart';
import 'package:hibeauty/features/customers/data/model.dart';
import 'package:hibeauty/features/customers/presentation/bloc/customers_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';

Future<void> showCustomerView({
  required BuildContext context,
  required CustomersLoaded state,
  required AppLocalizations l10n,
  required String customerId,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    useSafeArea: true,
    barrierColor: Colors.transparent,
    clipBehavior: Clip.hardEdge,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
    ),
    builder: (ctx) {
      return BlocProvider.value(
        value: context.read<CustomersBloc>()
          ..add(LoadCustomerWithBookings(customerId: customerId)),
        child: Container(
          color: AppColors.background,
          child: _CustomerView(
            state: state,
            l10n: l10n,
            customerId: customerId,
          ),
        ),
      );
    },
  );
}

class _CustomerView extends StatefulWidget {
  const _CustomerView({
    required this.state,
    required this.l10n,
    required this.customerId,
  });

  final CustomersLoaded state;
  final AppLocalizations l10n;
  final String customerId;

  @override
  State<_CustomerView> createState() => _CustomerViewState();
}

class _CustomerViewState extends State<_CustomerView> {
  final ScrollController _controller = ScrollController();
  bool _showHeaderTitle = false;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final shouldShow = _controller.offset > 8;
      if (shouldShow != _showHeaderTitle) {
        setState(() => _showHeaderTitle = shouldShow);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<CustomersBloc, CustomersState>(
          builder: (context, state) {
            if (state is! CustomersLoaded) {
              return const Center(child: Text('Erro ao carregar dados'));
            }

            if (state.loading) {
              return const AppLoader();
            }

            if (state.customerWithBookings == null) {
              return const Center(child: Text('Carregando cliente...'));
            }

            final customer = state.customerWithBookings!.customer;
            final bookings = state.customerWithBookings!.bookings;

            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOut,
                            opacity: _showHeaderTitle ? 1 : 0,
                            child: IgnorePointer(
                              ignoring: !_showHeaderTitle,
                              child: Row(
                                spacing: 10,
                                children: [
                                  _Avatar(
                                    fallback: customer.name.characters.first
                                        .toUpperCase(),
                                    size: 34,
                                    textSize: 12,
                                  ),
                                  Text(
                                    customer.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    opacity: _showHeaderTitle ? 1 : 0,
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey[300],
                      height: 5,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _controller,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _Avatar(
                              fallback: customer.name.characters.first
                                  .toUpperCase(),
                              size: 80,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Center(
                              child: Text(
                                customer.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Center(
                              child: Text(
                                customer.email,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.black12,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _PreviewTile(
                                      label: 'Telefone',
                                      value: customer.phone,
                                    ),
                                    const SizedBox(height: 4),
                                    _PreviewTile(
                                      label: 'Idade',
                                      value: customer.age != null
                                          ? '${customer.age} anos'
                                          : 'Não informado',
                                    ),
                                    const SizedBox(height: 4),
                                    _PreviewTile(
                                      label: 'Observação do Cliente',
                                      value: customer.notes ?? 'Nenhuma observação',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Agendamentos',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16, bottom: 16),
                              child: Row(
                                children: [
                                  _StatusTab(
                                    label: 'Tudo',
                                    isSelected: _selectedStatus == null,
                                    onTap: () => setState(() => _selectedStatus = null),
                                  ),
                                  const SizedBox(width: 8),
                                  _StatusTab(
                                    label: 'Reservado',
                                    isSelected: _selectedStatus == 'SCHEDULED',
                                    onTap: () => setState(() => _selectedStatus = 'SCHEDULED'),
                                  ),
                                  const SizedBox(width: 8),
                                  _StatusTab(
                                    label: 'Confirmado',
                                    isSelected: _selectedStatus == 'CONFIRMED',
                                    onTap: () => setState(() => _selectedStatus = 'CONFIRMED'),
                                  ),
                                  const SizedBox(width: 8),
                                  _StatusTab(
                                    label: 'Concluído',
                                    isSelected: _selectedStatus == 'COMPLETED',
                                    onTap: () => setState(() => _selectedStatus = 'COMPLETED'),
                                  ),
                                  const SizedBox(width: 8),
                                  _StatusTab(
                                    label: 'Cancelado',
                                    isSelected: _selectedStatus == 'CANCELLED',
                                    onTap: () => setState(() => _selectedStatus = 'CANCELLED'),
                                  ),
                                  const SizedBox(width: 8),
                                  _StatusTab(
                                    label: 'Não compareceu',
                                    isSelected: _selectedStatus == 'NO_SHOW',
                                    onTap: () => setState(() => _selectedStatus = 'NO_SHOW'),
                                  ),
                                  const SizedBox(width: 8),
                                  _StatusTab(
                                    label: 'Reagendado',
                                    isSelected: _selectedStatus == 'RESCHEDULED',
                                    onTap: () => setState(() => _selectedStatus = 'RESCHEDULED'),
                                  ),
                                  const SizedBox(width: 8),
                                  _StatusTab(
                                    label: 'Bloqueado',
                                    isSelected: _selectedStatus == 'BLOCK',
                                    onTap: () => setState(() => _selectedStatus = 'BLOCK'),
                                  ),
                                  const SizedBox(width: 16),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...() {
                            final now = DateTime.now();
                            
                            if (bookings.isEmpty) {
                              return [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    'Nenhum agendamento encontrado...',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ];
                            }

                            // Separar agendamentos futuros e passados
                            final futureBookings = bookings
                                .where((b) => b.scheduledFor.isAfter(now))
                                .toList();
                            final pastBookings = bookings
                                .where((b) => !b.scheduledFor.isAfter(now))
                                .toList();

                            // Ordenar futuros por data (mais próximo primeiro)
                            futureBookings.sort(
                              (a, b) => a.scheduledFor.compareTo(b.scheduledFor),
                            );

                            // Ordenar passados por data (mais recente primeiro)
                            pastBookings.sort(
                              (a, b) => b.scheduledFor.compareTo(a.scheduledFor),
                            );

                            // Combinar listas: futuros primeiro, depois passados
                            var sortedBookings = [
                              ...futureBookings,
                              ...pastBookings,
                            ];

                            // Filtrar por status se selecionado
                            if (_selectedStatus != null) {
                              sortedBookings = sortedBookings
                                  .where((b) => b.status.toUpperCase() == _selectedStatus)
                                  .toList();
                            }

                            return [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  children: sortedBookings.asMap().entries.map((entry) {
                                    final booking = entry.value;
                                    final isLast = entry.key == sortedBookings.length - 1;

                                    final isNextBooking = futureBookings.isNotEmpty &&
                                        booking.id == futureBookings.first.id &&
                                        _selectedStatus == null;

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (isNextBooking) ...[
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 16),
                                            child: Text(
                                              'Próximo',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.deepPurple,
                                              ),
                                            ),
                                          ),
                                        ],
                                        _BookingCard(
                                          booking: booking,
                                          isLast: isLast,
                                          isNext: isNextBooking,
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ];
                          }(),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String fallback;
  final double size;
  final double? textSize;
  const _Avatar({required this.fallback, required this.size, this.textSize});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(0.15),
            border: Border.all(
              color: Colors.blueGrey.withOpacity(0.35),
              width: 1,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              fallback,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: textSize ?? 18,
                color: Colors.blueGrey.withOpacity(0.9),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewTile extends StatelessWidget {
  final String label;
  final String value;
  const _PreviewTile({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    final isEmpty = value.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
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
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
          ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  final bool isLast;
  final bool isNext;

  const _BookingCard({
    required this.booking,
    this.isLast = false,
    this.isNext = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isNext ? Colors.deepPurple : AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.calendar,
                  size: 15,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 26),
                  child: Container(
                    width: 1,
                    color: isNext ? Colors.deepPurple : Colors.black12,
                    margin: const EdgeInsets.only(top: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 1, color: Colors.black12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 4,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Agendamento',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                '${DateFormatters.weekdayDayMonth(booking.scheduledFor, context)} às ${DateFormat('HH:mm').format(booking.scheduledFor)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              booking.status,
                            ).withAlpha(25),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Text(
                            _getStatusText(booking.status),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: _getStatusColor(booking.status),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '${DateFormat('HH:mm').format(booking.scheduledFor)} - ${booking.duration}min',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          moneyFormat(context, booking.totalPrice.toString()),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    if (booking.notes != null && booking.notes!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            LucideIcons.messageSquare,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              booking.notes!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SCHEDULED':
        return Colors.blue;
      case 'CONFIRMED':
        return Colors.green;
      case 'COMPLETED':
        return Colors.blue;
      case 'CANCELLED':
        return Colors.red;
      case 'NO_SHOW':
        return Colors.purple;
      case 'RESCHEDULED':
        return Colors.orange;
      case 'BLOCK':
        return Colors.black54;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'SCHEDULED':
        return 'Reservado';
      case 'CONFIRMED':
        return 'Confirmado';
      case 'COMPLETED':
        return 'Concluído';
      case 'CANCELLED':
        return 'Cancelado';
      case 'NO_SHOW':
        return 'Não compareceu';
      case 'RESCHEDULED':
        return 'Reagendado';
      case 'BLOCK':
        return 'Bloqueado';
      default:
        return status;
    }
  }
}

class _StatusTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }
}
