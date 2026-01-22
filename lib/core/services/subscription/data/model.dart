// ignore_for_file: constant_identifier_names

enum SubscriptionStatus {
  INACTIVE,
  ACTIVE,
  TRIALING,
  PAST_DUE,
  CANCELED,
  UNPAID,
}

extension SubscriptionStatusExtension on SubscriptionStatus {
  String get value {
    switch (this) {
      case SubscriptionStatus.INACTIVE:
        return 'INACTIVE';
      case SubscriptionStatus.ACTIVE:
        return 'ACTIVE';
      case SubscriptionStatus.TRIALING:
        return 'TRIALING';
      case SubscriptionStatus.PAST_DUE:
        return 'PAST_DUE';
      case SubscriptionStatus.CANCELED:
        return 'CANCELED';
      case SubscriptionStatus.UNPAID:
        return 'UNPAID';
    }
  }

  static SubscriptionStatus fromString(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return SubscriptionStatus.ACTIVE;
      case 'TRIALING':
        return SubscriptionStatus.TRIALING;
      case 'PAST_DUE':
        return SubscriptionStatus.PAST_DUE;
      case 'CANCELED':
        return SubscriptionStatus.CANCELED;
      case 'UNPAID':
        return SubscriptionStatus.UNPAID;
      default:
        return SubscriptionStatus.INACTIVE;
    }
  }
}

class SegmentsModel {
  final String label;
  final String key;

  SegmentsModel({required this.label, required this.key});

  factory SegmentsModel.fromMap(Map<String, dynamic> map) {
    return SegmentsModel(
      label: map['label'] as String,
      key: map['key'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'label': label, 'key': key};
  }

  factory SegmentsModel.fromJson(Map<String, dynamic> json) =>
      SegmentsModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();
}

class SubSegmentsModel {
  final String id;
  final String name;
  final String description;

  SubSegmentsModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory SubSegmentsModel.fromMap(Map<String, dynamic> map) {
    return SubSegmentsModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'description': description,
  };

  factory SubSegmentsModel.fromJson(Map<String, dynamic> json) =>
      SubSegmentsModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();
}

class MainObjectiveModel {
  final String key;
  final String label;

  MainObjectiveModel({required this.key, required this.label});

  factory MainObjectiveModel.fromMap(Map<String, dynamic> map) {
    return MainObjectiveModel(
      key: map['key'] as String,
      label: map['label'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'key': key, 'label': label};
  }

  factory MainObjectiveModel.fromJson(Map<String, dynamic> json) =>
      MainObjectiveModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();
}

class TeamSizeModel {
  final String label;
  final String key;

  TeamSizeModel({required this.label, required this.key});

  factory TeamSizeModel.fromMap(Map<String, dynamic> map) {
    return TeamSizeModel(
      label: map['label'] as String,
      key: map['key'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'label': label, 'key': key};
  }

  factory TeamSizeModel.fromJson(Map<String, dynamic> json) =>
      TeamSizeModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();
}

class BillingCredits {
  final int available;
  final bool hasDiscount;
  final double discountPercentage;
  final bool nextBillingWillBeFree;

  BillingCredits({
    required this.available,
    required this.hasDiscount,
    required this.discountPercentage,
    required this.nextBillingWillBeFree,
  });

