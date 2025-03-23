
import '/domain/data/models/models.dart';
import '/utils/shared_preference.dart';

class UserLocalDataSource {
  Future<UserModel?> getUserInfo() {
    return SharedPreferenceUtil.getUserInfo();
  }

  Future<void> saveUserInfo(UserModel user) async {
    await SharedPreferenceUtil.saveToken(user.id!);
    await SharedPreferenceUtil.saveUserInfo(user);
  }
}
