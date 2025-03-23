
import '/domain/data/datasources/datasource.dart';
import '/domain/data/models/models.dart';

class AuthRepository {
  AuthRemoteDataSource remoteDataSource;

  AuthRepository({
    required this.remoteDataSource,
  });

  Future<Map<String, dynamic>> login(UserModel userModel) {
    return remoteDataSource.login(userModel);
  }

  Future<Map<String, dynamic>> register(UserModel userModel) {
    return remoteDataSource.register(userModel);
  }

  Future<Map<String, dynamic>> signInWithFacebook() {
    return remoteDataSource.signInWithFacebook();
  }

  Future<Map<String, dynamic>> signInWithGoogle() {
    return remoteDataSource.signInWithGoogle();
  }

}
