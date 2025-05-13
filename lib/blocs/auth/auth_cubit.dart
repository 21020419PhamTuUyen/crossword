import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/data/models/user_model.dart';
import '../../domain/network/response_status.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../utils/shared_preference.dart';
import '../base_bloc/base_state.dart';
import '../utils.dart';

class AuthCubit extends Cubit<BaseState> {
  final AuthRepository repositoryImpl;

  AuthCubit({required this.repositoryImpl}) : super(InitState());

  doLogin(UserModel userModel) async {
    try {
      emit(LoadingState());
      await repositoryImpl
          .login(userModel).then((value) async {
        if (value['status'] == ResponseStatus.response200Ok) {
          await SharedPreferenceUtil.saveToken(value['data'].id);
          emit(LoadedState(value['data']));
        }else{
          emit(ErrorState(BlocUtils.getMessageError(value['status'])));
        }
      });
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }

  doSignUp(UserModel userModel) async {
    try {
      emit(LoadingState());
      await repositoryImpl
          .register(userModel).then((value) async {
        if (value['status'] == ResponseStatus.response201Created) {
          await SharedPreferenceUtil.saveToken(value['data'].id);
          emit(LoadedState(value['data']));
        } else {
          emit(ErrorState(BlocUtils.getMessageError(value['status'])));
        }
      });
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }

  doSignInWithFacebook() async {
    try {
      emit(LoadingState());
      await repositoryImpl
          .signInWithFacebook().then((value) async {
        if (value['status'] == ResponseStatus.response200Ok) {
          emit(LoadedState(value['data']));
        }else{
          emit(ErrorState(BlocUtils.getMessageError(value['status'])));
        }
      });
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }

  doSignInWithGoogle() async {
    try {
      emit(LoadingState());
      await repositoryImpl
          .signInWithGoogle().then((value) async {
        if (value['status'] == ResponseStatus.response200Ok) {
          emit(LoadedState(value['data']));
        }else{
          emit(ErrorState(BlocUtils.getMessageError(value['status'])));
        }
      });
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }


}
