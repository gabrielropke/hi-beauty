import 'package:hibeauty/core/constants/failures.dart';
import '../domain/repository.dart';
import 'data_source.dart';
import 'model.dart';

class CategorieRepositoryImpl implements CategorieRepository {
  final CategorieRemoteDataSource remote;

  CategorieRepositoryImpl(this.remote);

  @override
  Future<void> createServiceCategorie(CreateCategorieModel model) async {
    try {
      return await remote.createServiceCategorie(model);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> createProductCategorie(CreateCategorieModel model) async {
    try {
      return await remote.createProductCategorie(model);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<CategoriesProductsResponseModel> getProductCategories() async {
    try {
      return await remote.getProductCategories();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}