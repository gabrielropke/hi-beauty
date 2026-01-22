import 'package:flutter/foundation.dart';
import 'package:hibeauty/core/services/subscription/data/data_source.dart';
import 'package:hibeauty/core/services/subscription/data/model.dart';

class SubscriptionData {
  static SubscriptionStatusModel? get _s =>
      SubscriptionService().currentSubscription;
  static MySubscriptionModel? get _ms => SubscriptionService().mySubscription;

  // SubscriptionStatus data
  static bool get isSubscriber => _s?.isSubscriber ?? false;
  static bool get isTrialing => _s?.isTrialing ?? false;
  static bool get isActive => _s?.isActive ?? false;
  static bool get shouldShowSubscriptionModal =>
      _s?.shouldShowSubscriptionModal ?? true;
  static String get status => _s?.status ?? 'INACTIVE';
  static SubscriptionStatus get statusEnum =>
      _s?.statusEnum ?? SubscriptionStatus.INACTIVE;
  static String? get trialEndsAt => _s?.trialEndsAt;
  static int get trialDaysRemaining => _s?.trialDaysRemaining ?? 0;
  static String? get actionRequired => _s?.actionRequired;
  static int get totalTeamMembers => _s?.totalTeamMembers ?? 0;

  // SubscriptionStatus data - Billing Credits
  static int get billingCreditsAvailable => _s?.billingCredits?.available ?? 0;
  static bool get billingCreditsHasDiscount =>
      _s?.billingCredits?.hasDiscount ?? false;
  static double get billingCreditsDiscountPercentage =>
      _s?.billingCredits?.discountPercentage ?? 0.0;
  static bool get billingCreditsNextBillingWillBeFree =>
      _s?.billingCredits?.nextBillingWillBeFree ?? false;

  // MySubscription data - Subscription Info
  static String get subscriptionId => _ms?.subscription.id ?? '';
  static String get subscriptionStatus =>
      _ms?.subscription.status ?? 'INACTIVE';
  static DateTime? get createdAt => _ms?.subscription.createdAt != null
      ? _ms!.subscription.createdAtDate
      : null;
  static DateTime? get updatedAt => _ms?.subscription.updatedAt != null
      ? _ms!.subscription.updatedAtDate
      : null;

  // MySubscription data - Seats
  static int get ownerSeats => _ms?.seats.owner ?? 0;
  static int get teamMemberSeats => _ms?.seats.teamMembers ?? 0;
  static int get totalSeatsUsed => _ms?.seats.totalUsed ?? 0;

  // MySubscription data - Pricing
  static String get basicPlanDescription =>
      _ms?.pricing.basicPlan.description ?? '';
  static double get basicPlanPrice =>
      _ms?.pricing.basicPlan.unitPriceInReais ?? 0.0;
  static double get additionalUsersPrice =>
      _ms?.pricing.additionalUsers.unitPriceInReais ?? 0.0;
  static double get totalPricing => _ms?.pricing.totalInReais ?? 0.0;

  // MySubscription data - Stripe
  static String get stripeSubscriptionId => _ms?.stripe.subscriptionId ?? '';
  static String get stripeStatus => _ms?.stripe.status ?? 'inactive';
  static bool get stripeIsActive => _ms?.stripe.isActive ?? false;
  static DateTime? get currentPeriodStart => _ms?.stripe.currentPeriodStartDate;
  static DateTime? get currentPeriodEnd => _ms?.stripe.currentPeriodEndDate;
  static bool get cancelAtPeriodEnd => _ms?.stripe.cancelAtPeriodEnd ?? false;
  static DateTime? get canceledAt => _ms?.stripe.canceledAtDate;
  static DateTime? get trialStart => _ms?.stripe.trialStartDate;
  static DateTime? get trialEnd => _ms?.stripe.trialEndDate;

  // MySubscription data - Summary
  static double get monthlyTotal => _ms?.summary.monthlyTotalInReais ?? 0.0;
  static DateTime? get nextBillingDate => _ms?.summary.nextBillingDateTime;
  static bool get summaryIsActive => _ms?.summary.isActive ?? false;
  static bool get hasPaymentMethod => _ms?.summary.hasPaymentMethod ?? false;

  // MySubscription data - Latest Invoice
  static String get latestInvoiceId => _ms?.stripe.latestInvoice.id ?? '';
  static String get latestInvoiceStatus =>
      _ms?.stripe.latestInvoice.status ?? '';
  static bool get latestInvoiceIsPaid =>
      _ms?.stripe.latestInvoice.isPaid ?? false;
  static double get amountPaid =>
      _ms?.stripe.latestInvoice.amountPaidInReais ?? 0.0;
  static double get amountDue =>
      _ms?.stripe.latestInvoice.amountDueInReais ?? 0.0;
  static String get hostedInvoiceUrl =>
      _ms?.stripe.latestInvoice.hostedInvoiceUrl ?? '';
  static String get invoicePdf => _ms?.stripe.latestInvoice.invoicePdf ?? '';

