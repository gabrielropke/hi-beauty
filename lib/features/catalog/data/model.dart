import 'dart:io';

import 'package:hibeauty/features/team/data/model.dart';

class CatalogResponseModel {
  final bool ok;
  final String? message;
  final String? error;
  final List<ServicesModel> services;
  final PaginationModel pagination;

  CatalogResponseModel({
    required this.ok,
    this.message,
    this.error,
    required this.services,
    required this.pagination,
  });

  factory CatalogResponseModel.fromJson(Map<String, dynamic> json) {
    return CatalogResponseModel(
      ok: json['ok'] ?? false,
      message: json['message'],
      error: json['error'],
      services:
          (json['services'] as List<dynamic>?)
              ?.map((e) => ServicesModel.fromJson(e as Map<String, dynamic>))
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
      'services': services.map((e) => e.toJson()).toList(),
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

class ServicesModel {
  final String id;
  final String name;
  final String? description;
  final String? coverImageUrl;
  final int duration;
  final String locationType;
  final double price;
  final String currency;
  final String visibility;
  final CategoryModel? category;
  final List<TeamMemberModel> teamMembers;
  final String businessId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServicesModel({
    required this.id,
    required this.name,
    this.description,
    this.coverImageUrl,
    required this.duration,
    required this.locationType,
    required this.price,
    required this.currency,
    required this.visibility,
    this.category,
    required this.teamMembers,
    required this.businessId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServicesModel.fromJson(Map<String, dynamic> json) {
    return ServicesModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      coverImageUrl: json['coverImageUrl'],
      duration: json['duration'] ?? 0,
      locationType: json['locationType'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'BRL',
      visibility: json['visibility'] ?? '',
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
      teamMembers:
          (json['teamMembers'] as List<dynamic>?)
              ?.map((e) => TeamMemberModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      businessId: json['businessId'] ?? '',
      isActive: json['isActive'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'coverImageUrl': coverImageUrl,
      'duration': duration,
      'locationType': locationType,
      'price': price,
      'currency': currency,
      'visibility': visibility,
      'category': category?.toJson(),
      'teamMembers': teamMembers.map((e) => e.toJson()).toList(),
      'businessId': businessId,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String color;
  final String type;
  final String description;
  final String businessId;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    required this.color,
    required this.type,
    required this.description,
    required this.businessId,
    required this.isActive,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      color: json['color'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      businessId: json['businessId'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'type': type,
      'description': description,
      'businessId': businessId,
      'isActive': isActive,
    };
  }
}

class ProductCategoryModel {
  final String id;
  final String name;
  final String color;

  ProductCategoryModel({
    required this.id,
    required this.name,
    required this.color,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      color: json['color'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
    };
  }
}

class CreateServiceModel {
  final String name;
  final String? description;
  final File? coverImage;
  final int duration;
  final String locationType;
  final double price;
  final String currency;
  final String visibility;
  final String? categoryId;
  final List<String> teamMemberIds;
  final bool isActive;

  CreateServiceModel({
    required this.name,
    this.description,
    this.coverImage,
    required this.duration,
    required this.locationType,
    required this.price,
    this.currency = 'BRL',
    this.visibility = 'PUBLIC',
    this.categoryId,
    required this.teamMemberIds,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'duration': duration,
      'locationType': locationType,
      'price': price,
      'currency': currency,
      'visibility': visibility,
      'categoryId': categoryId,
      'teamMemberIds': teamMemberIds,
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
      scheduledFor:
          DateTime.tryParse(json['scheduledFor'] ?? '') ?? DateTime.now(),
      duration: json['duration'] ?? 0,
      status: json['status'] ?? '',
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'BRL',
      teamMember: BookingTeamMemberModel.fromJson(json['teamMember'] ?? {}),
      services:
          (json['services'] as List<dynamic>?)
              ?.map(
                (e) => BookingServiceModel.fromJson(e as Map<String, dynamic>),
              )
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
    return {'id': id, 'role': role, 'user': user.toJson()};
  }
}

class BookingUserModel {
  final String id;
  final String name;

  BookingUserModel({required this.id, required this.name});

  factory BookingUserModel.fromJson(Map<String, dynamic> json) {
    return BookingUserModel(id: json['id'] ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
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
    return {'id': id, 'name': name, 'price': price, 'duration': duration};
  }
}

class CustomerWithBookingsModel {
  final String message;
  final ServicesModel customer;
  final List<BookingModel> bookings;

  CustomerWithBookingsModel({
    required this.message,
    required this.customer,
    required this.bookings,
  });

  factory CustomerWithBookingsModel.fromJson(Map<String, dynamic> json) {
    return CustomerWithBookingsModel(
      message: json['message'] ?? '',
      customer: ServicesModel.fromJson(json['customer'] ?? {}),
      bookings:
          (json['bookings'] as List<dynamic>?)
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

class ServiceSearchModel {
  final String? search;
  final String? categoryId;
  final String? locationType;
  final String? visibility;
  final String? teamMemberId;
  final bool? isActive;
  final int? page;
  final int? limit;

  ServiceSearchModel({
    this.search,
    this.categoryId,
    this.locationType,
    this.visibility,
    this.teamMemberId,
    this.isActive,
    this.page,
    this.limit,
  });

  Map<String, String> toQueryParams() {
    final params = <String, String>{};

    if (search != null && search!.isNotEmpty) params['search'] = search!;
    if (categoryId != null && categoryId!.isNotEmpty) {
      params['categoryId'] = categoryId!;
    }
    if (locationType != null && locationType!.isNotEmpty) {
      params['locationType'] = locationType!;
    }
    if (visibility != null && visibility!.isNotEmpty) {
      params['visibility'] = visibility!;
    }
    if (teamMemberId != null && teamMemberId!.isNotEmpty) {
      params['teamMemberId'] = teamMemberId!;
    }
    if (isActive != null) params['isActive'] = isActive.toString();

    if (page != null) params['page'] = page.toString();
    if (limit != null) params['limit'] = limit.toString();

    return params;
  }

  ServiceSearchModel copyWith({
    String? search,
    String? categoryId,
    String? locationType,
    String? visibility,
    String? teamMemberId,
    bool? isActive,
    int? page,
    int? limit,
  }) {
    return ServiceSearchModel(
      search: search ?? this.search,
      categoryId: categoryId ?? this.categoryId,
      locationType: locationType ?? this.locationType,
      visibility: visibility ?? this.visibility,
      teamMemberId: teamMemberId ?? this.teamMemberId,
      isActive: isActive ?? this.isActive,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }
}

class CategoriesServicesResponseModel {
  final bool ok;
  final String? message;
  final String? error;
  final List<CategoriesModel> categories;
  final int total;

  CategoriesServicesResponseModel({
    required this.ok,
    this.message,
    this.error,
    required this.categories,
    required this.total,
  });

  factory CategoriesServicesResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoriesServicesResponseModel(
      ok: json['ok'] ?? false,
      message: json['message'],
      error: json['error'],
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => CategoriesModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ok': ok,
      'message': message,
      'error': error,
      'categories': categories.map((e) => e.toJson()).toList(),
      'total': total,
    };
  }
}

class CategoriesModel {
  final String id;
  final String name;
  final String description;
  final String color;
  final String type;
  final String businessId;
  final int servicesCount;
  final int productsCount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoriesModel({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.type,
    required this.businessId,
    required this.servicesCount,
    required this.productsCount,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      color: json['color'] ?? '',
      type: json['type'] ?? '',
      businessId: json['businessId'] ?? '',
      servicesCount: json['servicesCount'] ?? 0,
      productsCount: json['productsCount'] ?? 0,
      isActive: json['isActive'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color,
      'type': type,
      'businessId': businessId,
      'servicesCount': servicesCount,
      'productsCount': productsCount,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class CreateCategoriesModel {
  final String name;
  final String description;
  final String color;
  final String type;
  final bool isActive;

  CreateCategoriesModel({
    required this.name,
    required this.description,
    required this.color,
    required this.type,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'color': color,
      'type': type,
      'isActive': isActive,
    };
  }
}

// Products Models
class ProductsResponseModel {
  final bool ok;
  final String? message;
  final String? error;
  final List<ProductsModel> products;
  final PaginationModel pagination;

  ProductsResponseModel({
    required this.ok,
    this.message,
    this.error,
    required this.products,
    required this.pagination,
  });

  factory ProductsResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductsResponseModel(
      ok: json['ok'] ?? false,
      message: json['message'],
      error: json['error'],
      products: (json['products'] as List<dynamic>?)
              ?.map((e) => ProductsModel.fromJson(e as Map<String, dynamic>))
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
      'products': products.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class ProductsModel {
  final String id;
  final String name;
  final String? description;
  final String? sku;
  final String? barcode;
  final ProductCategoryModel? category;
  final String? imageUrl;
  final double price;
  final double costPrice;
  final int stock;
  final int lowStockThreshold;
  final bool isLowStock;
  final bool isActive;
  final String businessId;
  final String measurementUnit;
  final double measurementQuantity;
  final String visibility;
  final bool controllingStock;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductsModel({
    required this.id,
    required this.name,
    this.description,
    this.sku,
    this.barcode,
    this.category,
    this.imageUrl,
    required this.price,
    required this.costPrice,
    required this.stock,
    required this.lowStockThreshold,
    required this.isLowStock,
    required this.isActive,
    required this.businessId,
    required this.measurementUnit,
    required this.measurementQuantity,
    required this.visibility,
    required this.controllingStock,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      sku: json['sku'],
      barcode: json['barcode'],
      category: json['category'] != null 
          ? ProductCategoryModel.fromJson(json['category']) 
          : null,
      imageUrl: json['imageUrl'],
      price: (json['price'] ?? 0).toDouble(),
      costPrice: (json['costPrice'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      lowStockThreshold: json['lowStockThreshold'] ?? 0,
      isLowStock: json['isLowStock'] ?? false,
      isActive: json['isActive'] ?? true,
      businessId: json['businessId'] ?? '',
      measurementUnit: json['measurementUnit'] ?? '',
      measurementQuantity: (json['measurementQuantity'] ?? 0).toDouble(),
      visibility: json['visibility'] ?? 'PUBLIC',
      controllingStock: json['controllingStock'] ?? true,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'sku': sku,
      'barcode': barcode,
      'category': category?.toJson(),
      'imageUrl': imageUrl,
      'price': price,
      'costPrice': costPrice,
      'stock': stock,
      'lowStockThreshold': lowStockThreshold,
      'isLowStock': isLowStock,
      'isActive': isActive,
      'businessId': businessId,
      'measurementUnit': measurementUnit,
      'measurementQuantity': measurementQuantity,
      'visibility': visibility,
      'controllingStock': controllingStock,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class CreateProductModel {
  final String name;
  final String? description;
  final String? sku;
  final String? barcode;
  final String? categoryId;
  final File? image;
  final double price;
  final double costPrice;
  final int stock;
  final int lowStockThreshold;
  final String measurementUnit;
  final double measurementQuantity;
  final String visibility;
  final bool controllingStock;
  final bool isActive;

  CreateProductModel({
    required this.name,
    this.description,
    this.sku,
    this.barcode,
    this.categoryId,
    this.image,
    required this.price,
    required this.costPrice,
    required this.stock,
    required this.lowStockThreshold,
    required this.measurementUnit,
    required this.measurementQuantity,
    required this.visibility,
    required this.controllingStock,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'sku': sku,
      'barcode': barcode,
      'categoryId': categoryId,
      'price': price,
      'costPrice': costPrice,
      'stock': stock,
      'lowStockThreshold': lowStockThreshold,
      'measurementUnit': measurementUnit,
      'measurementQuantity': measurementQuantity,
      'visibility': visibility,
      'controllingStock': controllingStock,
      'isActive': isActive,
    };
  }
}

// Combos Models
class CombosResponseModel {
  final bool ok;
  final String? message;
  final String? error;
  final List<CombosModel> combos;
  final int total;

  CombosResponseModel({
    required this.ok,
    this.message,
    this.error,
    required this.combos,
    required this.total,
  });

  factory CombosResponseModel.fromJson(Map<String, dynamic> json) {
    return CombosResponseModel(
      ok: json['ok'] ?? false,
      message: json['message'],
      error: json['error'],
      combos: (json['combos'] as List<dynamic>?)
          ?.map((e) => CombosModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ok': ok,
      'message': message,
      'error': error,
      'combos': combos.map((e) => e.toJson()).toList(),
      'total': total,
    };
  }
}

class ComboResponseModel {
  final bool ok;
  final String? message;
  final String? error;
  final CombosModel? combo;

  ComboResponseModel({
    required this.ok,
    this.message,
    this.error,
    this.combo,
  });

  factory ComboResponseModel.fromJson(Map<String, dynamic> json) {
    return ComboResponseModel(
      ok: json['ok'] ?? false,
      message: json['message'],
      error: json['error'],
      combo: json['combo'] != null
          ? CombosModel.fromJson(json['combo'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ok': ok,
      'message': message,
      'error': error,
      'combo': combo?.toJson(),
    };
  }
}

class CombosModel {
  final String id;
  final String name;
  final String? description;
  final String? coverImageUrl;
  final double price;
  final String currency;
  final double originalPrice;
  final int discount;
  final int totalDuration;
  final String visibility;
  final bool isActive;
  final List<ComboServiceModel> services;
  final List<ComboProductModel> products;
  final String businessId;
  final DateTime createdAt;
  final DateTime updatedAt;

  CombosModel({
    required this.id,
    required this.name,
    this.description,
    this.coverImageUrl,
    required this.price,
    required this.currency,
    required this.originalPrice,
    required this.discount,
    required this.totalDuration,
    required this.visibility,
    required this.isActive,
    required this.services,
    required this.products,
    required this.businessId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CombosModel.fromJson(Map<String, dynamic> json) {
    return CombosModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      coverImageUrl: json['coverImageUrl'],
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'BRL',
      originalPrice: (json['originalPrice'] ?? 0).toDouble(),
      discount: json['discount'] ?? 0,
      totalDuration: json['totalDuration'] ?? 0,
      visibility: json['visibility'] ?? 'PUBLIC',
      isActive: json['isActive'] ?? false,
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => ComboServiceModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => ComboProductModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      businessId: json['businessId'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'coverImageUrl': coverImageUrl,
      'price': price,
      'currency': currency,
      'originalPrice': originalPrice,
      'discount': discount,
      'totalDuration': totalDuration,
      'visibility': visibility,
      'isActive': isActive,
      'services': services.map((e) => e.toJson()).toList(),
      'products': products.map((e) => e.toJson()).toList(),
      'businessId': businessId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class ComboServiceModel {
  final String id;
  final String name;
  final String? description;
  final int duration;
  final double price;
  final String currency;
  final String? coverImageUrl;
  final String? categoryId;
  final int order;

  ComboServiceModel({
    required this.id,
    required this.name,
    this.description,
    required this.duration,
    required this.price,
    required this.currency,
    this.coverImageUrl,
    this.categoryId,
    required this.order,
  });

  factory ComboServiceModel.fromJson(Map<String, dynamic> json) {
    return ComboServiceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      duration: json['duration'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'BRL',
      coverImageUrl: json['coverImageUrl'],
      categoryId: json['categoryId'],
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'duration': duration,
      'price': price,
      'currency': currency,
      'coverImageUrl': coverImageUrl,
      'categoryId': categoryId,
      'order': order,
    };
  }
}

class ComboProductModel {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final String? categoryId;
  final int quantity;
  final int order;

  ComboProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    this.categoryId,
    required this.quantity,
    required this.order,
  });

  factory ComboProductModel.fromJson(Map<String, dynamic> json) {
    return ComboProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'],
      categoryId: json['categoryId'],
      quantity: json['quantity'] ?? 1,
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
      'quantity': quantity,
      'order': order,
    };
  }
}

class CreateComboModel {
  final String name;
  final String? description;
  final File? coverImage;
  final double price;
  final double originalPrice;
  final double discount;
  final int totalDuration;
  final List<String> serviceIds;
  final List<String> productsIds; // Lista de IDs repetidos conforme quantidade
  final String visibility;
  final String currency;

  CreateComboModel({
    required this.name,
    this.description,
    this.coverImage,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.totalDuration,
    required this.serviceIds,
    required this.productsIds, // Lista de IDs repetidos
    required this.visibility,
    this.currency = 'BRL',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'coverImage': coverImage,
      'price': price,
      'originalPrice': originalPrice,
      'discount': discount,
      'totalDuration': totalDuration,
      'serviceIds': serviceIds,
      'productsIds': productsIds, // Envia lista de IDs repetidos
      'visibility': visibility,
      'currency': currency,
    };
  }
}

class ComboProductInput {
  final String productId;
  final int quantity;

  ComboProductInput({
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }
}
