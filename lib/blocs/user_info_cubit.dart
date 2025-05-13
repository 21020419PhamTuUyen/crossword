import 'package:crossword/blocs/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/data/models/user_model.dart';
import '../domain/network/response_status.dart';
import '../domain/repositories/user_repository.dart';
import '../utils/shared_preference.dart';
import 'base_bloc/base_state.dart';


class UserInfoCubit extends Cubit<BaseState> {
  final UserRepository repository;

  UserInfoCubit({required this.repository}) : super(InitState());

  void resetState() {
    emit(InitState());
  }

  getUserInfo(String token) async {
    try {
      emit(LoadingState());
      UserModel userModel = await repository.getUserInfo(token);
      if(userModel.id == null){
        userModel.id = token;
      }
      emit(LoadedState(userModel));
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }

  saveUserInfo(UserModel user) async {
    try{
      emit(LoadingState());
      await repository.saveUserInfo(user);
      emit(LoadedState(user));
    }catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }

  Future<void> clearData() async {
    try{
      emit(LoadingState());
      await SharedPreferenceUtil.clearData();
      emit(LoadedState(ResponseStatus.response200Ok));
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }

}
