import 'dart:convert';
import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/core/data/base_remote_data_source.dart';
import 'package:hibeauty/core/data/user.dart';
import 'package:hibeauty/core/data/secure_storage.dart';

abstract class GetUserRemoteDataSource {
  Future<User> fetchUser();
}

class GetUserRemoteDataSourceImpl extends BaseRemoteDataSource
    implements GetUserRemoteDataSource {
  GetUserRemoteDataSourceImpl({super.client, super.baseUrl, super.timeout});

  @override
  Future<User> fetchUser() async {
    final uri = buildUri('v1/auth/me');
    final res = await getJson(
      uri,
      headers: {
        'accept': 'application/json',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    if (res.statusCode != 200) {
      final apiFailure = ApiFailure.fromResponse(res);
      throw apiFailure;
    }

    final responseData = json.decode(res.body) as Map<String, dynamic>;

    // Manter o userSessionToken atual
    final currentUser = UserService().currentUser;
    final updatedUserData = {
      ...responseData,
      'userSessionToken': currentUser?.userSessionToken ?? '',
    };

    final user = User.fromMap(updatedUserData);

    // Salvar usuário atualizado no UserService e SecureStorage
    UserService().setUser(user);
    await SecureStorage.saveUser(user);

    return user;
  }
}
