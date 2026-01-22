import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/bloc/add_schedule_bloc.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/components/customers_list.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/components/select_services_sheet.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/components/team_members_list.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum AddScheduleTypeItem { customer, services, member }

String getAddItemTitle(AddScheduleTypeItem type) {
  switch (type) {
    case AddScheduleTypeItem.customer:
      return 'Cliente';
    case AddScheduleTypeItem.services:
      return 'Serviços';
    case AddScheduleTypeItem.member:
      return 'Profissional';
  }
}

String getAddItemButtonText(AddScheduleTypeItem type) {
  switch (type) {
    case AddScheduleTypeItem.customer:
      return 'Adicionar cliente';
    case AddScheduleTypeItem.services:
      return 'Adicionar serviço';
    case AddScheduleTypeItem.member:
      return 'Escolher profissional';
  }
}

class AddScheduleItem extends StatelessWidget {
  final AddScheduleLoaded state;
  final AddScheduleTypeItem type;
  const AddScheduleItem({super.key, required this.type, required this.state});

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      AddScheduleTypeItem.customer => CustomerAddItem(state: state),
      AddScheduleTypeItem.services => ServicesAddItem(state: state),
      AddScheduleTypeItem.member => MemberAddItem(state: state),
    };
  }
}

class CustomerAddItem extends StatelessWidget {
  final AddScheduleLoaded state;

  const CustomerAddItem({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return state.customerSelected == null
        ? GestureDetector(
            onTap: () =>
                showSelectCustomerSheet(context: context, state: state),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 26,
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getAddItemButtonText(AddScheduleTypeItem.customer),
                        ),
                        Text(
                          'Crie um cliente se não há cadastro',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(LucideIcons.userRoundPlus300, size: 20),
                    ),
                  ],
                ),
              ),
            ),
          )
        : GestureDetector(
            onTap: () =>
                showSelectCustomerSheet(context: context, state: state),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 26,
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(state.customerSelected!.name),
                        Text(
                          state.customerSelected!.email,
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        if (state.booking?.status != 'COMPLETED') ...[
                        SizedBox(height: 10),
                        
                        Text(
                          'Clique para alterar o cliente',
                          style: TextStyle(fontSize: 12, color: Colors.blue),
                        ),]
                      ],
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          state.customerSelected!.name.isNotEmpty
                              ? state.customerSelected!.name[0].toUpperCase()
                              : '',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class ServicesAddItem extends StatelessWidget {
  final AddScheduleLoaded state;

  const ServicesAddItem({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final hasSelectedItems =
        state.selectedServices.isNotEmpty ||
        state.selectedProducts.isNotEmpty ||
        state.selectedCombos.isNotEmpty;

    if (hasSelectedItems) {
      return _ServicesWithItemsList(state: state);
    } else {
      return _ServicesEmptyState(state: state);
    }
  }
}

class _ServicesWithItemsList extends StatelessWidget {
  final AddScheduleLoaded state;

  const _ServicesWithItemsList({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getAddItemTitle(AddScheduleTypeItem.services),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        // Lista de itens selecionados
        Column(
          spacing: 12,
          children: [
            // Serviços
            for (final service in state.selectedServices)
              Row(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                service.duration >= 61
                                    ? '${(service.duration / 61).floor()}h${service.duration % 61 > 0 ? ' ${service.duration % 61} min' : ''}'
                                    : '${service.duration} min',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'R\$ ${service.price.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ],
              ),
            // Produtos
            for (final product in state.selectedProducts)
              Row(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            product.name,
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
                  ),
                  Text(
                    'R\$ ${product.price.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ],
              ),
            // Combos
            for (final combo in state.selectedCombos)
              Row(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.purple.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                combo.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                combo.totalDuration >= 61
                                    ? '${(combo.totalDuration / 61).floor()}h${combo.totalDuration % 61 > 0 ? ' ${combo.totalDuration % 61} min' : ''}'
                                    : '${combo.totalDuration} min',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'R\$ ${combo.price.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ],
              ),
          ],
        ),
        if (state.booking?.status != 'COMPLETED')
        AppButton(
          height: 36,
          padding: EdgeInsets.symmetric(horizontal: 14),
          preffixIcon: Icon(LucideIcons.badgePlus300, size: 20),
          label: 'Editar serviços',
          fillColor: Colors.transparent,
          labelStyle: TextStyle(),
          spacing: 8,
          borderColor: Colors.black38,
          borderWidth: 0.5,
          mainAxisSize: MainAxisSize.min,
          function: () =>
              showSelectServicesSheet(context: context, state: state),
        ),
      ],
    );
  }
}

class _ServicesEmptyState extends StatelessWidget {
  final AddScheduleLoaded state;

  const _ServicesEmptyState({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getAddItemTitle(AddScheduleTypeItem.services),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
            child: Column(
              children: [
                Icon(LucideIcons.shoppingBasket200, size: 50),
                SizedBox(height: 16),
                Text(
                  'Adicione um serviço para continuar',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                SizedBox(height: 12),
                AppButton(
                  height: 36,
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  preffixIcon: Icon(LucideIcons.badgePlus300, size: 20),
                  label: getAddItemButtonText(AddScheduleTypeItem.services),
                  fillColor: Colors.transparent,
                  labelStyle: TextStyle(),
                  spacing: 8,
                  borderColor: Colors.black38,
                  borderWidth: 0.5,
                  mainAxisSize: MainAxisSize.min,
                  function: () =>
                      showSelectServicesSheet(context: context, state: state),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MemberAddItem extends StatelessWidget {
  final AddScheduleLoaded state;

  const MemberAddItem({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return state.memberSelected == null
        ? Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getAddItemTitle(AddScheduleTypeItem.member),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              AppButton(
                height: 36,
                padding: EdgeInsets.symmetric(horizontal: 14),
                preffixIcon: Icon(LucideIcons.badgePlus300, size: 20),
                label: getAddItemButtonText(AddScheduleTypeItem.member),
                fillColor: Colors.transparent,
                labelStyle: TextStyle(),
                spacing: 8,
                borderColor: Colors.black38,
                borderWidth: 0.5,
                mainAxisSize: MainAxisSize.min,
                function: () =>
                    showSelectTeamMemberSheet(context: context, state: state),
              ),
            ],
          )
        : GestureDetector(
            onTap: () =>
                showSelectTeamMemberSheet(context: context, state: state),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 26,
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(state.memberSelected!.name),
                        Text(
                          state.memberSelected!.email,
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        if (state.booking?.status != 'COMPLETED') ...[SizedBox(height: 10),
                        Text(
                          'Clique para alterar o profissional',
                          style: TextStyle(fontSize: 12, color: Colors.blue),
                        ),]
                        
                      ],
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: parseColor(state.memberSelected!.themeColor).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: state.memberSelected!.profileImageUrl != null
                            ? ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      state.memberSelected!.profileImageUrl!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) => Text(
                                    state.memberSelected!.name.isNotEmpty
                                        ? state.memberSelected!.name[0]
                                              .toUpperCase()
                                        : '',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: parseColor(state.memberSelected!.themeColor),
                                    ),
                                  ),
                                ),
                              )
                            : Text(
                                state.memberSelected!.name.isNotEmpty
                                    ? state.memberSelected!.name[0]
                                          .toUpperCase()
                                    : '',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: parseColor(state.memberSelected!.themeColor),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
