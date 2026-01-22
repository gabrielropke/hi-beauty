class DashboardResponseModel {
  final bool ok;
  final String? message;
  final String? error;
  final DashboardModel dashboard;

  DashboardResponseModel({
    required this.ok,
    this.message,
    this.error,
    required this.dashboard,
  });

  factory DashboardResponseModel.fromJson(Map<String, dynamic> json) {
    return DashboardResponseModel(
      ok: json['ok'] ?? false,
      message: json['message'],
      error: json['error'],
      dashboard: DashboardModel.fromJson(json['dashboard'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ok': ok,
      'message': message,
      'error': error,
      'dashboard': dashboard.toJson(),
    };
  }
}

class DashboardModel {
  final String period;
  final String userRole;
  final String dashboardType;
  final InsightsModel insights;
  final List<AppointmentModel> upcomingAppointments;
  final List<TransactionModel> recentTransactions;
  final QuickStatsModel quickStats;
  final DateTime lastUpdated;

  DashboardModel({
    required this.period,
    required this.userRole,
    required this.dashboardType,
    required this.insights,
    required this.upcomingAppointments,
    required this.recentTransactions,
    required this.quickStats,
    required this.lastUpdated,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      period: json['period'] ?? '7',
      userRole: json['userRole'] ?? '',
      dashboardType: json['dashboardType'] ?? '',
      insights: InsightsModel.fromJson(json['insights'] ?? {}),
      upcomingAppointments:
          (json['upcomingAppointments'] as List<dynamic>?)
              ?.map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recentTransactions:
          (json['recentTransactions'] as List<dynamic>?)
              ?.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      quickStats: QuickStatsModel.fromJson(json['quickStats'] ?? {}),
      lastUpdated:
          DateTime.tryParse(json['lastUpdated'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'period': period,
      'userRole': userRole,
      'dashboardType': dashboardType,
      'insights': insights.toJson(),
      'upcomingAppointments': upcomingAppointments
          .map((e) => e.toJson())
          .toList(),
      'recentTransactions': recentTransactions.map((e) => e.toJson()).toList(),
      'quickStats': quickStats.toJson(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}

class InsightsModel {
  final InsightItemModel appointments;
  final InsightItemModel activeClients;
  final RevenueInsightModel revenue;
  final ReviewsInsightModel reviews;

  InsightsModel({
    required this.appointments,
    required this.activeClients,
    required this.revenue,
    required this.reviews,
  });

  factory InsightsModel.fromJson(Map<String, dynamic> json) {
    return InsightsModel(
      appointments: InsightItemModel.fromJson(json['appointments'] ?? {}),
      activeClients: InsightItemModel.fromJson(json['activeClients'] ?? {}),
      revenue: RevenueInsightModel.fromJson(json['revenue'] ?? {}),
      reviews: ReviewsInsightModel.fromJson(json['reviews'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointments': appointments.toJson(),
      'activeClients': activeClients.toJson(),
      'revenue': revenue.toJson(),
      'reviews': reviews.toJson(),
    };
  }
}

class InsightItemModel {
  final int total;
  final String change;
  final String trend;

  InsightItemModel({
    required this.total,
    required this.change,
    required this.trend,
  });

  factory InsightItemModel.fromJson(Map<String, dynamic> json) {
    return InsightItemModel(
      total: json['total'] ?? 0,
      change: json['change'] ?? '',
      trend: json['trend'] ?? 'up',
    );
  }

  Map<String, dynamic> toJson() {
    return {'total': total, 'change': change, 'trend': trend};
  }
}

class RevenueInsightModel {
  final double total;
  final String formatted;
  final String change;
  final String trend;

  RevenueInsightModel({
    required this.total,
    required this.formatted,
    required this.change,
    required this.trend,
  });

  factory RevenueInsightModel.fromJson(Map<String, dynamic> json) {
    return RevenueInsightModel(
      total: (json['total'] ?? 0).toDouble(),
      formatted: json['formatted'] ?? '',
      change: json['change'] ?? '',
      trend: json['trend'] ?? 'up',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'formatted': formatted,
      'change': change,
      'trend': trend,
    };
  }
}

class ReviewsInsightModel {
  final double averageRating;
  final String change;
  final String trend;
  final int totalReviews;

  ReviewsInsightModel({
    required this.averageRating,
    required this.change,
    required this.trend,
    required this.totalReviews,
  });

  factory ReviewsInsightModel.fromJson(Map<String, dynamic> json) {
    return ReviewsInsightModel(
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      change: json['change'] ?? '',
      trend: json['trend'] ?? 'up',
      totalReviews: json['totalReviews'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'averageRating': averageRating,
      'change': change,
      'trend': trend,
      'totalReviews': totalReviews,
    };
  }
}

class AppointmentModel {
  final String id;
  final String name;
  final DateTime scheduledFor;
  final int duration;
  final String status;
  final String type;
  final double totalPrice;
  final bool isRecurring;
  final String recurrenceType;
  final DateTime? recurrenceEndDate;
  final String? parentBookingId;
  final CustomerModel customer;
  final TeamMemberModel teamMember;
  final List<ServiceItemModel> services;
  final PaymentModel payment;
  final List<ComboModel> combos;

  AppointmentModel({
    required this.id,
    required this.name,
    required this.scheduledFor,
    required this.duration,
    required this.status,
    required this.type,
    required this.totalPrice,
    required this.isRecurring,
    required this.recurrenceType,
    this.recurrenceEndDate,
    this.parentBookingId,
    required this.customer,
    required this.teamMember,
    required this.services,
    required this.payment,
    required this.combos,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      scheduledFor:
          DateTime.tryParse(json['scheduledFor'] ?? '') ?? DateTime.now(),
      duration: json['duration'] ?? 0,
      status: json['status'] ?? '',
      type: json['type'] ?? '',
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      isRecurring: json['isRecurring'] ?? false,
      recurrenceType: json['recurrenceType'] ?? 'NONE',
      recurrenceEndDate: json['recurrenceEndDate'] != null
          ? DateTime.tryParse(json['recurrenceEndDate'])
          : null,
      parentBookingId: json['parentBookingId'],
      customer: CustomerModel.fromJson(json['customer'] ?? {}),
      teamMember: TeamMemberModel.fromJson(json['teamMember'] ?? {}),
      services:
          (json['services'] as List<dynamic>?)
              ?.map((e) => ServiceItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      payment: PaymentModel.fromJson(json['payment'] ?? {}),
      combos:
          (json['combos'] as List<dynamic>?)
              ?.map((e) => ComboModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scheduledFor': scheduledFor.toIso8601String(),
      'duration': duration,
      'status': status,
      'type': type,
      'totalPrice': totalPrice,
      'isRecurring': isRecurring,
      'recurrenceType': recurrenceType,
      'recurrenceEndDate': recurrenceEndDate?.toIso8601String(),
      'parentBookingId': parentBookingId,
      'customer': customer.toJson(),
      'teamMember': teamMember.toJson(),
      'services': services.map((e) => e.toJson()).toList(),
      'payment': payment.toJson(),
      'combos': combos.map((e) => e.toJson()).toList(),
    };
  }
}

class CustomerModel {
  final String id;
  final String name;
  final String phone;
  final String email;

  CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'phone': phone, 'email': email};
  }
}

class TeamMemberModel {
  final String id;
  final String name;
  final String role;
  final String? profileImageUrl;
  final String color;

  TeamMemberModel({
    required this.id,
    required this.name,
    required this.role,
    this.profileImageUrl,
    required this.color,
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      color: json['color'] ?? '#000000',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'profileImageUrl': profileImageUrl,
      'color': color,
    };
  }
}

class ServiceItemModel {
  final String name;
  final int duration;
  final double price;

  ServiceItemModel({
    required this.name,
    required this.duration,
    required this.price,
  });

  factory ServiceItemModel.fromJson(Map<String, dynamic> json) {
    return ServiceItemModel(
      name: json['name'] ?? '',
      duration: json['duration'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'duration': duration, 'price': price};
  }
}

class PaymentModel {
  final bool hasTransaction;
  final String? status;
  final bool isPaid;
  final double? amount;
  final String? transactionId;

  PaymentModel({
    required this.hasTransaction,
    this.status,
    required this.isPaid,
    this.amount,
    this.transactionId,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      hasTransaction: json['hasTransaction'] ?? false,
      status: json['status'],
      isPaid: json['isPaid'] ?? false,
      amount: json['amount'] != null
          ? (json['amount'] as num).toDouble()
          : null,
      transactionId: json['transactionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasTransaction': hasTransaction,
      'status': status,
      'isPaid': isPaid,
      'amount': amount,
      'transactionId': transactionId,
    };
  }
}

class ComboModel {
  final String id;
  final String name;
  final double price;

  ComboModel({required this.id, required this.name, required this.price});

  factory ComboModel.fromJson(Map<String, dynamic> json) {
    return ComboModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'price': price};
  }
}

class ServiceModel {
  final String id;
  final String name;
  final int duration;
  final String durationFormatted;
  final double price;
  final String priceFormatted;
  final DateTime? completedAt;

  ServiceModel({
    required this.id,
    required this.name,
    required this.duration,
    required this.durationFormatted,
    required this.price,
    required this.priceFormatted,
    this.completedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      duration: json['duration'] ?? 0,
      durationFormatted: json['durationFormatted'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      priceFormatted: json['priceFormatted'] ?? '',
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'durationFormatted': durationFormatted,
      'price': price,
      'priceFormatted': priceFormatted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}

class TransactionModel {
  final String id;
  final double amount;
  final String currency;
  final String description;
  final String status;
  final String type;
  final String? paymentMethod;
  final DateTime? serviceDate;
  final DateTime? completedAt;
  final DateTime? paidAt;
  final DateTime? dueDate;
  final String? notes;
  final BookingModel booking;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.currency,
    required this.description,
    required this.status,
    required this.type,
    this.paymentMethod,
    this.serviceDate,
    this.completedAt,
    this.paidAt,
    this.dueDate,
    this.notes,
    required this.booking,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'BRL',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      type: json['type'] ?? '',
      paymentMethod: json['paymentMethod'],
      serviceDate: json['serviceDate'] != null
          ? DateTime.tryParse(json['serviceDate'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'])
          : null,
      paidAt: json['paidAt'] != null ? DateTime.tryParse(json['paidAt']) : null,
      dueDate: json['dueDate'] != null
          ? DateTime.tryParse(json['dueDate'])
          : null,
      notes: json['notes'],
      booking: BookingModel.fromJson(json['booking'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'currency': currency,
      'description': description,
      'status': status,
      'type': type,
      'paymentMethod': paymentMethod,
      'serviceDate': serviceDate?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'paidAt': paidAt?.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'notes': notes,
      'booking': booking.toJson(),
    };
  }
}

class BookingModel {
  final String id;
  final String name;
  final DateTime scheduledFor;
  final CustomerModel customer;
  final TeamMemberModel teamMember;

  BookingModel({
    required this.id,
    required this.name,
    required this.scheduledFor,
    required this.customer,
    required this.teamMember,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      scheduledFor:
          DateTime.tryParse(json['scheduledFor'] ?? '') ?? DateTime.now(),
      customer: CustomerModel.fromJson(json['customer'] ?? {}),
      teamMember: TeamMemberModel.fromJson(json['teamMember'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scheduledFor': scheduledFor.toIso8601String(),
      'customer': customer.toJson(),
      'teamMember': teamMember.toJson(),
    };
  }
}

class QuickStatsModel {
  final int todayAppointments;
  final double weekRevenue;
  final int pendingPayments;
  final int newClients;

  QuickStatsModel({
    required this.todayAppointments,
    required this.weekRevenue,
    required this.pendingPayments,
    required this.newClients,
  });

  factory QuickStatsModel.fromJson(Map<String, dynamic> json) {
    return QuickStatsModel(
      todayAppointments: json['todayAppointments'] ?? 0,
      weekRevenue: (json['weekRevenue'] ?? 0).toDouble(),
      pendingPayments: json['pendingPayments'] ?? 0,
      newClients: json['newClients'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todayAppointments': todayAppointments,
      'weekRevenue': weekRevenue,
      'pendingPayments': pendingPayments,
      'newClients': newClients,
    };
  }
}
