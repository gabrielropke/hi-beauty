
import '../data/model.dart';

abstract class CategorieRepository {
  Future<void> createServiceCategorie(CreateCategorieModel model);
  Future<void> createProductCategorie(CreateCategorieModel model);
  Future<CategoriesProductsResponseModel> getProductCategories();
}

class CreateCategorie {
  final CategorieRepository repository;
  CreateCategorie(this.repository);

  Future<void> call(CreateCategorieModel model) {
    return repository.createServiceCategorie(model);
  }
}

class CreateProductCategorie {
  final CategorieRepository repository;
  CreateProductCategorie(this.repository);

  Future<void> call(CreateCategorieModel model) {
    return repository.createProductCategorie(model);
  }
}

class GetProductCategories {
  final CategorieRepository repository;
  GetProductCategories(this.repository);

  Future<CategoriesProductsResponseModel> call() {
    return repository.getProductCategories();
  }
}