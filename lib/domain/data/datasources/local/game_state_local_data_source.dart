
import '../../../../utils/shared_preference.dart';
import '../../models/game_state_model.dart';

class GameStateLocalDataSource {
  Future<GameStateModel?> getState(int stage) {
    return SharedPreferenceUtil.getGameState(stage);
  }

  Future<void> saveState(GameStateModel game) async {
    await SharedPreferenceUtil.saveGameState(game);
  }
}