  factory BillingCredits.fromMap(Map<String, dynamic> map) {
    return BillingCredits(
      available: map['available'] as int? ?? 0,
      hasDiscount: map['hasDiscount'] as bool? ?? false,
      discountPercentage:
          (map['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      nextBillingWillBeFree: map['nextBillingWillBeFree'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'available': available,
    'hasDiscount': hasDiscount,
    'discountPercentage': discountPercentage,
    'nextBillingWillBeFree': nextBillingWillBeFree,
  };

  factory BillingCredits.fromJson(Map<String, dynamic> json) =>
      BillingCredits.fromMap(json);

  Map<String, dynamic> toJson() => toMap();
}

class SubscriptionStatusModel {
  final bool isSubscriber;
  final bool isTrialing;
  final bool isActive;
  final bool shouldShowSubscriptionModal;
  final String status;
  final String? trialEndsAt;
  final int trialDaysRemaining;
  final String? actionRequired;
  final int totalTeamMembers;
  final BillingCredits? billingCredits;

  SubscriptionStatusModel({
    required this.isSubscriber,
    required this.isTrialing,
    required this.isActive,
    required this.shouldShowSubscriptionModal,
    required this.status,
    this.trialEndsAt,
    required this.trialDaysRemaining,
    this.actionRequired,
    required this.totalTeamMembers,
    this.billingCredits,
  });

  /// Getter para acessar o status como enum
  SubscriptionStatus get statusEnum =>
      SubscriptionStatusExtension.fromString(status);

  factory SubscriptionStatusModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionStatusModel(
      isSubscriber: map['isSubscriber'] as bool? ?? false,
      isTrialing: map['isTrialing'] as bool? ?? false,
      isActive: map['isActive'] as bool? ?? false,
      shouldShowSubscriptionModal:
          map['shouldShowSubscriptionModal'] as bool? ?? false,
      status: map['status'] as String? ?? '',
      trialEndsAt: map['trialEndsAt'] as String?,
      trialDaysRemaining: map['trialDaysRemaining'] as int? ?? 0,
      actionRequired: map['actionRequired'] as String?,
      totalTeamMembers: map['totalTeamMembers'] as int? ?? 0,
      billingCredits: map['billingCredits'] != null
          ? BillingCredits.fromMap(
              map['billingCredits'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
    'isSubscriber': isSubscriber,
    'isTrialing': isTrialing,
    'isActive': isActive,
    'shouldShowSubscriptionModal': shouldShowSubscriptionModal,
    'status': status,
    'trialEndsAt': trialEndsAt,
    'trialDaysRemaining': trialDaysRemaining,
    'actionRequired': actionRequired,
    'totalTeamMembers': totalTeamMembers,
    'billingCredits': billingCredits?.toMap(),
  };

  factory SubscriptionStatusModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionStatusModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();
}

class CreateResponse {
  final String url;
  final String sessionId;

  CreateResponse({required this.url, required this.sessionId});

  factory CreateResponse.fromMap(Map<String, dynamic> map) {
    return CreateResponse(
      url: map['url'] as String,
      sessionId: map['sessionId'] as String,
    );
  }

  Map<String, dynamic> toMap() => {'url': url, 'sessionId': sessionId};

  factory CreateResponse.fromJson(Map<String, dynamic> json) =>
      CreateResponse.fromMap(json);

  Map<String, dynamic> toJson() => toMap();
}

class SeatsModel {
  final int owner;
  final int teamMembers;
  final int totalUsed;

  SeatsModel({
    required this.owner,
    required this.teamMembers,
    required this.totalUsed,
  });

  factory SeatsModel.fromMap(Map<String, dynamic> map) {
    return SeatsModel(
      owner: map['owner'] as int? ?? 0,
      teamMembers: map['teamMembers'] as int? ?? 0,
      totalUsed: map['totalUsed'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'owner': owner,
    'teamMembers': teamMembers,
    'totalUsed': totalUsed,
  };

  factory SeatsModel.fromJson(Map<String, dynamic> json) =>
      SeatsModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();
}

class PricingItemModel {
  final String description;
  final int quantity;
  final int unitPrice;
  final int totalPrice;
  final String priceId;

  PricingItemModel({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.priceId,
  });

  factory PricingItemModel.fromMap(Map<String, dynamic> map) {
    return PricingItemModel(
      description: map['description'] as String? ?? '',
      quantity: map['quantity'] as int? ?? 0,
      unitPrice: map['unitPrice'] as int? ?? 0,
      totalPrice: map['totalPrice'] as int? ?? 0,
      priceId: map['priceId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'description': description,
    'quantity': quantity,
    'unitPrice': unitPrice,
    'totalPrice': totalPrice,
    'priceId': priceId,
  };

  factory PricingItemModel.fromJson(Map<String, dynamic> json) =>
      PricingItemModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();

  /// Helper para obter o preço em reais
  double get unitPriceInReais => unitPrice / 100.0;
  double get totalPriceInReais => totalPrice / 100.0;
}

class PricingModel {
  final PricingItemModel basicPlan;
  final PricingItemModel additionalUsers;
  final int total;

  PricingModel({
    required this.basicPlan,
    required this.additionalUsers,
    required this.total,
  });

  factory PricingModel.fromMap(Map<String, dynamic> map) {
    return PricingModel(
      basicPlan: PricingItemModel.fromMap(
        map['basicPlan'] as Map<String, dynamic>,
      ),
      additionalUsers: PricingItemModel.fromMap(
        map['additionalUsers'] as Map<String, dynamic>,
      ),
      total: map['total'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'basicPlan': basicPlan.toMap(),
    'additionalUsers': additionalUsers.toMap(),
    'total': total,
  };

  factory PricingModel.fromJson(Map<String, dynamic> json) =>
      PricingModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();

  /// Helper para obter o total em reais
  double get totalInReais => total / 100.0;
}

class BusinessModel {
  final String id;
  final String name;
  final int teamMembersCount;

  BusinessModel({
    required this.id,
    required this.name,
    required this.teamMembersCount,
  });

  factory BusinessModel.fromMap(Map<String, dynamic> map) {
    return BusinessModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      teamMembersCount: map['teamMembersCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'teamMembersCount': teamMembersCount,
  };

  factory BusinessModel.fromJson(Map<String, dynamic> json) =>
      BusinessModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();
}

class StripeItemModel {
  final String id;
  final String priceId;
  final String productName;
  final int quantity;
  final int unitAmount;
  final int totalAmount;
  final String interval;

  StripeItemModel({
    required this.id,
    required this.priceId,
    required this.productName,
    required this.quantity,
    required this.unitAmount,
    required this.totalAmount,
    required this.interval,
  });

  factory StripeItemModel.fromMap(Map<String, dynamic> map) {
    return StripeItemModel(
      id: map['id'] as String? ?? '',
      priceId: map['priceId'] as String? ?? '',
      productName: map['productName'] as String? ?? '',
      quantity: map['quantity'] as int? ?? 0,
      unitAmount: map['unitAmount'] as int? ?? 0,
      totalAmount: map['totalAmount'] as int? ?? 0,
      interval: map['interval'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'priceId': priceId,
    'productName': productName,
    'quantity': quantity,
    'unitAmount': unitAmount,
    'totalAmount': totalAmount,
    'interval': interval,
  };

  factory StripeItemModel.fromJson(Map<String, dynamic> json) =>
      StripeItemModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();

  /// Helper para obter valores em reais
  double get unitAmountInReais => unitAmount / 100.0;
  double get totalAmountInReais => totalAmount / 100.0;
}

class LatestInvoiceModel {
  final String id;
  final String status;
  final int amountPaid;
  final int amountDue;
  final int total;
  final String created;
  final String? dueDate;
  final String hostedInvoiceUrl;
  final String invoicePdf;

  LatestInvoiceModel({
    required this.id,
    required this.status,
    required this.amountPaid,
    required this.amountDue,
    required this.total,
    required this.created,
    this.dueDate,
    required this.hostedInvoiceUrl,
    required this.invoicePdf,
  });

  factory LatestInvoiceModel.fromMap(Map<String, dynamic> map) {
    return LatestInvoiceModel(
      id: map['id'] as String? ?? '',
      status: map['status'] as String? ?? '',
      amountPaid: map['amountPaid'] as int? ?? 0,
      amountDue: map['amountDue'] as int? ?? 0,
      total: map['total'] as int? ?? 0,
      created: map['created'] as String? ?? '',
      dueDate: map['dueDate'] as String?,
      hostedInvoiceUrl: map['hostedInvoiceUrl'] as String? ?? '',
      invoicePdf: map['invoicePdf'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'status': status,
    'amountPaid': amountPaid,
    'amountDue': amountDue,
    'total': total,
    'created': created,
    'dueDate': dueDate,
    'hostedInvoiceUrl': hostedInvoiceUrl,
    'invoicePdf': invoicePdf,
  };

  factory LatestInvoiceModel.fromJson(Map<String, dynamic> json) =>
      LatestInvoiceModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();

  /// Helper methods para conversão de datas e valores
  DateTime get createdDate => DateTime.parse(created);
  DateTime? get dueDateDate =>
      dueDate != null ? DateTime.parse(dueDate!) : null;

  double get amountPaidInReais => amountPaid / 100.0;
  double get amountDueInReais => amountDue / 100.0;
  double get totalInReais => total / 100.0;

  bool get isPaid => status.toLowerCase() == 'paid';
}

class StripeModel {
  final String subscriptionId;
  final String status;
  final String currentPeriodStart;
  final String currentPeriodEnd;
  final bool cancelAtPeriodEnd;
  final String? canceledAt;
  final String? trialStart;
  final String? trialEnd;
  final List<StripeItemModel> items;
  final LatestInvoiceModel latestInvoice;
  final String billingCycleAnchor;

  StripeModel({
    required this.subscriptionId,
    required this.status,
    required this.currentPeriodStart,
    required this.currentPeriodEnd,
    required this.cancelAtPeriodEnd,
    this.canceledAt,
    this.trialStart,
    this.trialEnd,
    required this.items,
    required this.latestInvoice,
    required this.billingCycleAnchor,
  });

  factory StripeModel.fromMap(Map<String, dynamic> map) {
    return StripeModel(
      subscriptionId: map['subscriptionId'] as String? ?? '',
      status: map['status'] as String? ?? '',
      currentPeriodStart: map['currentPeriodStart'] as String? ?? '',
      currentPeriodEnd: map['currentPeriodEnd'] as String? ?? '',
      cancelAtPeriodEnd: map['cancelAtPeriodEnd'] as bool? ?? false,
      canceledAt: map['canceledAt'] as String?,
      trialStart: map['trialStart'] as String?,
      trialEnd: map['trialEnd'] as String?,
      items: (map['items'] as List<dynamic>? ?? [])
          .map((item) => StripeItemModel.fromMap(item as Map<String, dynamic>))
          .toList(),
      latestInvoice: LatestInvoiceModel.fromMap(
        map['latestInvoice'] as Map<String, dynamic>,
      ),
      billingCycleAnchor: map['billingCycleAnchor'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'subscriptionId': subscriptionId,
    'status': status,
    'currentPeriodStart': currentPeriodStart,
    'currentPeriodEnd': currentPeriodEnd,
    'cancelAtPeriodEnd': cancelAtPeriodEnd,
    'canceledAt': canceledAt,
    'trialStart': trialStart,
    'trialEnd': trialEnd,
    'items': items.map((item) => item.toMap()).toList(),
    'latestInvoice': latestInvoice.toMap(),
    'billingCycleAnchor': billingCycleAnchor,
  };

  factory StripeModel.fromJson(Map<String, dynamic> json) =>
      StripeModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();

  /// Helper methods para conversão de datas
  DateTime get currentPeriodStartDate => DateTime.parse(currentPeriodStart);
  DateTime get currentPeriodEndDate => DateTime.parse(currentPeriodEnd);
  DateTime? get canceledAtDate =>
      canceledAt != null ? DateTime.parse(canceledAt!) : null;
  DateTime? get trialStartDate =>
      trialStart != null ? DateTime.parse(trialStart!) : null;
  DateTime? get trialEndDate =>
      trialEnd != null ? DateTime.parse(trialEnd!) : null;
  DateTime get billingCycleAnchorDate => DateTime.parse(billingCycleAnchor);

  /// Helper para verificar se está ativo
  bool get isActive => status.toLowerCase() == 'active';
}

class SubscriptionSummaryModel {
  final int monthlyTotal;
  final String nextBillingDate;
  final bool isActive;
  final bool hasPaymentMethod;

  SubscriptionSummaryModel({
    required this.monthlyTotal,
    required this.nextBillingDate,
    required this.isActive,
    required this.hasPaymentMethod,
  });

  factory SubscriptionSummaryModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionSummaryModel(
      monthlyTotal: map['monthlyTotal'] as int? ?? 0,
      nextBillingDate: map['nextBillingDate'] as String? ?? '',
      isActive: map['isActive'] as bool? ?? false,
      hasPaymentMethod: map['hasPaymentMethod'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'monthlyTotal': monthlyTotal,
    'nextBillingDate': nextBillingDate,
    'isActive': isActive,
    'hasPaymentMethod': hasPaymentMethod,
  };

  factory SubscriptionSummaryModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionSummaryModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();

  /// Helper para obter o total mensal em reais
  double get monthlyTotalInReais => monthlyTotal / 100.0;

  /// Helper para obter a próxima data de cobrança
  DateTime get nextBillingDateTime => DateTime.parse(nextBillingDate);
}

class TrialModel {
  final bool isTrialing;
  final String? startedAt;
  final String? endsAt;
  final int? daysRemaining;
  final int totalDays;

  TrialModel({
    required this.isTrialing,
    this.startedAt,
    this.endsAt,
    this.daysRemaining,
    required this.totalDays,
  });

  factory TrialModel.fromMap(Map<String, dynamic> map) {
    return TrialModel(
      isTrialing: map['isTrialing'] as bool? ?? false,
      startedAt: map['startedAt'] as String?,
      endsAt: map['endsAt'] as String?,
      daysRemaining: map['daysRemaining'] as int?,
      totalDays: map['totalDays'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'isTrialing': isTrialing,
    'startedAt': startedAt,
    'endsAt': endsAt,
    'daysRemaining': daysRemaining,
    'totalDays': totalDays,
  };

  factory TrialModel.fromJson(Map<String, dynamic> json) =>
      TrialModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();

  /// Helper methods para conversão de datas
  DateTime? get startedAtDate =>
      startedAt != null ? DateTime.parse(startedAt!) : null;
  DateTime? get endsAtDate => endsAt != null ? DateTime.parse(endsAt!) : null;
}

class SubscriptionInfoModel {
  final String id;
  final String status;
  final String createdAt;
  final String updatedAt;

  SubscriptionInfoModel({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubscriptionInfoModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionInfoModel(
      id: map['id'] as String? ?? '',
      status: map['status'] as String? ?? '',
      createdAt: map['createdAt'] as String? ?? '',
      updatedAt: map['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'status': status,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  factory SubscriptionInfoModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionInfoModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();

  /// Getter para acessar o status como enum
  SubscriptionStatus get statusEnum =>
      SubscriptionStatusExtension.fromString(status);

  /// Helper methods para conversão de datas
  DateTime get createdAtDate => DateTime.parse(createdAt);
  DateTime get updatedAtDate => DateTime.parse(updatedAt);

  /// Helper para verificar se está ativo
  bool get isActive => status == 'ACTIVE';
}

class MySubscriptionModel {
  final SubscriptionInfoModel subscription;
  final SeatsModel seats;
  final PricingModel pricing;
  final TrialModel? trial;
  final List<BusinessModel> businesses;
  final StripeModel stripe;
  final SubscriptionSummaryModel summary;

  MySubscriptionModel({
    required this.subscription,
    required this.seats,
    required this.pricing,
    this.trial,
    required this.businesses,
    required this.stripe,
    required this.summary,
  });

  factory MySubscriptionModel.fromMap(Map<String, dynamic> map) {
    return MySubscriptionModel(
      subscription: map['subscription'] != null
          ? SubscriptionInfoModel.fromMap(
              map['subscription'] as Map<String, dynamic>,
            )
          : SubscriptionInfoModel(
              id: '',
              status: 'INACTIVE',
              createdAt: DateTime.now().toIso8601String(),
              updatedAt: DateTime.now().toIso8601String(),
            ),
      seats: map['seats'] != null
          ? SeatsModel.fromMap(map['seats'] as Map<String, dynamic>)
          : SeatsModel(owner: 0, teamMembers: 0, totalUsed: 0),
      pricing: map['pricing'] != null
          ? PricingModel.fromMap(map['pricing'] as Map<String, dynamic>)
          : PricingModel(
              basicPlan: PricingItemModel(
                description: '',
                quantity: 0,
                unitPrice: 0,
                totalPrice: 0,
                priceId: '',
              ),
              additionalUsers: PricingItemModel(
                description: '',
                quantity: 0,
                unitPrice: 0,
                totalPrice: 0,
                priceId: '',
              ),
              total: 0,
            ),
      trial: map['trial'] != null
          ? TrialModel.fromMap(map['trial'] as Map<String, dynamic>)
          : null,
      businesses: (map['businesses'] as List<dynamic>? ?? [])
          .map(
            (business) =>
                BusinessModel.fromMap(business as Map<String, dynamic>),
          )
          .toList(),
      stripe: map['stripe'] != null
          ? StripeModel.fromMap(map['stripe'] as Map<String, dynamic>)
          : StripeModel(
              subscriptionId: '',
              status: 'inactive',
              currentPeriodStart: DateTime.now().toIso8601String(),
              currentPeriodEnd: DateTime.now().toIso8601String(),
              cancelAtPeriodEnd: false,
              items: [],
              latestInvoice: LatestInvoiceModel(
                id: '',
                status: 'draft',
                amountPaid: 0,
                amountDue: 0,
                total: 0,
                created: DateTime.now().toIso8601String(),
                hostedInvoiceUrl: '',
                invoicePdf: '',
              ),
              billingCycleAnchor: DateTime.now().toIso8601String(),
            ),
      summary: map['summary'] != null
          ? SubscriptionSummaryModel.fromMap(
              map['summary'] as Map<String, dynamic>,
            )
          : SubscriptionSummaryModel(
              monthlyTotal: 0,
              nextBillingDate: DateTime.now().toIso8601String(),
              isActive: false,
              hasPaymentMethod: false,
            ),
    );
  }

  Map<String, dynamic> toMap() => {
    'subscription': subscription.toMap(),
    'seats': seats.toMap(),
    'pricing': pricing.toMap(),
    'trial': trial?.toMap(),
    'businesses': businesses.map((business) => business.toMap()).toList(),
    'stripe': stripe.toMap(),
    'summary': summary.toMap(),
  };

  factory MySubscriptionModel.fromJson(Map<String, dynamic> json) =>
      MySubscriptionModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();
}
