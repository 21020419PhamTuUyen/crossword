
import '../network/response_status.dart';
import '/domain/data/datasources/datasource.dart';
import '/domain/data/models/models.dart';

abstract class UserRepository {
  final UserLocalDataSource userLocalDataSource;
  final UserRemoteDataSource userRemoteDataSource;

  UserRepository(this.userLocalDataSource, this.userRemoteDataSource);

  Future<UserModel> getUserInfo(String email);
  Future<void> saveUserInfo(UserModel user);
}

class UserRepositoryImpl extends UserRepository {
  UserRepositoryImpl(
      {required UserLocalDataSource userLocalDataSource, required UserRemoteDataSource userRemoteDataSource})
      : super(userLocalDataSource, userRemoteDataSource);

  @override
  Future<UserModel> getUserInfo(String token) async {
    UserModel? userModel;
    try {
      userModel = await userRemoteDataSource.getUserInfo(token);
    } catch (e) {
      userModel = await userLocalDataSource.getUserInfo();
    }
    if (userModel == null) {
      return Future.error(NotFoundException());
    }
    return userModel;
  }

  @override
  Future<void> saveUserInfo(UserModel user) async {
    try{
      await userLocalDataSource.saveUserInfo(user);
      await userRemoteDataSource.updateUser(user.id!, user.toMap()).then((value)=>{
        if(value['status'] != ResponseStatus.response200Ok){
          throw value['data']
        }
      });
    }catch(e){
      print(e);
    }
  }
}
