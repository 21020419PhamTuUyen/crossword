import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/data/models/game_state_model.dart';
import '../domain/data/models/question_model.dart';
import '../domain/data/models/stage_model.dart';
import '../domain/network/response_status.dart';
import '../domain/repositories/game_repository.dart';
import '../domain/repositories/question_repository.dart';
import '../ui/widget/toast.dart';
import 'base_bloc/base_state.dart';

class GameCubit extends Cubit<BaseState> {
  final QuestionRepository questionRepository;
  final GameRepository gameRepository;

  GameCubit({
    required this.gameRepository,
    required this.questionRepository,
  }) : super(InitState());

  void updateData(GameStateModel newData) {
    emit(LoadingState());
    emit(LoadedState(newData));
  }

  void saveGameState() {
    try {
      if (state is LoadedState<GameStateModel>) {
        final game = (state as LoadedState<GameStateModel>).data;
        gameRepository.save(game);
      }else{
        throw ResponseStatus.response500InternalServerError;
      }
    } catch (e) {
      showToast(e.toString());
    }
  }

  void currentStage(StageModel stage) {
    emit(LoadedState(stage));
  }

  Future<void> generateQuestion(StageModel stage) async {
    emit(LoadingState());
    try {
      // fetch questions for the stage
      List<QuestionModel> questionList =
          await questionRepository.findQuestionsByStage(stage.stage!);
      if (questionList.length < 1) {
        throw (ResponseStatus.response404NotFound);
      }
      stage.questions = questionList;
      GameStateModel gameStateModel = await gameRepository.getState(stage);
      emit(LoadedState(gameStateModel));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}
