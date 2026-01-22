
class CustomersResponseModel {
  final bool ok;
  final String? message;
  final String? error;
  final List<CustomerModel> customers;
  final PaginationModel pagination;

  CustomersResponseModel({
    required this.ok,
    this.message,
    this.error,
    required this.customers,
    required this.pagination,
  });

  factory CustomersResponseModel.fromJson(Map<String, dynamic> json) {
    return CustomersResponseModel(
      ok: json['ok'] ?? false,
      message: json['message'],
      error: json['error'],
      customers: (json['customers'] as List<dynamic>?)
              ?.map((e) => CustomerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ok': ok,
      'message': message,
      'error': error,
      'customers': customers.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
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
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
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

class CustomerModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final DateTime? birthDate;
  final String? notes;
  final String businessId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? age;

  CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.birthDate,
    this.notes,
    required this.businessId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.age,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      birthDate: json['birthDate'] != null 
          ? DateTime.tryParse(json['birthDate']) 
          : null,
      notes: json['notes'],
      businessId: json['businessId'] ?? '',
      isActive: json['isActive'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'birthDate': birthDate?.toIso8601String(),
      'notes': notes,
      'businessId': businessId,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'age': age,
    };
  }
}

class CreateCustomerModel {
  final String name;
  final String email;
  final String phone;
  final DateTime? birthDate;
  final String? notes;
  final bool isActive;

  CreateCustomerModel({
    required this.name,
    required this.email,
    required this.phone,
    this.birthDate,
    this.notes,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'birthDate': birthDate?.toIso8601String(),
      'notes': notes,
      'isActive': isActive,
    };
  }
}

class BookingModel {
  final String id;
  final String name;
  final String? notes;
  final DateTime scheduledFor;
  final int duration;
  final String status;
  final double totalPrice;
  final String currency;
  final BookingTeamMemberModel teamMember;
  final List<BookingServiceModel> services;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookingModel({
    required this.id,
    required this.name,
    this.notes,
    required this.scheduledFor,
    required this.duration,
    required this.status,
    required this.totalPrice,
    required this.currency,
    required this.teamMember,
    required this.services,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      notes: json['notes'],
      scheduledFor: DateTime.tryParse(json['scheduledFor'] ?? '') ?? DateTime.now(),
      duration: json['duration'] ?? 0,
      status: json['status'] ?? '',
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'BRL',
      teamMember: BookingTeamMemberModel.fromJson(json['teamMember'] ?? {}),
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => BookingServiceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'notes': notes,
      'scheduledFor': scheduledFor.toIso8601String(),
      'duration': duration,
      'status': status,
      'totalPrice': totalPrice,
      'currency': currency,
      'teamMember': teamMember.toJson(),
      'services': services.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class BookingTeamMemberModel {
  final String id;
  final String role;
  final BookingUserModel user;

  BookingTeamMemberModel({
    required this.id,
    required this.role,
    required this.user,
  });

  factory BookingTeamMemberModel.fromJson(Map<String, dynamic> json) {
    return BookingTeamMemberModel(
      id: json['id'] ?? '',
      role: json['role'] ?? '',
      user: BookingUserModel.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'user': user.toJson(),
    };
  }
}

class BookingUserModel {
  final String id;
  final String name;

  BookingUserModel({
    required this.id,
    required this.name,
  });

  factory BookingUserModel.fromJson(Map<String, dynamic> json) {
    return BookingUserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class BookingServiceModel {
  final String id;
  final String name;
  final double price;
  final int duration;

  BookingServiceModel({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
  });

  factory BookingServiceModel.fromJson(Map<String, dynamic> json) {
    return BookingServiceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      duration: json['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'duration': duration,
    };
  }
}

class CustomerWithBookingsModel {
  final String message;
  final CustomerModel customer;
  final List<BookingModel> bookings;

  CustomerWithBookingsModel({
    required this.message,
    required this.customer,
    required this.bookings,
  });

  factory CustomerWithBookingsModel.fromJson(Map<String, dynamic> json) {
    return CustomerWithBookingsModel(
      message: json['message'] ?? '',
      customer: CustomerModel.fromJson(json['customer'] ?? {}),
      bookings: (json['bookings'] as List<dynamic>?)
              ?.map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'customer': customer.toJson(),
      'bookings': bookings.map((e) => e.toJson()).toList(),
    };
  }
}
