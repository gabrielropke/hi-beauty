import '../data/model.dart';

abstract class CatalogRepository {
  Future<CatalogResponseModel> getServices(ServiceSearchModel searchModel);
  Future<void> deleteService(String serviceId);
  Future<CategoriesServicesResponseModel> getServiceCategories();
  Future<void> createService(CreateServiceModel model);
  Future<void> updateService(String serviceId, CreateServiceModel model);
  Future<ProductsResponseModel> getProducts();
  Future<void> deleteProduct(String productId);
  Future<void> createProduct(CreateProductModel model);
  Future<void> updateProduct(String productId, CreateProductModel model);
  Future<void> adjustStock(String id, int delta, String reason);
  Future<CombosResponseModel> getCombos();
  Future<void> createCombo(CreateComboModel model);
  Future<void> deleteCombo(String id);
  Future<void> updateCombo(String id, CreateComboModel model);
}

class GetProducts {
  final CatalogRepository repository;
  GetProducts(this.repository);

  Future<ProductsResponseModel> call() {
    return repository.getProducts();
  }
}

class GetServices {
  final CatalogRepository repository;
  GetServices(this.repository);

  Future<CatalogResponseModel> call(ServiceSearchModel searchModel) {
    return repository.getServices(searchModel);
  }
}

class DeleteProduct {
  final CatalogRepository repository;
  DeleteProduct(this.repository);

  Future<void> call(String productId) {
    return repository.deleteProduct(productId);
  }
}

class DeleteService {
  final CatalogRepository repository;
  DeleteService(this.repository);

  Future<void> call(String serviceId) {
    return repository.deleteService(serviceId);
  }
}

class DeleteCombo {
  final CatalogRepository repository;
  DeleteCombo(this.repository);

  Future<void> call(String id) {
    return repository.deleteCombo(id);
  }
}

class GetCategories {
  final CatalogRepository repository;
  GetCategories(this.repository);

  Future<CategoriesServicesResponseModel> call() {
    return repository.getServiceCategories();
  }
}

class CreateService {
  final CatalogRepository repository;
  CreateService(this.repository);

  Future<void> call(CreateServiceModel model) {
    return repository.createService(model);
  }
}

class CreateCombo {
  final CatalogRepository repository;
  CreateCombo(this.repository);

  Future<void> call(CreateComboModel model) {
    return repository.createCombo(model);
  }
}

class UpdateService {
  final CatalogRepository repository;
  UpdateService(this.repository);

  Future<void> call(String serviceId, CreateServiceModel model) {
    return repository.updateService(serviceId, model);
  }
}

class UpdateCombo {
  final CatalogRepository repository;
  UpdateCombo(this.repository);

  Future<void> call(String id, CreateComboModel model) {
    return repository.updateCombo(id, model);
  }
}

class CreateProduct {
  final CatalogRepository repository;
  CreateProduct(this.repository);

  Future<void> call(CreateProductModel model) {
    return repository.createProduct(model);
  }
}

class UpdateProduct {
  final CatalogRepository repository;
  UpdateProduct(this.repository);

  Future<void> call(String productId, CreateProductModel model) {
    return repository.updateProduct(productId, model);
  }
}

class AdjustStock {
  final CatalogRepository repository;
  AdjustStock(this.repository);

  Future<void> call(String id, int delta, String reason) {
    return repository.adjustStock(id, delta, reason);
  }
}

class GetCombos {
  final CatalogRepository repository;
  GetCombos(this.repository);

  Future<CombosResponseModel> call() {
    return repository.getCombos();
  }
}