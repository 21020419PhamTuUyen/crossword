import 'package:crossword/blocs/user_info_cubit.dart';
import 'package:crossword/blocs/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/data/models/stage_model.dart';
import '../domain/data/models/user_model.dart';
import '../domain/repositories/stage_repository.dart';
import '../injection_container.dart';
import '../ui/screen/select_stage_screen.dart';
import 'base_bloc/base_state.dart';

class StageCubit extends Cubit<BaseState> {
  final StageRepository repository;

  StageCubit({required this.repository}) : super(InitState());

  void resetState() {
    emit(InitState());
  }

  Future<void> createStage(StageModel stageModel) async {
    try {
      emit(LoadingState());
      await repository.createStage(stageModel);
      emit(LoadedState('Stage created successfully'));
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }

  Future<void> getStage(int stageId) async {
    try {
      emit(LoadingState());
      StageModel? stageModel = await repository.getStage(stageId);
      if (stageModel != null) {
        emit(LoadedState(stageModel));
      } else {
        emit(ErrorState('Stage not found'));
      }
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }

  Future<void> getAllStages() async {
    try {
      emit(LoadingState());
      List<StageModel> stages = await repository.getAllStages();
      emit(LoadedState(stages));
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }

  Future<void> getAllExtraStages() async {
    try {
      emit(LoadingState());
      List<StageModel> extraStages = await repository.getAllExtraStages();
      emit(LoadedState(extraStages));
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }

  Future<void> deleteStage(String stageId) async {
    try {
      emit(LoadingState());
      await repository.deleteStage(stageId);
      emit(LoadedState('Stage deleted successfully'));
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }

  Future<void> updateStage(
      String stageId, Map<String, dynamic> updatedData) async {
    try {
      emit(LoadingState());
      await repository.updateStage(stageId, updatedData);
      emit(LoadedState('Stage updated successfully'));
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }

  void clearData() {
    SelectStageBody.stages = [];
    repository.clearData();
    emit(InitState());
  }

  Future<void> fetchStagesWithPagination({required int limit}) async {
    emit(LoadingState());
    await Future.delayed(Duration(seconds: 2));
    try {
      var stages = await repository.fetchStagesWithPagination(limit: limit);
      final _state = getIt.get<UserInfoCubit>().state;
      if (_state is LoadedState<UserModel>) {
        UserModel user = _state.data;
        for (var i in stages) {
          if (user.doneStages!.contains(i.stage)) {
            i.done = true;
          }
        }
      }
      emit(LoadedState(stages));
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }

  getChallengeStage() async {
    try {
      var stage = await repository.getChallengeStage();
      emit(LoadedState(stage));
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }
}
