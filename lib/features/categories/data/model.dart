import 'package:hibeauty/features/catalog/data/model.dart';

class CreateCategorieModel {
  final String name;
  final String description;
  final String color;

  CreateCategorieModel({
    required this.name,
    required this.description,
    required this.color,
  });

  factory CreateCategorieModel.fromJson(Map<String, dynamic> json) {
    return CreateCategorieModel(
      name: json['name'] as String,
      description: json['description'] as String,
      color: json['color'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'color': color,
    };
  }
}

class CategoriesProductsResponseModel {
  final bool ok;
  final String? message;
  final String? error;
  final List<CategoriesModel> categories;
  final int total;

  CategoriesProductsResponseModel({
    required this.ok,
    this.message,
    this.error,
    required this.categories,
    required this.total,
  });

  factory CategoriesProductsResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoriesProductsResponseModel(
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