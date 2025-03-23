import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/data/models/score_model.dart';
import '../domain/data/models/user_model.dart';
import '../domain/repositories/score_repository.dart';
import '../blocs/utils.dart';
import 'base_bloc/base_state.dart';

class ScoreCubit extends Cubit<BaseState> {
  final ScoreRepository repository;

  ScoreCubit({required this.repository}) : super(InitState());

  void resetState() {
    emit(InitState());
  }

  Future<void> createScore(UserModel score) async {
    try {
      emit(LoadingState());
      await repository.createScore(score);
      emit(LoadedState('Score created successfully'));
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }

  Future<void> updateScore(UserModel user) async {
    try {
      emit(LoadingState());
      await repository.updateScore(user);
      emit(LoadedState('Score updated successfully'));
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }

  Future<void> getAllScoresSortedByScore() async {
    try {
      emit(LoadingState());
      List<ScoreModel> scores = await repository.getAllScoresSortedByScore();
      emit(LoadedState(scores));
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }
}
