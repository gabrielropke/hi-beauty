part of 'catalog_bloc.dart';

abstract class CatalogState extends Equatable {
  const CatalogState();

  @override
  List<Object?> get props => [];
}

class CatalogInitial extends CatalogState {}

class CatalogLoading extends CatalogState {}

class CatalogLoaded extends CatalogState {
  final Map<String, String> message;
  final bool loading;
  final List<ServicesModel> services;
  final List<CategoriesModel> serviceCategories;
  final List<CategoriesModel> productCategories;
  final List<ProductsModel> products;
  final TeamResponseModel team;
  final List<CombosModel> combos;

  const CatalogLoaded({
    this.message = const {'': ''},
    this.loading = false,
    this.services = const [],
    this.serviceCategories = const [],
    this.productCategories = const [],
    this.products = const [],
    required this.team,
    this.combos = const [],
  });

  CatalogLoaded copyWith({
    ValueGetter<Map<String, String>>? message,
    ValueGetter<bool>? loading,
    ValueGetter<List<ServicesModel>>? services,
    ValueGetter<List<CategoriesModel>>? serviceCategories,
    ValueGetter<List<CategoriesModel>>? productCategories,
    ValueGetter<List<ProductsModel>>? products,
    ValueGetter<TeamResponseModel>? team,
    ValueGetter<List<CombosModel>>? combos,
  }) {
    return CatalogLoaded(
      message: message != null ? message() : this.message,
      loading: loading != null ? loading() : this.loading,
      services: services != null ? services() : this.services,
      serviceCategories: serviceCategories != null ? serviceCategories() : this.serviceCategories,
      productCategories: productCategories != null ? productCategories() : this.productCategories,
      products: products != null ? products() : this.products,
      team: team != null ? team() : this.team,
      combos: combos != null ? combos() : this.combos,
    );
  }

  @override
  List<Object?> get props => [
    message,
    loading,
    services,
    serviceCategories,
    productCategories,
    products,
    team,
    combos,
  ];
}

class CatalogEmpty extends CatalogState {}

class CatalogFailure extends CatalogState {}
