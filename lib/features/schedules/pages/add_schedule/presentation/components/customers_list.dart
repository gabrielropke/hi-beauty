import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/features/customers/data/model.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/bloc/add_schedule_bloc.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'customer_tile.dart';

Future<void> showSelectCustomerSheet({
  required BuildContext context,
  required AddScheduleLoaded state,
  CustomerModel? customer,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    useSafeArea: true,
    barrierColor: Colors.transparent,
    clipBehavior: Clip.hardEdge,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
    ),
    builder: (ctx) {
      return BlocProvider.value(
        value: context.read<AddScheduleBloc>(),
        child: Container(
          color: Colors.white,
          child: AddScheduleCustomersList(
            state: state,
          ),
        ),
      );
    },
  );
}

class AddScheduleCustomersList extends StatefulWidget {
  final AddScheduleLoaded state;
  const AddScheduleCustomersList({
    super.key,
    required this.state,
  });

  @override
  State<AddScheduleCustomersList> createState() =>
      _AddScheduleCustomersListState();
}

class _AddScheduleCustomersListState extends State<AddScheduleCustomersList> {
  final ScrollController _controller = ScrollController();
  late final TextEditingController _searchCtrl;
  bool _showHeaderTitle = false;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
    _controller.addListener(() {
      final shouldShow = _controller.offset > 8;
      if (shouldShow != _showHeaderTitle) {
        setState(() => _showHeaderTitle = shouldShow);
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  List<CustomerModel> _filteredCustomers(List<CustomerModel> customers) {
    final query = _searchCtrl.text.trim().toLowerCase();

    return customers.where((customer) {
      return customer.name.toLowerCase().contains(query) ||
          customer.email.toLowerCase().contains(query) ||
          customer.phone.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocBuilder<AddScheduleBloc, AddScheduleState>(
        builder: (context, state) {
          if (state is! AddScheduleLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final customers = state.customers;
          final filteredCustomers = _filteredCustomers(customers);

          return Column(
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
                          child: Text(
                            'Selecione um cliente',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
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
                child: Divider(thickness: 1, color: Colors.grey[300], height: 5),
              ),

              Expanded(
                child: SingleChildScrollView(
                  controller: _controller,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selecione um cliente',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          final result = await context.push(AppRoutes.customers);
                          // Se voltou da tela de customers, recarregar a lista
                          if (result != null && context.mounted) {
                            context.read<AddScheduleBloc>().add(RefreshCustomers());
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 20,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  spacing: 4,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Não encontrou?'),
                                    Text(
                                      'Clique aqui para adicionar um\nnovo cliente',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary.withValues(
                                      alpha: 0.2,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    LucideIcons.userRoundPlus300,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      AppTextformfield(
                        controller: _searchCtrl,
                        borderRadius: 12,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 4),
                          child: Icon(
                            LucideIcons.search,
                            size: 18,
                            color: Colors.black54,
                          ),
                        ),
                        hintText: 'Buscar clientes',
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: AlignmentGeometry.centerLeft,
                        child: AppButton(
                          mainAxisSize: MainAxisSize.min,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          height: 30,
                          label: 'Clique para atualizar a lista',
                          fillColor: Colors.white,
                          labelStyle: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                          borderColor: Colors.black12,
                          suffixIcon: Icon(LucideIcons.plus300, size: 16),
                          function: () async {
                            context
                                .read<AddScheduleBloc>()
                                .add(RefreshCustomers());
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      if (customers.isEmpty && _searchCtrl.text.isEmpty)
                        Text(
                          'Nenhum cliente encontrado.',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),
                      if (filteredCustomers.isEmpty && _searchCtrl.text.isNotEmpty)
                        Text(
                          'Nenhum resultado encontrado',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        )
                      else
                        for (int i = 0; i < filteredCustomers.length; i++) ...[
                          CustomerTile(
                            customer: filteredCustomers[i],
                            state: state,
                            bcontext: context,
                          ),
                          if (i < filteredCustomers.length - 1)
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
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
