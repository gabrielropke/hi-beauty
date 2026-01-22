import 'package:hibeauty/core/constants/failures.dart';
import 'package:hibeauty/core/data/user.dart';
import 'package:hibeauty/features/home/domain/user/repository.dart';

import 'data_source.dart';

class GetUserRepositoryImpl implements GetUserRepository {
  final GetUserRemoteDataSource remote;

  GetUserRepositoryImpl(this.remote);

  @override
  Future<User> fetchInitial() async {
    try {
      return await remote.fetchUser();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