  // MySubscription data - Businesses
  static List<String> get businessNames =>
      _ms?.businesses.map((b) => b.name).toList() ?? [];
  static int get totalBusinesses => _ms?.businesses.length ?? 0;

  // MySubscription data - Trial
  static bool get trialIsTrialing => _ms?.trial?.isTrialing ?? false;
  static DateTime? get trialStartedAt =>
      _ms?.subscription.createdAtDate; // Usar createdAt da subscription
  static DateTime? get trialEndsAtFromTrial => _ms?.trial?.endsAtDate;
  static int? get trialDaysRemainingFromModel => _ms?.trial?.daysRemaining;
  static int get trialTotalDays => _ms?.trial?.totalDays ?? 0;

  static bool get isLoaded => _s != null;
  static bool get isMySubscriptionLoaded => _ms != null;
  static bool get isFullyLoaded => _s != null && _ms != null;

  // Helper methods
  static bool get hasActiveSubscription => isActive || isSubscriber;
  static bool get needsSubscription => !isActive && !isSubscriber;
}

class SubscriptionService extends ChangeNotifier {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  SubscriptionStatusModel? _currentSubscription;
  MySubscriptionModel? _mySubscription;
  bool _loaded = false;

  SubscriptionStatusModel? get currentSubscription => _currentSubscription;
  MySubscriptionModel? get mySubscription => _mySubscription;

  /// Inicializa carregando dados da API
  Future<void> initialize() async {
    if (_loaded) return;
    await loadFullSubscriptionData(); // Mudança: usar loadFullSubscriptionData ao invés de _loadSubscriptionData
    _loaded = true;
  }

  /// Carrega dados da subscription via API
  Future<void> _loadSubscriptionData() async {
    try {
      final subscription = await SubscriptionRemoteDataSourceImpl()
          .getSubscriptionStatus();
      _currentSubscription = subscription;
      notifyListeners();
    } catch (e) {
      // Em caso de erro, define um estado padrão
      _currentSubscription = SubscriptionStatusModel(
        isSubscriber: false,
        isTrialing: false,
        isActive: false,
        shouldShowSubscriptionModal: true,
        status: 'INACTIVE',
        trialDaysRemaining: 0,
        actionRequired: 'subscribe',
        totalTeamMembers: 0,
        billingCredits: null,
      );
      notifyListeners();
    }
  }

  /// Recarrega dados da subscription
  Future<void> refresh() async {
    await _loadSubscriptionData();
  }

  /// Define a subscription atual em memória
  void setSubscription(SubscriptionStatusModel subscription) {
    _currentSubscription = subscription;
    notifyListeners();
  }

  /// Define a mySubscription atual em memória
  void setMySubscription(MySubscriptionModel mySubscription) {
    _mySubscription = mySubscription;
    notifyListeners();
  }

  /// Carrega dados completos da subscription (status + detalhes)
  Future<void> loadFullSubscriptionData() async {
    try {
      final dataSource = SubscriptionRemoteDataSourceImpl();

      // Carrega ambos os modelos em paralelo
      final results = await Future.wait([
        dataSource.getSubscriptionStatus(),
        dataSource.getMySubscription(),
      ]);

      _currentSubscription = results[0] as SubscriptionStatusModel;
      _mySubscription = results[1] as MySubscriptionModel;

      notifyListeners();
    } catch (e) {
      // Em caso de erro, define estados padrão
      _currentSubscription = SubscriptionStatusModel(
        isSubscriber: false,
        isTrialing: false,
        isActive: false,
        shouldShowSubscriptionModal: true,
        status: 'INACTIVE',
        trialDaysRemaining: 0,
        actionRequired: 'subscribe',
        totalTeamMembers: 0,
        billingCredits: null,
      );
      _mySubscription = null;
      notifyListeners();
    }
  }

  /// Remove a subscription atual da memória e reseta completamente o estado
  void clearSubscription() {
    // Limpa completamente o estado da subscription
    _currentSubscription = null;
    _mySubscription = null;
    _loaded = false;

    // Força a recriação da instância do data source na próxima chamada
    // para garantir que não haja cache residual

    // Notifica todos os listeners sobre a limpeza completa
    notifyListeners();
  }

  /// Reset total do serviço - limpa tudo e força reinicialização
  void resetService() {
    clearSubscription();

    // Remove todos os listeners para garantir limpeza completa
    while (hasListeners) {
      removeListener(() {});
    }
  }

  /// Atualiza dinamicamente campos da subscription
  void updateSubscription(
    SubscriptionStatusModel Function(SubscriptionStatusModel current) updateFn,
  ) {
    if (_currentSubscription != null) {
      _currentSubscription = updateFn(_currentSubscription!);
      notifyListeners();
    }
  }

  /// Verifica se precisa de assinatura
  bool get needsSubscription {
    return !(_currentSubscription?.isActive ?? false) &&
        !(_currentSubscription?.isSubscriber ?? false);
  }
}
