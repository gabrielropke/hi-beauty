import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_dropdown.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/core/components/app_toggle_switch.dart';
import 'package:hibeauty/core/components/custom_app_bar.dart';
import 'package:hibeauty/features/business/data/model.dart';
import 'package:hibeauty/features/business/views/business_roles/presentation/bloc/business_roles_bloc.dart';
import 'package:hibeauty/features/business/views/business_roles/presentation/components/role_card.dart';
import 'package:hibeauty/features/business/views/business_roles/presentation/components/terms_conditions.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BusinessRolesScreen extends StatelessWidget {
  const BusinessRolesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          BusinessRolesBloc(context)..add(BusinessRolesLoadRequested()),
      child: const _BusinessRolesView(),
    );
  }
}

class _BusinessRolesView extends StatefulWidget {
  const _BusinessRolesView();

  @override
  State<_BusinessRolesView> createState() => _BusinessRolesViewState();
}

class _BusinessRolesViewState extends State<_BusinessRolesView> {
  final GlobalKey<_ScheduleSettingsBodyState> _scheduleKey = GlobalKey();
  final GlobalKey<_ChangePoliciesBodyState> _changePoliciesKey = GlobalKey();
  final GlobalKey<_ManualApprovalBodyState> _manualApprovalKey = GlobalKey();
  final GlobalKey<_ClientLimitsBodyState> _clientLimitsKey = GlobalKey();
  final GlobalKey<_TermsConditionsBodyState> _termsKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<BusinessRolesBloc, BusinessRolesState>(
        builder: (context, state) {
          return switch (state) {
            BusinessRolesLoading _ => AppLoader(),
            BusinessRolesLoaded s => _loaded(context, s),
            BusinessRolesState() => AppLoader(),
          };
        },
      ),
    );
  }

  Widget _loaded(BuildContext context, BusinessRolesLoaded state) {
    final l10n = AppLocalizations.of(context)!;
    final ScrollController scrollController = ScrollController();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: l10n.rulesTitle,
                controller: scrollController,
                backgroundColor: Colors.white,
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Text(
                        l10n.rulesTitle,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        l10n.rulesSubtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(),
                      RoleCard(
                        icon: LucideIcons.clock,
                        title: l10n.scheduleSettingsTitle,
                        subtitle: l10n.scheduleSettingsSubtitle,
                        body: _ScheduleSettingsBody(
                          key: _scheduleKey,
                          initialSlotValue: state.roles.businessRules.timeSlotIncrement,
                          initialMinAdvance: state.roles.businessRules.minimumAdvanceBooking.toString(),
                          initialBookingWindow: state.roles.businessRules.bookingWindow.toString(),
                          onSlotValueChanged: (value) {},
                          onMinAdvanceChanged: (value) {},
                          onBookingWindowChanged: (value) {},
                        ),
                      ),
                      SizedBox(),
                      RoleCard(
                        icon: LucideIcons.calendar,
                        title: l10n.cancellationSectionTitle,
                        subtitle: l10n.cancellationSectionSubtitle,
                        body: _ChangePoliciesBody(
                          key: _changePoliciesKey,
                          initialAllowReschedule: state.roles.businessRules.allowsRescheduling,
                          initialAllowCancel: state.roles.businessRules.allowsCancellation,
                          initialMinCancel: state.roles.businessRules.cancellationTimeLimit.toString(),
                        ),
                      ),
                      RoleCard(
                        icon: LucideIcons.circleCheckBig,
                        title: l10n.approvalTitle,
                        subtitle: l10n.approvalSubtitle,
                        body: _ManualApprovalBody(
                          key: _manualApprovalKey,
                          initialRequireApproval: state.roles.businessRules.requiresConfirmation,
                          initialApprovalDeadline: (state.roles.businessRules.confirmationTimeLimit ?? 24).toString(),
                        ),
                      ),
                      RoleCard(
                        icon: LucideIcons.users,
                        title: l10n.clientLimitsTitle,
                        subtitle: l10n.clientLimitsSubtitle,
                        body: _ClientLimitsBody(
                          key: _clientLimitsKey,
                          initialAllowMultiple: state.roles.businessRules.allowsMultipleBookingsPerDay,
                          initialDailyLimit: state.roles.businessRules.maxBookingsPerClientPerDay?.toString() ?? '1',
                          initialAllowHolidays: state.roles.businessRules.allowsHolidayBookings,
                        ),
                      ),
                      RoleCard(
                        icon: LucideIcons.shield,
                        title: l10n.termsConditionsTitle,
                        subtitle: l10n.termsConditionsSubtitle,
                        body: _TermsConditionsBody(
                          state: state,
                          key: _termsKey,
                          initialRequireTerms: state.roles.businessRules.requiresTermsAcceptance,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: BlocBuilder<BusinessRolesBloc, BusinessRolesState>(
            builder: (context, state) {
              final loading = state is BusinessRolesLoaded
                  ? state.loading
                  : false;
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.black.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: AppButton(
                  label: l10n.save,
                  loading: loading,
                  function: () {
                    if (state is BusinessRolesLoaded) {
                      final currentRules = state.roles.businessRules;
                      
                      // Coletar valores dos formulários
                      final scheduleState = _scheduleKey.currentState;
                      final changePoliciesState = _changePoliciesKey.currentState;
                      final manualApprovalState = _manualApprovalKey.currentState;
                      final clientLimitsState = _clientLimitsKey.currentState;
                      final termsState = _termsKey.currentState;
                      
                      context.read<BusinessRolesBloc>().add(
                        BusinessRulesSaveRequested(
                          businessRules: BusinessRulesModel(
                            id: currentRules.id,
                            timeSlotIncrement: scheduleState?._slotValue ?? currentRules.timeSlotIncrement,
                            bookingWindow: int.tryParse(scheduleState?._bookingWindowCtrl.text ?? '') ?? currentRules.bookingWindow,
                            minimumAdvanceBooking: int.tryParse(scheduleState?._minAdvanceCtrl.text ?? '') ?? currentRules.minimumAdvanceBooking,
                            preServiceBuffer: currentRules.preServiceBuffer,
                            postServiceBuffer: currentRules.postServiceBuffer,
                            requiresTermsAcceptance: termsState?._requireTermsAcceptance ?? currentRules.requiresTermsAcceptance,
                            termsAndConditions: currentRules.termsAndConditions,
                            requiresConfirmation: manualApprovalState?._requireManualApproval ?? currentRules.requiresConfirmation,
                            confirmationTimeLimit: manualApprovalState?._requireManualApproval == true 
                                ? int.tryParse(manualApprovalState?._approvalDeadlineCtrl.text ?? '') 
                                : currentRules.confirmationTimeLimit,
                            cancellationTimeLimit: int.tryParse(changePoliciesState?._minCancelCtrl.text ?? '') ?? currentRules.cancellationTimeLimit,
                            allowsRescheduling: changePoliciesState?._allowReschedule ?? currentRules.allowsRescheduling,
                            allowsCancellation: changePoliciesState?._allowCancel ?? currentRules.allowsCancellation,
                            allowsMultipleBookingsPerDay: clientLimitsState?._allowMultiple ?? currentRules.allowsMultipleBookingsPerDay,
                            maxBookingsPerClientPerDay: clientLimitsState?._allowMultiple == true 
                                ? (() {
                                    final parsed = int.tryParse(clientLimitsState?._dailyLimitCtrl.text ?? '');
                                    if (parsed != null && parsed >= 1) return parsed;
                                    return currentRules.maxBookingsPerClientPerDay ?? 1;
                                  })()
                                : null,
                            allowsHolidayBookings: clientLimitsState?._allowHolidays ?? currentRules.allowsHolidayBookings,
                            businessId: currentRules.businessId,
                            createdAt: currentRules.createdAt,
                            updatedAt: currentRules.updatedAt,
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ScheduleSettingsBody extends StatefulWidget {
  final int initialSlotValue;
  final String initialMinAdvance;
  final String initialBookingWindow;
  final Function(int) onSlotValueChanged;
  final Function(String) onMinAdvanceChanged;
  final Function(String) onBookingWindowChanged;
  
  const _ScheduleSettingsBody({
    super.key,
    required this.initialSlotValue,
    required this.initialMinAdvance,
    required this.initialBookingWindow,
    required this.onSlotValueChanged,
    required this.onMinAdvanceChanged,
    required this.onBookingWindowChanged,
  });

  @override
  State<_ScheduleSettingsBody> createState() => _ScheduleSettingsBodyState();
}

class _ScheduleSettingsBodyState extends State<_ScheduleSettingsBody> {
  late final TextEditingController _minAdvanceCtrl;
  late final TextEditingController _bookingWindowCtrl;

  late int _slotValue;

  final List<Map<String, Object?>> _slotItems = const [
    {'label': 'A cada 15 min', 'value': 15},
    {'label': 'A cada 30 min', 'value': 30},
    {'label': 'A cada 1 hora', 'value': 60},
  ];

  @override
  void initState() {
    super.initState();
    _minAdvanceCtrl = TextEditingController(text: widget.initialMinAdvance);
    _bookingWindowCtrl = TextEditingController(text: widget.initialBookingWindow);
    _slotValue = widget.initialSlotValue;
    _minAdvanceCtrl.addListener(_onMinAdvanceChange);
    _bookingWindowCtrl.addListener(_onBookingWindowChange);
  }

  void _onMinAdvanceChange() {
    if (mounted) {
      setState(() {});
      widget.onMinAdvanceChanged(_minAdvanceCtrl.text);
    }
  }

  void _onBookingWindowChange() {
    if (mounted) {
      widget.onBookingWindowChanged(_bookingWindowCtrl.text);
    }
  }

  @override
  void dispose() {
    _minAdvanceCtrl.removeListener(_onMinAdvanceChange);
    _bookingWindowCtrl.removeListener(_onBookingWindowChange);
    _minAdvanceCtrl.dispose();
    _bookingWindowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      spacing: 26,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDropdown(
          title: l10n.timeIntervalLabel,
          items: _slotItems,
          labelKey: 'label',
          valueKey: 'value',
          selectedValue: _slotValue,
          onChanged: (v) {
            if (v is int) {
              setState(() => _slotValue = v);
              widget.onSlotValueChanged(v);
            }
          },
          placeholder: const Text(
            'Selecione',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          borderRadius: 10,
          fillColor: Colors.white,
        ),
        _NumberField(
          controller: _minAdvanceCtrl,
          hint: 'Ex.: 120 (horas)',
          title: l10n.minAdvanceLabel,
          description:
              _minAdvanceCtrl.text.isEmpty || _minAdvanceCtrl.text == '0'
              ? 'Clientes podem agendar a qualquer momento'
              : 'Clientes devem agendar com pelo menos ${_minAdvanceCtrl.text} horas de antecedência',
        ),
        _NumberField(
          controller: _bookingWindowCtrl,
          hint: 'Ex.: 30 (dias)',
          title: l10n.bookingWindowLabel,
          description: 'Até quantos dias no futuro os clientes podem agendar',
        ),
      ],
    );
  }
}

class _NumberField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String title;
  final String description;
  const _NumberField({
    required this.controller,
    required this.hint,
    required this.title,
    this.description = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextformfield(
          hintText: hint,
          title: title,
          controller: controller,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
        ),
        Text(
          description,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}

class _ChangePoliciesBody extends StatefulWidget {
  final bool initialAllowReschedule;
  final bool initialAllowCancel;
  final String initialMinCancel;
  
  const _ChangePoliciesBody({
    super.key,
    required this.initialAllowReschedule,
    required this.initialAllowCancel,
    required this.initialMinCancel,
  });
  @override
  State<_ChangePoliciesBody> createState() => _ChangePoliciesBodyState();
}

class _ChangePoliciesBodyState extends State<_ChangePoliciesBody> {
  late bool _allowReschedule;
  late bool _allowCancel;
  late final TextEditingController _minCancelCtrl;

  @override
  void initState() {
    super.initState();
    _allowReschedule = widget.initialAllowReschedule;
    _allowCancel = widget.initialAllowCancel;
    _minCancelCtrl = TextEditingController(text: widget.initialMinCancel);
    _minCancelCtrl.addListener(_onCtrlChange);
  }

  void _onCtrlChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _minCancelCtrl.removeListener(_onCtrlChange);
    _minCancelCtrl.dispose();
    super.dispose();
  }

  int get _minutes {
    final v = int.tryParse(_minCancelCtrl.text.trim());
    return v == null || v < 0 ? 0 : v;
  }

  String get _formattedCancellationRequirement {
    final m = _minutes;
    if (m < 60) {
      return 'Cancelamentos devem ser feitos com $m min de antecedência';
    }
    final hours = m ~/ 60;
    final rem = m % 60;
    final hoursLabel = hours == 1 ? '1 hora' : '$hours horas';
    if (rem == 0) {
      return 'Cancelamentos devem ser feitos com $hoursLabel de antecedência';
    }
    return 'Cancelamentos devem ser feitos com $hoursLabel e $rem min de antecedência';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      spacing: 22,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PolicyToggle(
          title: l10n.allowRescheduleLabel,
          subtitle: l10n.allowRescheduleDescription,
          value: _allowReschedule,
          onChanged: (v) => setState(() => _allowReschedule = v),
        ),
        _PolicyToggle(
          title: l10n.allowCancelLabel,
          subtitle: l10n.allowCancelDescription,
          value: _allowCancel,
          onChanged: (v) => setState(() => _allowCancel = v),
        ),
        if (_allowCancel)
          Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.minCancelTimeLabel,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: _NumberField(
                      controller: _minCancelCtrl,
                      hint: '',
                      title: '',
                    ),
                  ),
                  Text(
                    l10n.minCancelTimeHours,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              Text(
                _formattedCancellationRequirement,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _ManualApprovalBody extends StatefulWidget {
  final bool initialRequireApproval;
  final String initialApprovalDeadline;
  
  const _ManualApprovalBody({
    super.key,
    required this.initialRequireApproval,
    required this.initialApprovalDeadline,
  });
  @override
  State<_ManualApprovalBody> createState() => _ManualApprovalBodyState();
}

class _ManualApprovalBodyState extends State<_ManualApprovalBody> {
  late bool _requireManualApproval;
  late final TextEditingController _approvalDeadlineCtrl;

  @override
  void initState() {
    super.initState();
    _requireManualApproval = widget.initialRequireApproval;
    _approvalDeadlineCtrl = TextEditingController(text: widget.initialApprovalDeadline);
    _approvalDeadlineCtrl.addListener(_onApprovalDeadlineChange);
  }

  void _onApprovalDeadlineChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _approvalDeadlineCtrl.removeListener(_onApprovalDeadlineChange);
    _approvalDeadlineCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      spacing: 18,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PolicyToggle(
          title: l10n.requireManualApprovalLabel,
          subtitle: l10n.requireManualApprovalDescription,
          value: _requireManualApproval,
          onChanged: (v) => setState(() => _requireManualApproval = v),
        ),
        if (_requireManualApproval)
          Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Prazo para aprovar agendamentos',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: _NumberField(
                      controller: _approvalDeadlineCtrl,
                      hint: 'Ex.: 2',
                      title: '',
                    ),
                  ),
                  Text(
                    l10n.minCancelTimeHours,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}

class _ClientLimitsBody extends StatefulWidget {
  final bool initialAllowMultiple;
  final String initialDailyLimit;
  final bool initialAllowHolidays;
  
  const _ClientLimitsBody({
    super.key,
    required this.initialAllowMultiple,
    required this.initialDailyLimit,
    required this.initialAllowHolidays,
  });
  @override
  State<_ClientLimitsBody> createState() => _ClientLimitsBodyState();
}

class _ClientLimitsBodyState extends State<_ClientLimitsBody> {
  late bool _allowMultiple;
  late bool _allowHolidays;
  late final TextEditingController _dailyLimitCtrl;

  @override
  void initState() {
    super.initState();
    _allowMultiple = widget.initialAllowMultiple;
    _allowHolidays = widget.initialAllowHolidays;
    _dailyLimitCtrl = TextEditingController(text: widget.initialDailyLimit);
    _dailyLimitCtrl.addListener(_onDailyLimitChange);
  }

  void _onDailyLimitChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _dailyLimitCtrl.removeListener(_onDailyLimitChange);
    _dailyLimitCtrl.dispose();
    super.dispose();
  }

  int get _limitParsed {
    final v = int.tryParse(_dailyLimitCtrl.text.trim());
    if (v == null || v <= 0) return 0;
    return v;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String currentLabel;
    if (_limitParsed == 0) {
      currentLabel = l10n.unlimitedLabel;
    } else if (_limitParsed == 1) {
      currentLabel = l10n.onePerDayLabel;
    } else {
      currentLabel = '$_limitParsed ${l10n.perDaySuffix}';
    }

    return Column(
      spacing: 22,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PolicyToggle(
          title: l10n.multiplePerDayLabel,
          subtitle: l10n.multiplePerDayDescription,
          value: _allowMultiple,
          onChanged: (v) => setState(() => _allowMultiple = v),
        ),
        if (_allowMultiple)
          Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NumberField(
                controller: _dailyLimitCtrl,
                hint: 'Ex.: 3',
                title: l10n.dailyLimitLabel,
              ),

              Row(
                spacing: 12,
                children: [
                  Text(
                    l10n.currentValueLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      border: Border.all(color: Colors.blue, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      currentLabel,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ),
        _PolicyToggle(
          title: l10n.holidayBookingsLabel,
          subtitle: l10n.holidayBookingsDescription,
          value: _allowHolidays,
          onChanged: (v) => setState(() => _allowHolidays = v),
        ),
      ],
    );
  }
}

class _TermsConditionsBody extends StatefulWidget {
  final BusinessRolesLoaded state;
  final bool initialRequireTerms;
  
  const _TermsConditionsBody({
    super.key,
    required this.state,
    required this.initialRequireTerms,
  });
  @override
  State<_TermsConditionsBody> createState() => _TermsConditionsBodyState();
}

class _TermsConditionsBodyState extends State<_TermsConditionsBody> {
  late bool _requireTermsAcceptance;

  @override
  void initState() {
    super.initState();
    _requireTermsAcceptance = widget.initialRequireTerms;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      spacing: 18,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PolicyToggle(
          title: l10n.requireTermsLabel,
          subtitle: l10n.requireTermsDescription,
          value: _requireTermsAcceptance,
          onChanged: (v) => setState(() => _requireTermsAcceptance = v),
        ),
        if (_requireTermsAcceptance)
          TermsConditionsModal(roles: widget.state.roles),
      ],
    );
  }
}

class _PolicyToggle extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _PolicyToggle({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Expanded(
          child: Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // título opcional (mantido oculto)
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        AppToggleSwitch(isTrue: value, function: () => onChanged(!value)),
      ],
    );
  }
}
