import 'dart:async';


import '../blocs/game_cubit.dart';
import '../domain/data/models/game_state_model.dart';
import '../injection_container.dart';

String formatTime(int seconds) {
  int minutes = seconds ~/ 60;
  int remainingSeconds = seconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
}

class TimerManager {
  Timer? timer;
  int seconds = 0; // Biến lưu trữ thời gian tạm thời

  // Hàm bắt đầu đếm thời gian (chỉ cập nhật `seconds` trong Timer)
  void startTimer(GameStateModel game) {
    if (timer != null && timer!.isActive) return;

    // Nếu game.seconds đã có giá trị thì tiếp tục từ giá trị đó
    seconds = game.seconds ?? 0;

    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      seconds++;// Chỉ cập nhật `seconds`, không cập nhật `game.seconds`
      game.seconds = seconds;
      getIt.get<GameCubit>().updateData(game);
    });
  }

  // Hàm dừng đếm thời gian và cập nhật `game.seconds`
  void stopTimer() {
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
  }

  // Hàm reset thời gian về 0
  void resetTimer(GameStateModel game) {
    stopTimer(); // Dừng timer nếu đang chạy
    seconds = 0; // Đặt lại `seconds`
    game.seconds = 0; // Đặt lại `game.seconds`
    getIt.get<GameCubit>().updateData(game);
  }

  // Kiểm tra xem timer có đang hoạt động không
  bool isTimerActive() {
    return timer != null && timer!.isActive;
  }
}
