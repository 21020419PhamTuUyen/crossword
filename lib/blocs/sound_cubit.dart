import 'package:crossword/blocs/utils.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/network/response_status.dart';
import 'base_bloc/base_state.dart';

class SoundCubit extends Cubit<BaseState> {

  SoundCubit() : super(InitState());

  void resetState() {
    emit(InitState());
  }

  Future<void> playMusic(String music) async {
    try {
      emit(LoadingState());
      FlameAudio.play(music);
      emit(LoadedState(ResponseStatus.response200Ok));
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }

  Future<void> playBackgroundMusic(String music) async {
    try {
      emit(LoadingState());
      FlameAudio.bgm.initialize();
      FlameAudio.bgm.play(music);
      emit(LoadedState(ResponseStatus.response200Ok));
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }

  Future<void> resume() async {
    try {
      emit(LoadingState());
      FlameAudio.bgm.resume();
      emit(LoadedState(ResponseStatus.response200Ok));
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }


  Future<void> pauseMusic() async {
    try {
      emit(LoadingState());
      FlameAudio.bgm.pause();
      emit(LoadedState(ResponseStatus.response200Ok));
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }

  Future<void> stopMusic() async {
    try {
      emit(LoadingState());
      FlameAudio.bgm.stop();
      emit(LoadedState(ResponseStatus.response200Ok));
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }

}
