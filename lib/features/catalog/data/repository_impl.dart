import 'package:hibeauty/core/constants/failures.dart';
import '../domain/repository.dart';
import 'data_source.dart';
import 'model.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogRemoteDataSource remote;

  CatalogRepositoryImpl(this.remote);

  @override
  Future<CatalogResponseModel> getServices([
    ServiceSearchModel? searchModel,
  ]) async {
    try {
      return await remote.getServices(searchModel);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ProductsResponseModel> getProducts() async {
    try {
      return await remote.getProducts();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteService(String serviceId) async {
    try {
      return await remote.deleteService(serviceId);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteProduct(String productId) async {
    try {
      return await remote.deleteProduct(productId);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteCombo(String id) async {
    try {
      return await remote.deleteCombo(id);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<CategoriesServicesResponseModel> getServiceCategories() async {
    try {
      return await remote.getServiceCategories();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> createService(CreateServiceModel model) async {
    try {
      return await remote.createService(model);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> createCombo(CreateComboModel model) async {
    try {
      return await remote.createCombo(model);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateService(String serviceId, CreateServiceModel model) async {
    try {
      return await remote.updateService(serviceId, model);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateCombo(String comboId, CreateComboModel model) async {
    try {
      return await remote.updateCombo(comboId, model);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> createProduct(CreateProductModel model) async {
    try {
      return await remote.createProduct(model);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateProduct(String productId, CreateProductModel model) async {
    try {
      return await remote.updateProduct(productId, model);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> adjustStock(String id, int delta, String reason) async {
    try {
      return await remote.adjustStock(id, delta, reason);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<CombosResponseModel> getCombos() async {
    try {
      return await remote.getCombos();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
