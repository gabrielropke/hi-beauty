class NotificationsModel {
  final bool ok;
  final List<NotificationModel> notifications;
  final String businessId;
  final PaginationModel pagination;
  final SummaryModel summary;

  NotificationsModel({
    required this.ok,
    required this.notifications,
    required this.businessId,
    required this.pagination,
    required this.summary,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      ok: json['ok'],
      notifications: (json['notifications'] as List)
          .map((e) => NotificationModel.fromJson(e))
          .toList(),
      businessId: json['businessId'],
      pagination: PaginationModel.fromJson(json['pagination']),
      summary: SummaryModel.fromJson(json['summary']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ok': ok,
      'notifications': notifications.map((e) => e.toJson()).toList(),
      'businessId': businessId,
      'pagination': pagination.toJson(),
      'summary': summary.toJson(),
    };
  }
}

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String type;
  final String status;
  final String businessId;
  final String userId;
  final String? bookingId;
  final String? customerId;
  final String? transactionId;
  final String? comissionId;
  final String sentAt;
  final String? readAt;
  final String createdAt;
  final String updatedAt;
  final BusinessModel business;
  final BookingModel? booking;
  final CustomerModel? customer;
  final TransactionModel? transaction;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.businessId,
    required this.userId,
    this.bookingId,
    this.customerId,
    this.transactionId,
    this.comissionId,
    required this.sentAt,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
    required this.business,
    this.booking,
    this.customer,
    this.transaction,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      status: json['status'],
      businessId: json['businessId'],
      userId: json['userId'],
      bookingId: json['bookingId'],
      customerId: json['customerId'],
      transactionId: json['transactionId'],
      comissionId: json['comissionId'],
      sentAt: json['sentAt'],
      readAt: json['readAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      business: BusinessModel.fromJson(json['business']),
      booking: json['booking'] != null 
          ? BookingModel.fromJson(json['booking'])
          : null,
      customer: json['customer'] != null
          ? CustomerModel.fromJson(json['customer'])
          : null,
      transaction: json['transaction'] != null
          ? TransactionModel.fromJson(json['transaction'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'status': status,
      'businessId': businessId,
      'userId': userId,
      'bookingId': bookingId,
      'customerId': customerId,
      'transactionId': transactionId,
      'comissionId': comissionId,
      'sentAt': sentAt,
      'readAt': readAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'business': business.toJson(),
      'booking': booking?.toJson(),
      'customer': customer?.toJson(),
      'transaction': transaction?.toJson(),
    };
  }
}

class BusinessModel {
  final String id;
  final String name;

  BusinessModel({
    required this.id,
    required this.name,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class BookingModel {
  final String id;
  final String name;
  final String scheduledFor;
  final CustomerModel customer;

  BookingModel({
    required this.id,
    required this.name,
    required this.scheduledFor,
    required this.customer,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      name: json['name'],
      scheduledFor: json['scheduledFor'],
      customer: CustomerModel.fromJson(json['customer']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scheduledFor': scheduledFor,
      'customer': customer.toJson(),
    };
  }
}

class CustomerModel {
  final String name;

  CustomerModel({
    required this.name,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class TransactionModel {
  // Adicione os campos necessários quando souber a estrutura da transação
  
  TransactionModel();

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}

class PaginationModel {
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginationModel({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      page: json['page'],
      pageSize: json['pageSize'],
      total: json['total'],
      totalPages: json['totalPages'],
      hasNextPage: json['hasNextPage'],
      hasPreviousPage: json['hasPreviousPage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageSize': pageSize,
      'total': total,
      'totalPages': totalPages,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
    };
  }
}

class SummaryModel {
  final int total;
  final int unread;
  final int read;
  final ByTypeModel byType;

  SummaryModel({
    required this.total,
    required this.unread,
    required this.read,
    required this.byType,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    return SummaryModel(
      total: json['total'],
      unread: json['unread'],
      read: json['read'],
      byType: ByTypeModel.fromJson(json['byType']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'unread': unread,
      'read': read,
      'byType': byType.toJson(),
    };
  }
}

class ByTypeModel {
  final int booking;
  final int payment;
  final int notice;
  final int system;
  final int commission;

  ByTypeModel({
    required this.booking,
    required this.payment,
    required this.notice,
    required this.system,
    required this.commission,
  });

  factory ByTypeModel.fromJson(Map<String, dynamic> json) {
    return ByTypeModel(
      booking: json['booking'],
      payment: json['payment'],
      notice: json['notice'],
      system: json['system'],
      commission: json['commission'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking': booking,
      'payment': payment,
      'notice': notice,
      'system': system,
      'commission': commission,
    };
  }
}
