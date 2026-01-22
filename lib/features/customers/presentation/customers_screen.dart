import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/hi_mobile.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/core/components/custom_app_bar.dart';
import 'package:hibeauty/core/constants/app_images.dart';
import 'package:hibeauty/core/constants/global_top_infos.dart';
import 'package:hibeauty/features/customers/presentation/bloc/customers_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:hibeauty/features/customers/data/model.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'components/filters_drawer.dart';
import 'components/customers_list.dart';
import 'add_customer.dart';

class CustomersScreen extends StatelessWidget {
  final bool? buttonBottomEnabled;
  const CustomersScreen({super.key, this.buttonBottomEnabled = false});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CustomersBloc(context)..add(CustomersLoadRequested()),
      child: CustomersView(buttonBottomEnabled: buttonBottomEnabled),
    );
  }
}

class CustomersView extends StatefulWidget {
  final bool? buttonBottomEnabled;
  const CustomersView({super.key, this.buttonBottomEnabled = false});
  @override
  State<CustomersView> createState() => _CustomersViewState();
}

class _CustomersViewState extends State<CustomersView> {
  final ScrollController _scrollController = ScrollController();
  late final TextEditingController _searchCtrl;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _sortOrder = 'name_asc';
  final Set<bool> _selectedActiveStatus = {};
  bool popupClose = false;
  bool _isShowingPopup = false;
  Timer? _popupCheckTimer;

  static const List<bool> activeStatusOptions = [true, false];

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
    _updatePopupState();
    _startPopupStateChecker();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollController.dispose();
    _popupCheckTimer?.cancel();
    super.dispose();
  }

  void _updatePopupState() {
    final newState = shouldShowSignature() || shouldShowCompleteBusinessData();
    if (_isShowingPopup != newState) {
      setState(() {
        _isShowingPopup = newState;
      });
    }
  }

  void _startPopupStateChecker() {
    _popupCheckTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
      if (mounted) {
        _updatePopupState();
      }
    });
  }

  List<CustomerModel> _filtered(CustomersLoaded state) {
    final q = _searchCtrl.text.trim().toLowerCase();
    var list = state.customers.customers.where((m) {
      final matchesQuery =
          q.isEmpty ||
          m.name.toLowerCase().contains(q) ||
          m.email.toLowerCase().contains(q) ||
          m.phone.toLowerCase().contains(q);
      final matchesActiveStatus =
          _selectedActiveStatus.isEmpty ||
          _selectedActiveStatus.contains(m.isActive);
      return matchesQuery && matchesActiveStatus;
    }).toList();

    // ordenação expandida
    switch (_sortOrder) {
      case 'name_asc':
        list.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;
      case 'name_desc':
        list.sort(
          (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
        );
        break;
      case 'email_asc':
        list.sort(
          (a, b) => a.email.toLowerCase().compareTo(b.email.toLowerCase()),
        );
        break;
      case 'email_desc':
        list.sort(
          (a, b) => b.email.toLowerCase().compareTo(a.email.toLowerCase()),
        );
        break;
      case 'date_newest':
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'date_oldest':
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }
    return list;
  }

  void _toggleActiveStatus(bool value) {
    setState(() {
      if (_selectedActiveStatus.contains(value)) {
        _selectedActiveStatus.remove(value);
      } else {
        _selectedActiveStatus.add(value);
      }
    });
  }

  void _clearFilters() {
    setState(() {
      _sortOrder = 'name_asc';
      _selectedActiveStatus.clear();
    });
  }

  void _showFiltersModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => BlocProvider.value(
        value: BlocProvider.of<CustomersBloc>(context),
        child: FiltersDrawer(
          buttonBottomEnabled: widget.buttonBottomEnabled,
          sortOrder: _sortOrder,
          onChangeSort: (v) => setState(() => _sortOrder = v),
          selectedActiveStatus: _selectedActiveStatus,
          onToggleActiveStatus: _toggleActiveStatus,
          onClear: _clearFilters,
          activeStatusOptions: activeStatusOptions,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: BlocBuilder<CustomersBloc, CustomersState>(
        builder: (context, state) => switch (state) {
          CustomersLoading _ => const AppLoader(),
          CustomersLoaded s => _loaded(s, l10n, context), // passar context
          CustomersState() => const AppLoader(),
        },
      ),
    );
  }

  Widget _loaded(
    CustomersLoaded state,
    AppLocalizations l10n,
    BuildContext context,
  ) {
    final members = _filtered(state);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          if (widget.buttonBottomEnabled == true)
          exibitionTopPopup(context),
          CustomAppBar(
            safeAreaTopOn: widget.buttonBottomEnabled == true ? !_isShowingPopup : true,
            title: 'Clientes',
            controller: _scrollController,
            backgroundColor: Colors.white,
            actions: [
              AppButton(
                width: 120,
                height: 30,
                label: l10n.add,
                fillColor: Colors.white,
                labelStyle: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
                borderColor: Colors.black12,
                suffixIcon: Icon(LucideIcons.plus300, size: 16),
                function: () {
                  showAddCustomerSheet(
                    context: context,
                    state: state,
                    l10n: AppLocalizations.of(context)!,
                  );
                },
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Text(
                    'Clientes',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  if (!isConfigurationComplete() && popupClose == false) ...[
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Configure seu perfil para\nque os clientes reservem\nonline',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(LucideIcons.x300),
                                      onPressed: () {
                                        setState(() {
                                          popupClose = true;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Ganhe tempo e deixe seus clientes agendarem online 24 horas por dia!',
                                ),
                                SizedBox(height: 12),
                                AppButton(
                                  width: 140,
                                  label: 'Saiba mais',
                                  labelColor: Colors.black,
                                  fillColor: Colors.white,
                                  borderColor: Colors.grey[300],
                                  function: () =>
                                      context.push(AppRoutes.businessConfig),
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),

                        // Meia lua azul no canto inferior direito
                        Positioned(
                          bottom: -200,
                          left: 140,
                          child: Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.withValues(alpha: 0.1),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -60,
                          right: -15,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: Image.asset(
                            AppImages.whatsappExample,
                            fit: BoxFit.cover,
                            width: 80,
                          ),
                        ),
                      ],
                    ),
                  ],
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: AppTextformfield(
                          controller: _searchCtrl,
                          borderRadius: 32,
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
                      ),
                      GestureDetector(
                        onTap: () => _showFiltersModal(context),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.black12, width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(11.5),
                            child: Icon(
                              LucideIcons.gitPullRequestDraft300,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  CustomersList(customers: members, state: state),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
