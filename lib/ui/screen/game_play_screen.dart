import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../blocs/base_bloc/base_state.dart';
import '../../blocs/game_cubit.dart';
import '../../blocs/sound_cubit.dart';
import '../../blocs/user_info_cubit.dart';
import '../../domain/data/models/game_state_model.dart';
import '../../domain/data/models/stage_model.dart';
import '../../domain/data/models/user_model.dart';
import '../../domain/network/response_status.dart';
import '../../domain/repositories/game_repository.dart';
import '../../domain/repositories/question_repository.dart';
import '../../injection_container.dart';
import '../../res/images.dart';
import '../../res/sounds.dart';
import '../../utils/movement.dart';
import '../../utils/time_counter.dart';
import '../widget/base_loading.dart';
import '../widget/base_screen.dart';
import '../widget/custom_keyboard.dart';
import '../widget/generate_matrix.dart';
import '../widget/icon_with_badge.dart';
import '../widget/question_list.dart';
import '../widget/toast.dart';

class GamePlayScreen extends StatelessWidget {
  const GamePlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getIt.get<SoundCubit>().playBackgroundMusic(AppSounds.BACKGROUND_2);
    return BlocProvider<GameCubit>(
        create: (_) => GameCubit(
            gameRepository: getIt.get<GameRepository>(),
            questionRepository: getIt.get<QuestionRepository>()),
        child: GamePlayBody());
  }
}

class GamePlayBody extends StatefulWidget {
  @override
  _GamePlayScreenState createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayBody> {
  final TimerManager _timerManager = TimerManager();
  String topic = '';

  @override
  void dispose() {
    _timerManager.stopTimer();
    getIt.get<SoundCubit>().playBackgroundMusic(AppSounds.BACKGROUND_1);
    getIt.get<GameCubit>().saveGameState();
    super.dispose();
  }

  int getSuggestion(){
    final _state = getIt.get<UserInfoCubit>().state;
    if(_state is LoadedState<UserModel>){
      UserModel user = _state.data;
      return user.suggestion ?? 3;
    }
    return 0;
  }

  String findText(game) {
    for (var cells in game.answers) {
      if (cells[1] == false) {
        for (var cell in cells[0]) {
          if (cell[0] == game.currentSelectedIndex) {
            return cell[1];
          }
        }
      }
    }
    return '';
  }


  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        loadingWidget: CustomLoading<GameCubit>(),
        body: BlocBuilder<GameCubit, BaseState>(
          bloc: getIt.get<GameCubit>(),
          builder: (_, state) {
            GameStateModel game = new GameStateModel();
            if (state is LoadedState<StageModel>) {
                topic = state.data.topic ?? '';
              getIt.get<GameCubit>().generateQuestion(state.data);
            }
            if (state is LoadedState<GameStateModel>) {
              game = state.data;
              _timerManager.startTimer(game);
            }
            if (state is ErrorState) {
              if (state.data == ResponseStatus.response404NotFound.toString()) {
                showToast(AppLocalizations.of(context)!.cant_get_api);
              } else {
                showToast(state.data);
                print(state.data);
              }
              Navigator.pop(context);
            }
            return Scaffold(
              body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppImages.BACKGROUND),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.only(
                            top: 16.h, left: 8.h, right: 8.h, bottom: 8.h),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Image.asset(
                                AppImages.PREVIOUS,
                                height: 30.h,
                                width: 30.w,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                // Navigator.pushNamedAndRemoveUntil(context,
                                //     Routes.selectStageScreen, (route) => false);
                              },
                            ),
                            const Spacer(),
                            Text(
                              'Time: ${formatTime(game.seconds ?? 0)}',
                              style: TextStyle(
                                  fontSize: 16.sp, color: Colors.black),
                            ),
                            SizedBox(width: 30.w),
                            Row(
                              children: [
                                IconButton(
                                  icon: !game.isShowQuestion!
                                      ? Image.asset(
                                          AppImages.LIST,
                                          height: 24.h,
                                          width: 24.w,
                                        )
                                      : Image.asset(
                                          AppImages.BOARD,
                                          height: 24.h,
                                          width: 24.w,
                                        ),
                                  onPressed: () {
                                      game.isShowQuestion = !game.isShowQuestion!;
                                      getIt.get<GameCubit>().updateData(game);
                                  },
                                ),
                                IconWithBadge(
                                  imagePath: AppImages.LIGHT,
                                  badgeCount: game.suggestion ?? 0,
                                  onPressed: () {
                                    if (game.suggestion != null && game.suggestion! > 0) {
                                      String text = findText(game);
                                      game.isDoneIndex!.add(game.currentSelectedIndex ?? 0);
                                      onTextInput(text,game,context);
                                      int suggestion = game.suggestion ?? 0;
                                      suggestion -= 1;
                                      game.suggestion = suggestion;
                                      final _state = getIt.get<UserInfoCubit>().state;
                                      if(_state is LoadedState<UserModel>){
                                        UserModel user = _state.data;
                                        user.suggestion = suggestion;
                                        getIt.get<UserInfoCubit>().saveUserInfo(user);
                                      }
                                      getIt.get<GameCubit>().updateData(game);
                                    } else if (getSuggestion() == 0) {
                                      showToast(AppLocalizations.of(context)!.out_of_suggestion);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Text('${AppLocalizations.of(context)!.topic}: ${topic}'),
                      ),
                      Expanded(
                        child: !game.isShowQuestion!
                            ? Center(
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 8.h,
                                        left: 8.h,
                                        right: 8.h,
                                        bottom: 8.h),
                                    child: state is LoadedState<GameStateModel>
                                        ? SingleChildScrollView(
                                          child: Column(
                                              children: generateMatrix(context,
                                                  game.stage!.gridSize!, game)),
                                        )
                                        : Container()))
                            : Container(
                                color: Colors.white,
                                child: QuestionList(
                                    game: game),
                              ),
                      ),
                  Container(
                    height: 60,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          color: Colors.blue,
                          onPressed: () {
                            if (state is LoadedState<GameStateModel>) {
                              decrementIndex(game);
                            }
                          },
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.h),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical, // Cho phép cuộn dọc
                              child: Text(
                                game.stage != null
                                    ? game.stage!.questions![game.id! - 1].question ??
                                    AppLocalizations.of(context)!.loading
                                    : AppLocalizations.of(context)!.loading,
                                style: TextStyle(fontSize: 14.sp),
                                textAlign: TextAlign.center,
                                softWrap: true, // Đảm bảo xuống dòng khi cần
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          color: Colors.blue,
                          onPressed: () {
                            if (state is LoadedState<GameStateModel>) {
                              incrementIndex(game);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  CustomKeyboard(
                        onTextInput: (String text) {
                          onTextInput(text, game,context);
                        },
                        onBackSpace: () {
                          onDeleteText(game);
                        },
                      ),
                    ],
                  )),
            );
          },
        ));
  }
}
