import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/core/data/base_remote_data_source.dart';
import 'package:hibeauty/core/data/user.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;
import 'model.dart';

abstract class CatalogRemoteDataSource {
  Future<CatalogResponseModel> getServices([ServiceSearchModel? searchModel]);
  Future<ProductsResponseModel> getProducts();
  Future<void> deleteService(String serviceId);
  Future<CategoriesServicesResponseModel> getServiceCategories();
  Future<void> createService(CreateServiceModel model);
  Future<void> updateService(String serviceId, CreateServiceModel model);
  Future<void> createProduct(CreateProductModel model);
  Future<void> updateProduct(String productId, CreateProductModel model);
  Future<void> deleteProduct(String productId);
  Future<void> adjustStock(String id, int delta, String reason);
  Future<CombosResponseModel> getCombos();
  Future<void> createCombo(CreateComboModel model);
  Future<void> deleteCombo(String id);
  Future<void> updateCombo(String id, CreateComboModel model);
}

class CatalogRemoteDataSourceImpl extends BaseRemoteDataSource
    implements CatalogRemoteDataSource {
  CatalogRemoteDataSourceImpl({super.client, super.baseUrl, super.timeout});

  @override
  Future<CombosResponseModel> getCombos() async {
    final uri = buildUri('v1/services/combos', {'isActive': 'true'});

    final res = await getJson(
      uri,
      headers: {
        'accept': 'application/json',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;

    final decoded =
        jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

    return CombosResponseModel.fromJson(decoded);
  }

  @override
  Future<void> createCombo(CreateComboModel model) async {
    try {
      final uri = Uri.parse('${dotenv.env['API_URL']}/v1/services/combos');

      final request = http.MultipartRequest('POST', uri);

      final brandId = await BrandLoader.getBrandHeader();
      final authToken = UserData.userSessionToken;

      request.headers.addAll({
        'accept': 'application/json',
        'Authorization': 'Bearer $authToken',
        'X-Brand-Id': brandId,
      });

      // Campos obrigatórios
      request.fields['name'] = model.name;
      request.fields['price'] = model.price.toString();

      // Se a lista estiver vazia, envie string vazia
      request.fields['serviceIds'] = model.serviceIds.isNotEmpty ? model.serviceIds.join(',') : '';
      request.fields['productIds'] = model.productsIds.isNotEmpty ? model.productsIds.join(',') : '';

      // Campos opcionais
      if (model.description != null && model.description!.isNotEmpty) {
        request.fields['description'] = model.description!;
      }

      request.fields['currency'] = model.currency;
      request.fields['visibility'] = model.visibility;

      // Imagem do combo (opcional)
      if (model.coverImage != null && await model.coverImage!.exists()) {
        final ext = p.extension(model.coverImage!.path).toLowerCase();
        String mimeType = 'image/jpeg';
        if (ext == '.png') mimeType = 'image/png';
        if (ext == '.webp') mimeType = 'image/webp';

        request.files.add(
          await http.MultipartFile.fromPath(
            'coverImage',
            model.coverImage!.path,
            contentType: MediaType('image', mimeType.split('/')[1]),
          ),
        );
      } else {
        request.fields['coverImage'] = '';
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streamedResponse);

      // Validação de resposta usando ApiFailure
      final apiFailure = ApiFailure.fromResponse(response);
      if (!apiFailure.ok) throw apiFailure;
    } catch (e) {
      if (e is ApiFailure) {
        rethrow;
      }
      rethrow;
    }
  }

  @override
  Future<ProductsResponseModel> getProducts() async {
    final uri = buildUri('v1/products');

    final res = await getJson(
      uri,
      headers: {
        'accept': 'application/json',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;

    final decoded =
        jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

    return ProductsResponseModel.fromJson(decoded);
  }

  @override
  Future<CatalogResponseModel> getServices([
    ServiceSearchModel? searchModel,
  ]) async {
    final finalSearchModel = searchModel ?? ServiceSearchModel();
    final queryParams = finalSearchModel.toQueryParams();

    final uri = buildUri('v1/services', queryParams);

    final res = await getJson(
      uri,
      headers: {
        'accept': '*/*',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;

    final decoded =
        jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

    return CatalogResponseModel.fromJson(decoded);
  }

  @override
  Future<void> adjustStock(String id, int delta, String reason) async {
    final uri = buildUri('v1/products/$id/adjust-stock');

    final res = await patchJson(
      uri,
      headers: {
        'accept': 'application/json',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
      body: {'delta': delta, 'reason': reason},
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;
  }

  @override
  Future<void> deleteService(String serviceId) async {
    final uri = buildUri('v1/services/$serviceId');

    final res = await deleteJson(
      uri,
      body: {},
      headers: {
        'accept': '*/*',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;
  }

  @override
  Future<void> deleteCombo(String id) async {
    final uri = buildUri('v1/services/combos/$id');

    final res = await deleteJson(
      uri,
      body: {},
      headers: {
        'accept': '*/*',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;
  }

  @override
  Future<void> deleteProduct(String productId) async {
    final uri = buildUri('v1/products/$productId');

    final res = await deleteJson(
      uri,
      body: {},
      headers: {
        'accept': '*/*',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;
  }

  @override
  Future<CategoriesServicesResponseModel> getServiceCategories() async {
    final uri = buildUri('v1/services/categories', {'isActive': 'true'});

    final res = await getJson(
      uri,
      headers: {
        'accept': 'application/json',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;

    final decoded =
        jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

    return CategoriesServicesResponseModel.fromJson(decoded);
  }

  @override
  Future<void> createService(CreateServiceModel model) async {
    try {
      final uri = Uri.parse('${dotenv.env['API_URL']}/v1/services');

      final request = http.MultipartRequest('POST', uri);

      final brandId = await BrandLoader.getBrandHeader();
      final authToken = UserData.userSessionToken;

      request.headers.addAll({
        'accept': 'application/json',
        'Authorization': 'Bearer $authToken',
        'X-Brand-Id': brandId,
      });

      // Campos obrigatórios
      request.fields['name'] = model.name;
      request.fields['duration'] = model.duration.toString();
      request.fields['locationType'] = model.locationType;
      request.fields['price'] = model.price.toString();
      request.fields['currency'] = model.currency;
      request.fields['visibility'] = model.visibility;
      request.fields['isActive'] = model.isActive.toString();
      for (var id in model.teamMemberIds) {
        request.files.add(http.MultipartFile.fromString("teamMemberIds", id));
      }
      // Campos opcionais
      if (model.description != null && model.description!.isNotEmpty) {
        request.fields['description'] = model.description!;
      }
      if (model.categoryId != null && model.categoryId!.isNotEmpty) {
        request.fields['categoryId'] = model.categoryId!;
      }

      // Imagem de capa (opcional)
      if (model.coverImage != null && await model.coverImage!.exists()) {
        final ext = p.extension(model.coverImage!.path).toLowerCase();
        String mimeType = 'image/jpeg';
        if (ext == '.png') mimeType = 'image/png';
        if (ext == '.webp') mimeType = 'image/webp';

        request.files.add(
          await http.MultipartFile.fromPath(
            'coverImage',
            model.coverImage!.path,
            contentType: MediaType('image', mimeType.split('/')[1]),
          ),
        );
      } else {
        request.fields['coverImage'] = '';
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streamedResponse);

      // Validação de resposta usando ApiFailure
      final apiFailure = ApiFailure.fromResponse(response);
      if (!apiFailure.ok) throw apiFailure;
    } catch (e) {
      if (e is ApiFailure) {
        rethrow;
      }
      rethrow;
    }
  }

  @override
  Future<void> updateService(String serviceId, CreateServiceModel model) async {
    try {
      final uri = Uri.parse('${dotenv.env['API_URL']}/v1/services/$serviceId');

      final request = http.MultipartRequest('PATCH', uri);

      final brandId = await BrandLoader.getBrandHeader();
      final authToken = UserData.userSessionToken;

      request.headers.addAll({
        'accept': 'application/json',
        'Authorization': 'Bearer $authToken',
        'X-Brand-Id': brandId,
      });

      // Campos obrigatórios
      request.fields['name'] = model.name;
      request.fields['duration'] = model.duration.toString();
      request.fields['locationType'] = model.locationType;
      request.fields['price'] = model.price.toString();
      request.fields['currency'] = model.currency;
      request.fields['visibility'] = model.visibility;
      request.fields['isActive'] = model.isActive.toString();
      for (var id in model.teamMemberIds) {
        request.files.add(http.MultipartFile.fromString("teamMemberIds", id));
      }

      // Campos opcionais
      if (model.description != null && model.description!.isNotEmpty) {
        request.fields['description'] = model.description!;
      }
      if (model.categoryId != null && model.categoryId!.isNotEmpty) {
        request.fields['categoryId'] = model.categoryId!;
      }

      // Imagem de capa (opcional)
      if (model.coverImage != null && await model.coverImage!.exists()) {
        final ext = p.extension(model.coverImage!.path).toLowerCase();
        String mimeType = 'image/jpeg';
        if (ext == '.png') mimeType = 'image/png';
        if (ext == '.webp') mimeType = 'image/webp';

        request.files.add(
          await http.MultipartFile.fromPath(
            'coverImage',
            model.coverImage!.path,
            contentType: MediaType('image', mimeType.split('/')[1]),
          ),
        );
      } else {
        request.fields['coverImage'] = '';
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streamedResponse);

      // Validação de resposta usando ApiFailure
      final apiFailure = ApiFailure.fromResponse(response);
      if (!apiFailure.ok) throw apiFailure;
    } catch (e) {
      if (e is ApiFailure) {
        rethrow;
      }
      rethrow;
    }
  }

  @override
  Future<void> createProduct(CreateProductModel model) async {
    try {
      final uri = Uri.parse('${dotenv.env['API_URL']}/v1/products');

      final request = http.MultipartRequest('POST', uri);

      final brandId = await BrandLoader.getBrandHeader();
      final authToken = UserData.userSessionToken;

      request.headers.addAll({
        'accept': 'application/json',
        'Authorization': 'Bearer $authToken',
        'X-Brand-Id': brandId,
      });

      // Campos obrigatórios
      request.fields['name'] = model.name;
      request.fields['price'] = model.price.toString();

      // Campos opcionais
      if (model.description != null && model.description!.isNotEmpty) {
        request.fields['description'] = model.description!;
      }
      if (model.sku != null && model.sku!.isNotEmpty) {
        request.fields['sku'] = model.sku!;
      }
      if (model.barcode != null && model.barcode!.isNotEmpty) {
        request.fields['barcode'] = model.barcode!;
      }
      if (model.categoryId != null && model.categoryId!.isNotEmpty) {
        request.fields['category'] = model.categoryId!;
      }

      request.fields['controllingStock'] = model.controllingStock.toString();

      request.fields['costPrice'] = model.costPrice.toString();

      request.fields['stock'] = model.stock.toString();

      request.fields['lowStockThreshold'] = model.lowStockThreshold.toString();

      // Imagem do produto (opcional)
      if (model.image != null && await model.image!.exists()) {
        final ext = p.extension(model.image!.path).toLowerCase();
        String mimeType = 'image/jpeg';
        if (ext == '.png') mimeType = 'image/png';
        if (ext == '.webp') mimeType = 'image/webp';

        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            model.image!.path,
            contentType: MediaType('image', mimeType.split('/')[1]),
          ),
        );
      } else {
        request.fields['image'] = '';
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streamedResponse);

      // Validação de resposta usando ApiFailure
      final apiFailure = ApiFailure.fromResponse(response);
      if (!apiFailure.ok) throw apiFailure;
    } catch (e) {
      if (e is ApiFailure) {
        rethrow;
      }
      rethrow;
    }
  }

  @override
  Future<void> updateCombo(String id, CreateComboModel model) async {
    try {
      final uri = Uri.parse('${dotenv.env['API_URL']}/v1/services/combos/$id');

      final request = http.MultipartRequest('PATCH', uri);
      final brandId = await BrandLoader.getBrandHeader();
      final authToken = UserData.userSessionToken;

      request.headers.addAll({
        'accept': 'application/json',
        'Authorization': 'Bearer $authToken',
        'X-Brand-Id': brandId,
      });

      // Campos obrigatórios
      request.fields['name'] = model.name;
      request.fields['price'] = model.price.toString();

      // Se a lista estiver vazia, envie string vazia
      request.fields['serviceIds'] = model.serviceIds.isNotEmpty ? model.serviceIds.join(',') : '';
      request.fields['productIds'] = model.productsIds.isNotEmpty ? model.productsIds.join(',') : '';

      // Campos opcionais
      if (model.description != null && model.description!.isNotEmpty) {
        request.fields['description'] = model.description!;
      }

      request.fields['currency'] = model.currency;
      request.fields['visibility'] = model.visibility;

      // Imagem do combo (opcional)
      if (model.coverImage != null && await model.coverImage!.exists()) {
        final ext = p.extension(model.coverImage!.path).toLowerCase();
        String mimeType = 'image/jpeg';
        if (ext == '.png') mimeType = 'image/png';
        if (ext == '.webp') mimeType = 'image/webp';

        request.files.add(
          await http.MultipartFile.fromPath(
            'coverImage',
            model.coverImage!.path,
            contentType: MediaType('image', mimeType.split('/')[1]),
          ),
        );
      } else {
        request.fields['coverImage'] = '';
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streamedResponse);

      // Validação de resposta usando ApiFailure
      final apiFailure = ApiFailure.fromResponse(response);
      if (!apiFailure.ok) throw apiFailure;
    } catch (e) {
      if (e is ApiFailure) {
        rethrow;
      }
      rethrow;
    }
  }

  @override
  Future<void> updateProduct(String productId, CreateProductModel model) async {
    try {
      final uri = Uri.parse('${dotenv.env['API_URL']}/v1/products/$productId');

      final request = http.MultipartRequest('PATCH', uri);

      final brandId = await BrandLoader.getBrandHeader();
      final authToken = UserData.userSessionToken;

      request.headers.addAll({
        'accept': 'application/json',
        'Authorization': 'Bearer $authToken',
        'X-Brand-Id': brandId,
      });

      // Todos os campos são opcionais no PATCH
      if (model.name.isNotEmpty) {
        request.fields['name'] = model.name;
      }
      if (model.description != null && model.description!.isNotEmpty) {
        request.fields['description'] = model.description!;
      }
      if (model.sku != null && model.sku!.isNotEmpty) {
        request.fields['sku'] = model.sku!;
      }
      if (model.barcode != null && model.barcode!.isNotEmpty) {
        request.fields['barcode'] = model.barcode!;
      }
      if (model.categoryId != null && model.categoryId!.isNotEmpty) {
        request.fields['category'] = model.categoryId!;
      }
      if (model.price > 0) {
        request.fields['price'] = model.price.toString();
      }
      if (model.costPrice > 0) {
        request.fields['costPrice'] = model.costPrice.toString();
      }
      // Adicionar isActive se necessário (baseado no swagger)
      request.fields['isActive'] = 'true';

      request.fields['controllingStock'] = model.controllingStock.toString();

      request.fields['stock'] = model.stock.toString();

      request.fields['lowStockThreshold'] = model.lowStockThreshold.toString();

      // Imagem do produto (opcional)
      if (model.image != null && await model.image!.exists()) {
        final ext = p.extension(model.image!.path).toLowerCase();
        String mimeType = 'image/jpeg';
        if (ext == '.png') mimeType = 'image/png';
        if (ext == '.webp') mimeType = 'image/webp';

        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            model.image!.path,
            contentType: MediaType('image', mimeType.split('/')[1]),
          ),
        );
      } else {
        request.fields['image'] = '';
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streamedResponse);

      // Validação de resposta usando ApiFailure
      final apiFailure = ApiFailure.fromResponse(response);
      if (!apiFailure.ok) throw apiFailure;
    } catch (e) {
      if (e is ApiFailure) {
        rethrow;
      }
      rethrow;
    }
  }
}
