class SchedulesTodayResponseModel {
  final bool ok;
  final String message;
  final String date;
  final List<BookingModel> bookings;
  final StatsModel stats;

  SchedulesTodayResponseModel({
    required this.ok,
    required this.message,
    required this.date,
    required this.bookings,
    required this.stats,
  });

  factory SchedulesTodayResponseModel.fromJson(Map<String, dynamic> json) {
    return SchedulesTodayResponseModel(
      ok: json['ok'] ?? false,
      message: json['message'] ?? '',
      date: json['date'] ?? '',
      bookings:
          (json['bookings'] as List<dynamic>?)
              ?.map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      stats: StatsModel.fromJson(json['stats'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ok': ok,
      'message': message,
      'date': date,
      'bookings': bookings.map((e) => e.toJson()).toList(),
      'stats': stats.toJson(),
    };
  }
}

class BookingModel {
  final String id;
  final String name;
  final String scheduledFor;
  final int duration;
  final String status;
  final String type;
  final double totalPrice;
  final CustomerModel customer;
  final TeamMemberModel teamMember;
  final List<ServiceModel> services;
  final List<dynamic> combos;
  final List<dynamic> products;
  final PaymentModel payment;

  BookingModel({
    required this.id,
    required this.name,
    required this.scheduledFor,
    required this.duration,
    required this.status,
    required this.type,
    required this.totalPrice,
    required this.customer,
    required this.teamMember,
    required this.services,
    required this.combos,
    required this.products,
    required this.payment,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      scheduledFor: json['scheduledFor'] ?? '',
      duration: json['duration'] ?? 0,
      status: json['status'] ?? '',
      type: json['type'] ?? '',
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      customer: CustomerModel.fromJson(json['customer'] ?? {}),
      teamMember: TeamMemberModel.fromJson(json['teamMember'] ?? {}),
      services:
          (json['services'] as List<dynamic>?)
              ?.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      combos: json['combos'] ?? [],
      products: json['products'] ?? [],
      payment: PaymentModel.fromJson(json['payment'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scheduledFor': scheduledFor,
      'duration': duration,
      'status': status,
      'type': type,
      'totalPrice': totalPrice,
      'customer': customer.toJson(),
      'teamMember': teamMember.toJson(),
      'services': services.map((e) => e.toJson()).toList(),
      'combos': combos,
      'products': products,
      'payment': payment.toJson(),
    };
  }
}

class CustomerModel {
  final String id;
  final String name;
  final String phone;

  CustomerModel({required this.id, required this.name, required this.phone});

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'phone': phone};
  }
}

class TeamMemberModel {
  final String id;
  final String name;
  final String role;
  final String profileImageUrl;
  final String color;

  TeamMemberModel({
    required this.id,
    required this.name,
    required this.role,
    required this.profileImageUrl,
    required this.color,
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      color: json['color'] ?? '',
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

class ServiceModel {
  final String id;
  final String name;
  final int duration;
  final double price;

  ServiceModel({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      duration: json['duration'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'duration': duration, 'price': price};
  }
}

class PaymentModel {
  final bool hasTransaction;
  final String status;
  final bool isPaid;
  final double amount;
  final String transactionId;

  PaymentModel({
    required this.hasTransaction,
    required this.status,
    required this.isPaid,
    required this.amount,
    required this.transactionId,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      hasTransaction: json['hasTransaction'] ?? false,
      status: json['status'] ?? '',
      isPaid: json['isPaid'] ?? false,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      transactionId: json['transactionId'] ?? '',
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

class StatsModel {
  final int total;
  final int confirmed;
  final int completed;
  final int cancelled;
  final double revenue;
  final int blocks;

  StatsModel({
    required this.total,
    required this.confirmed,
    required this.completed,
    required this.cancelled,
    required this.revenue,
    required this.blocks,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      total: json['total'] ?? 0,
      confirmed: json['confirmed'] ?? 0,
      completed: json['completed'] ?? 0,
      cancelled: json['cancelled'] ?? 0,
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
      blocks: json['blocks'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'confirmed': confirmed,
      'completed': completed,
      'cancelled': cancelled,
      'revenue': revenue,
      'blocks': blocks,
    };
  }
}

class BookingWeekORMonthModel {
  final bool ok;
  final String message;
  final PeriodModel period;
  final List<BookingDayModel> bookingsByDay;
  final WeekStatsModel weekStats;
  final PaginationModel pagination;

  BookingWeekORMonthModel({
    required this.ok,
    required this.message,
    required this.period,
    required this.bookingsByDay,
    required this.weekStats,
    required this.pagination,
  });

  factory BookingWeekORMonthModel.fromJson(Map<String, dynamic> json) {
    return BookingWeekORMonthModel(
      ok: json['ok'] ?? false,
      message: json['message'] ?? '',
      period: PeriodModel.fromJson(json['period'] ?? {}),
      bookingsByDay:
          (json['bookingsByDay'] as List<dynamic>?)
              ?.map((e) => BookingDayModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      weekStats: WeekStatsModel.fromJson(json['weekStats'] ?? {}),
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ok': ok,
      'message': message,
      'period': period.toJson(),
      'bookingsByDay': bookingsByDay.map((e) => e.toJson()).toList(),
      'weekStats': weekStats.toJson(),
      'pagination': pagination.toJson(),
    };
  }
}

class PeriodModel {
  final String startDate;
  final String endDate;

  PeriodModel({required this.startDate, required this.endDate});

  factory PeriodModel.fromJson(Map<String, dynamic> json) {
    return PeriodModel(
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'startDate': startDate, 'endDate': endDate};
  }
}

class BookingDayModel {
  final String date;
  final String dayName;
  final List<BookingModel> bookings;
  final StatsModel stats;

  BookingDayModel({
    required this.date,
    required this.dayName,
    required this.bookings,
    required this.stats,
  });

  factory BookingDayModel.fromJson(Map<String, dynamic> json) {
    return BookingDayModel(
      date: json['date'] ?? '',
      dayName: json['dayName'] ?? '',
      bookings:
          (json['bookings'] as List<dynamic>?)
              ?.map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      stats: StatsModel.fromJson(json['stats'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'dayName': dayName,
      'bookings': bookings.map((e) => e.toJson()).toList(),
      'stats': stats.toJson(),
    };
  }
}

class WeekStatsModel {
  final int totalBookings;
  final int totalBlocks;
  final double totalRevenue;
  final double averageDailyBookings;
  final String busiestDay;
  final String topTeamMember;

  WeekStatsModel({
    required this.totalBookings,
    required this.totalBlocks,
    required this.totalRevenue,
    required this.averageDailyBookings,
    required this.busiestDay,
    required this.topTeamMember,
  });

  factory WeekStatsModel.fromJson(Map<String, dynamic> json) {
    return WeekStatsModel(
      totalBookings: json['totalBookings'] ?? 0,
      totalBlocks: json['totalBlocks'] ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      averageDailyBookings:
          (json['averageDailyBookings'] as num?)?.toDouble() ?? 0.0,
      busiestDay: json['busiestDay'] ?? '',
      topTeamMember: json['topTeamMember'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalBookings': totalBookings,
      'totalBlocks': totalBlocks,
      'totalRevenue': totalRevenue,
      'averageDailyBookings': averageDailyBookings,
      'busiestDay': busiestDay,
      'topTeamMember': topTeamMember,
    };
  }
}

class PaginationModel {
  final int total;
  final int limit;
  final int offset;
  final bool hasMore;

  PaginationModel({
    required this.total,
    required this.limit,
    required this.offset,
    required this.hasMore,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      total: json['total'] ?? 0,
      limit: json['limit'] ?? 0,
      offset: json['offset'] ?? 0,
      hasMore: json['hasMore'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'limit': limit,
      'offset': offset,
      'hasMore': hasMore,
    };
  }
}

class CreateBookingResponse {
  final String name;
  final String? notes;
  final String scheduledFor;
  final String customerId;
  final String teamMemberId;
  final List<ServiceItem> services;
  final List<ComboItem> combos;
  final List<ProductItem> products;
  final DiscountModel? discount;
  final String? recurrenceType;
  final String? recurrenceEndDate;

  CreateBookingResponse({
    required this.name,
    this.notes,
    required this.scheduledFor,
    required this.customerId,
    required this.teamMemberId,
    required this.services,
    required this.combos,
    required this.products,
    this.discount,
    this.recurrenceType,
    this.recurrenceEndDate,
  });

  factory CreateBookingResponse.fromJson(Map<String, dynamic> json) {
    return CreateBookingResponse(
      name: json['name'] ?? '',
      notes: json['notes'] ?? '',
      scheduledFor: json['scheduledFor'] ?? '',
      customerId: json['customerId'] ?? '',
      teamMemberId: json['teamMemberId'] ?? '',
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => ServiceItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      combos: (json['combos'] as List<dynamic>?)
              ?.map((e) => ComboItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      products: (json['products'] as List<dynamic>?)
              ?.map((e) => ProductItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      discount: json['discount'] != null
          ? DiscountModel.fromJson(json['discount'] as Map<String, dynamic>)
          : null,
      recurrenceType: json['recurrenceType'],
      recurrenceEndDate: json['recurrenceEndDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'notes': notes,
      'scheduledFor': scheduledFor,
      'customerId': customerId,
      'teamMemberId': teamMemberId,
      'services': services.map((e) => e.toJson()).toList(),
      'combos': combos.map((e) => e.toJson()).toList(),
      'products': products.map((e) => e.toJson()).toList(),
      'discount': discount?.toJson(),
      'recurrenceType': recurrenceType,
      'recurrenceEndDate': recurrenceEndDate,
    };
  }
}

class ServiceItem {
  final String serviceId;
  final int quantity;

  ServiceItem({
    required this.serviceId,
    required this.quantity,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      serviceId: json['serviceId'] ?? '',
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'quantity': quantity,
    };
  }
}

class ComboItem {
  final String comboId;
  final int quantity;

  ComboItem({
    required this.comboId,
    required this.quantity,
  });

  factory ComboItem.fromJson(Map<String, dynamic> json) {
    return ComboItem(
      comboId: json['comboId'] ?? '',
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comboId': comboId,
      'quantity': quantity,
    };
  }
}

class ProductItem {
  final String productId;
  final int quantity;

  ProductItem({
    required this.productId,
    required this.quantity,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      productId: json['productId'] ?? '',
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }
}

class DiscountModel {
  final String type;
  final double value;

  DiscountModel({
    required this.type,
    required this.value,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      type: json['type'] ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
    };
  }
}

class CreateBlockResponse {
  final String name;
  final String teamMemberId;
  final String scheduledFor;
  final int duration;
  final String? notes;
  final String recurrenceType;
  final String recurrenceEndDate;

  CreateBlockResponse({
    required this.name,
    required this.teamMemberId,
    required this.scheduledFor,
    required this.duration,
    this.notes,
    required this.recurrenceType,
    required this.recurrenceEndDate,
  });

  factory CreateBlockResponse.fromJson(Map<String, dynamic> json) {
    return CreateBlockResponse(
      name: json['name'] ?? '',
      teamMemberId: json['teamMemberId'] ?? '',
      scheduledFor: json['scheduledFor'] ?? '',
      duration: json['duration'] ?? 0,
      notes: json['notes'],
      recurrenceType: json['recurrenceType'] ?? '',
      recurrenceEndDate: json['recurrenceEndDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'teamMemberId': teamMemberId,
      'scheduledFor': scheduledFor,
      'duration': duration,
      'notes': notes ?? '',
      'recurrenceType': recurrenceType,
      'recurrenceEndDate': recurrenceEndDate,
    };
  }
}

class SchedulesModel {
  final bool ok;
  final String message;
  final DetailedBookingModel booking;

  SchedulesModel({
    required this.ok,
    required this.message,
    required this.booking,
  });

  factory SchedulesModel.fromJson(Map<String, dynamic> json) {
    return SchedulesModel(
      ok: json['ok'] ?? false,
      message: json['message'] ?? '',
      booking: DetailedBookingModel.fromJson(json['booking'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ok': ok,
      'message': message,
      'booking': booking.toJson(),
    };
  }
}

class DetailedBookingModel {
  final String id;
  final String name;
  final String? notes;
  final String scheduledFor;
  final int duration;
  final String recurrenceType;
  final String recurrenceEndDate;
  final String? parentBookingId;
  final bool isRecurring;
  final double subtotal;
  final String discountType;
  final double totalPrice;
  final String currency;
  final String status;
  final DetailedCustomerModel customer;
  final DetailedTeamMemberModel teamMember;
  final List<BookingServiceModel> services;
  final List<dynamic> combos;
  final List<dynamic> products;
  final DetailedPaymentModel payment;
  final String createdAt;
  final String updatedAt;

  DetailedBookingModel({
    required this.id,
    required this.name,
    this.notes,
    required this.scheduledFor,
    required this.duration,
    required this.recurrenceType,
    required this.recurrenceEndDate,
    this.parentBookingId,
    required this.isRecurring,
    required this.subtotal,
    required this.discountType,
    required this.totalPrice,
    required this.currency,
    required this.status,
    required this.customer,
    required this.teamMember,
    required this.services,
    required this.combos,
    required this.products,
    required this.payment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DetailedBookingModel.fromJson(Map<String, dynamic> json) {
    return DetailedBookingModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      notes: json['notes'],
      scheduledFor: json['scheduledFor'] ?? '',
      duration: json['duration'] ?? 0,
      recurrenceType: json['recurrenceType'] ?? '',
      recurrenceEndDate: json['recurrenceEndDate'] ?? '',
      parentBookingId: json['parentBookingId'],
      isRecurring: json['isRecurring'] ?? false,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      discountType: json['discountType'] ?? '',
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? '',
      status: json['status'] ?? '',
      customer: DetailedCustomerModel.fromJson(json['customer'] ?? {}),
      teamMember: DetailedTeamMemberModel.fromJson(json['teamMember'] ?? {}),
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => BookingServiceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      combos: json['combos'] ?? [],
      products: json['products'] ?? [],
      payment: DetailedPaymentModel.fromJson(json['payment'] ?? {}),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'notes': notes,
      'scheduledFor': scheduledFor,
      'duration': duration,
      'recurrenceType': recurrenceType,
      'recurrenceEndDate': recurrenceEndDate,
      'parentBookingId': parentBookingId,
      'isRecurring': isRecurring,
      'subtotal': subtotal,
      'discountType': discountType,
      'totalPrice': totalPrice,
      'currency': currency,
      'status': status,
      'customer': customer.toJson(),
      'teamMember': teamMember.toJson(),
      'services': services.map((e) => e.toJson()).toList(),
      'combos': combos,
      'products': products,
      'payment': payment.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class DetailedCustomerModel {
  final String id;
  final String name;
  final String phone;
  final String email;

  DetailedCustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  factory DetailedCustomerModel.fromJson(Map<String, dynamic> json) {
    return DetailedCustomerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
    };
  }
}

class DetailedTeamMemberModel {
  final String id;
  final String role;
  final String themeColor;
  final TeamMemberUserModel user;

  DetailedTeamMemberModel({
    required this.id,
    required this.role,
    required this.themeColor,
    required this.user,
  });

  factory DetailedTeamMemberModel.fromJson(Map<String, dynamic> json) {
    return DetailedTeamMemberModel(
      id: json['id'] ?? '',
      role: json['role'] ?? '',
      themeColor: json['themeColor'] ?? '',
      user: TeamMemberUserModel.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'themeColor': themeColor,
      'user': user.toJson(),
    };
  }
}

class TeamMemberUserModel {
  final String id;
  final String name;
  final String? profileImageUrl;

  TeamMemberUserModel({
    required this.id,
    required this.name,
    this.profileImageUrl,
  });

  factory TeamMemberUserModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberUserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profileImageUrl': profileImageUrl,
    };
  }
}

class BookingServiceModel {
  final String id;
  final int quantity;
  final double price;
  final DetailedServiceModel service;

  BookingServiceModel({
    required this.id,
    required this.quantity,
    required this.price,
    required this.service,
  });

  factory BookingServiceModel.fromJson(Map<String, dynamic> json) {
    return BookingServiceModel(
      id: json['id'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      service: DetailedServiceModel.fromJson(json['service'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'price': price,
      'service': service.toJson(),
    };
  }
}

class DetailedServiceModel {
  final String id;
  final String name;
  final int duration;
  final String price;

  DetailedServiceModel({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
  });

  factory DetailedServiceModel.fromJson(Map<String, dynamic> json) {
    return DetailedServiceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      duration: json['duration'] ?? 0,
      price: json['price'] ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'price': price,
    };
  }
}

class DetailedPaymentModel {
  final bool hasTransaction;
  final String status;
  final bool isPaid;
  final double amount;
  final String paymentMethod;
  final String paidAt;
  final String transactionId;

  DetailedPaymentModel({
    required this.hasTransaction,
    required this.status,
    required this.isPaid,
    required this.amount,
    required this.paymentMethod,
    required this.paidAt,
    required this.transactionId,
  });

  factory DetailedPaymentModel.fromJson(Map<String, dynamic> json) {
    return DetailedPaymentModel(
      hasTransaction: json['hasTransaction'] ?? false,
      status: json['status'] ?? '',
      isPaid: json['isPaid'] ?? false,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod'] ?? '',
      paidAt: json['paidAt'] ?? '',
      transactionId: json['transactionId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasTransaction': hasTransaction,
      'status': status,
      'isPaid': isPaid,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'paidAt': paidAt,
      'transactionId': transactionId,
    };
  }
}

class BlocksModel {
  final bool ok;
  final String message;
  final DetailedTimeBlockModel timeBlock;

  BlocksModel({
    required this.ok,
    required this.message,
    required this.timeBlock,
  });

  factory BlocksModel.fromJson(Map<String, dynamic> json) {
    return BlocksModel(
      ok: json['ok'] ?? false,
      message: json['message'] ?? '',
      timeBlock: DetailedTimeBlockModel.fromJson(json['timeBlock'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ok': ok,
      'message': message,
      'timeBlock': timeBlock.toJson(),
    };
  }
}

class DetailedTimeBlockModel {
  final String id;
  final String name;
  final String? notes;
  final String scheduledFor;
  final int duration;
  final String recurrenceType;
  final DetailedTeamMemberModel teamMember;
  final String createdAt;

  DetailedTimeBlockModel({
    required this.id,
    required this.name,
    this.notes,
    required this.scheduledFor,
    required this.duration,
    required this.recurrenceType,
    required this.teamMember,
    required this.createdAt,
  });

  factory DetailedTimeBlockModel.fromJson(Map<String, dynamic> json) {
    return DetailedTimeBlockModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      notes: json['notes'],
      scheduledFor: json['scheduledFor'] ?? '',
      duration: json['duration'] ?? 0,
      recurrenceType: json['recurrenceType'] ?? '',
      teamMember: DetailedTeamMemberModel.fromJson(json['teamMember'] ?? {}),
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'notes': notes,
      'scheduledFor': scheduledFor,
      'duration': duration,
      'recurrenceType': recurrenceType,
      'teamMember': teamMember.toJson(),
      'createdAt': createdAt,
    };
  }
}
