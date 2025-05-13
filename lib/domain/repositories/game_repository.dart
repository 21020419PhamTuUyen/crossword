
import '../../blocs/base_bloc/base_state.dart';
import '../../blocs/user_info_cubit.dart';
import '../../injection_container.dart';
import '../../utils/movement.dart';
import '../data/datasources/local/game_state_local_data_source.dart';
import '../data/models/game_state_model.dart';
import '../data/models/stage_model.dart';
import '../data/models/user_model.dart';

class GameRepository {
  GameStateLocalDataSource localDataSource;

  GameRepository({
    required this.localDataSource,
  });

  Future<GameStateModel> getState(StageModel stage) async {
    try {
      GameStateModel? game;
      UserModel? user;

      game = await localDataSource.getState(stage.stage!);
      final _state = getIt.get<UserInfoCubit>().state;

      if (_state is LoadedState<UserModel>) {
        user = _state.data;
      }

      print(game?.stage!.isSameInputCell(stage));

      if(game != null && game.stage != null && game.stage!.isSameInputCell(stage)){
        return game;
      }

      game = GameStateModel()
        ..id = 1
        ..stage = stage
        ..currentSelectedIndex = stage.inputCell[0][0]
        ..currentSelectedQuestion = checkInputCell(stage.inputCell, stage.inputCell[0][0])
        ..isHorizontal = true
        ..answers = generateAnswers(stage)
        ..isDoneIndex = []
        ..isDoneQuestion = []
        ..suggestion = user?.suggestion ?? 0
        ..seconds = 0
        ..isWin = false;

      return game;
    } catch (e) {
      print('Error in getState: $e');
      return Future.error(e);
    }
  }




  Future<void> save(GameStateModel game) async {
    try {
      await localDataSource.saveState(game);
    } catch (e) {
      print(e);
    }
  }
}
