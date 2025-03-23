import 'package:crossword/domain/data/datasources/remote/score_remote_data_source.dart';
import 'package:flutter/material.dart';

import '../blocs/base_bloc/base_state.dart';
import '../blocs/game_cubit.dart';
import '../blocs/sound_cubit.dart';
import '../blocs/user_info_cubit.dart';
import '../domain/data/models/game_state_model.dart';
import '../domain/data/models/user_model.dart';
import '../injection_container.dart';
import '../res/sounds.dart';
import '../ui/screen/select_stage_screen.dart';
import '../ui/widget/winning_dialog.dart';

checkInputCell(inputCell, selectedIndex) {
  var contains = [];
  inputCell.forEach((cell) {
    if (cell.contains(selectedIndex)) {
      contains += [cell];
    }
  });
  return contains;
}

updateIdFromIndex(inputCell, index) {
  for (var cell in inputCell) {
    if (cell.contains(index)) {
      int cellIndex = inputCell.indexOf(cell);
      return cellIndex;
    }
  }
}

generateAnswers(stage) {
  var answers = [];
  for (int i = 0; i < stage.inputCell.length; i++) {
    List<List<dynamic>> questionAnswer = [];
    for (int j = 0; j < stage.inputCell[i].length; j++) {
      questionAnswer.add([
        stage.inputCell[i][j],
        stage.questions![i].answer![j].toUpperCase(),
        ""
      ]);
    }
    answers.add([questionAnswer, false]);
  }
  return answers;
}

checkAnswer(answers) {
  for (int i = 0; i < answers.length; i++) {
    bool isDone = true;
    if (answers[i][1] == false) {
      var quest = answers[i][0];
      for (int j = 0; j < quest.length; j++) {
        if (quest[j][1] != quest[j][2]) {
          isDone = false;
          break;
        }
      }
      if (isDone) {
        answers[i][1] = isDone;
        return [i, answers];
      }
    }
  }
  return [-1, answers];
}

moveForwardCondition(currentSelectedQuestion, index, isDoneIndex) {
  int pos = currentSelectedQuestion.indexOf(index);
  pos++;
  if (pos == currentSelectedQuestion.length) {
    pos = currentSelectedQuestion.length - 1;
  }
  while (isDoneIndex.contains(currentSelectedQuestion[pos])) {
    pos++;
    if (pos == currentSelectedQuestion.length) {
      pos = 0;
    }
  }
  return currentSelectedQuestion[pos];
}

moveBackCondition(currentSelectedQuestion, index, isDoneIndex) {
  int pos = currentSelectedQuestion.indexOf(index);
  pos--;
  if (pos == -1) {
    pos = 0;
  }
  while (isDoneIndex.contains(currentSelectedQuestion[pos])) {
    pos--;
    if (pos == -1) {
      pos = currentSelectedQuestion.indexOf(index);
    }
  }
  return currentSelectedQuestion[pos];
}

updateChosenIndex(GameStateModel state, index) {
  state.id = index;
  state.isShowQuestion = false;
  state.currentSelectedIndex = state.stage!.questions![state.id! - 1].qid;
  var i =
      state.stage!.inputCell[state.id! - 1].indexOf(state.currentSelectedIndex);
  while (state.isDoneIndex!.contains(state.currentSelectedIndex)) {
    i++;
    state.currentSelectedIndex = state.stage!.inputCell[state.id! - 1][i];
  }
  state.currentSelectedQuestion =
      checkInputCell(state.stage!.inputCell, state.currentSelectedIndex);
  state.isHorizontal = state.stage!.questions![state.id! - 1].isHorizontal;
  getIt.get<GameCubit>().updateData(state);
}

incrementIndex(GameStateModel state) {
  if (state.id! < state.stage!.questions!.length) {
    state.id = (state.id ?? 0) + 1;
  } else {
    state.id = 1;
  }
  while (state.isDoneQuestion!.contains(state.id)) {
    if (state.id! < state.stage!.questions!.length) {
      state.id = (state.id ?? 0) + 1;
    } else {
      state.id = 1;
    }
  }
  state.currentSelectedIndex = state.stage!.questions![state.id! - 1].qid;
  var i =
      state.stage!.inputCell[state.id! - 1].indexOf(state.currentSelectedIndex);
  while (state.isDoneIndex!.contains(state.currentSelectedIndex)) {
    i++;
    state.currentSelectedIndex = state.stage!.inputCell[state.id! - 1][i];
  }
  state.currentSelectedQuestion =
      checkInputCell(state.stage!.inputCell, state.currentSelectedIndex);
  state.isHorizontal = state.stage!.questions![state.id! - 1].isHorizontal;
  getIt.get<GameCubit>().updateData(state);
}

decrementIndex(GameStateModel state) {
  if (state.id! > 1) {
    state.id = (state.id ?? 2) - 1;
  } else {
    state.id = (state.stage!.questions!.length);
  }
  while (state.isDoneQuestion!.contains(state.id)) {
    if (state.id! > 1) {
      state.id = (state.id ?? 2) - 1;
    } else {
      state.id = (state.stage!.questions!.length);
    }
  }
  state.currentSelectedIndex = state.stage!.questions![state.id! - 1].qid;
  var i =
      state.stage!.inputCell[state.id! - 1].indexOf(state.currentSelectedIndex);
  while (state.isDoneIndex!.contains(state.currentSelectedIndex)) {
    i++;
    state.currentSelectedIndex = state.stage!.inputCell[state.id! - 1][i];
  }
  state.currentSelectedQuestion =
      checkInputCell(state.stage!.inputCell, state.currentSelectedIndex);
  state.isHorizontal = state.stage!.questions![state.id! - 1].isHorizontal;
  getIt.get<GameCubit>().updateData(state);
}

Future<void> _showWinningDialog(BuildContext context,seconds) async {
  showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return WinningDialog(
          seconds: seconds,
          hasNextStage: false,
        );
      });
}

onTextInput(String text, GameStateModel state, BuildContext context) {
  getIt.get<SoundCubit>().playMusic(AppSounds.ADD_LETTER);
  if (text != '') {
    for (var cells in state.answers) {
      for (var cell in cells[0]) {
        if (cell[0] == state.currentSelectedIndex) {
          cell[2] = text.toUpperCase();
        }
      }
    }
    if (state.isHorizontal) {
      state.currentSelectedIndex = moveForwardCondition(
          state.currentSelectedQuestion[0],
          state.currentSelectedIndex,
          state.isDoneIndex);
    } else {
      if (state.currentSelectedQuestion.length == 1) {
        state.currentSelectedIndex = moveForwardCondition(
            state.currentSelectedQuestion[0],
            state.currentSelectedIndex,
            state.isDoneIndex);
      } else {
        state.currentSelectedIndex = moveForwardCondition(
            state.currentSelectedQuestion[1],
            state.currentSelectedIndex,
            state.isDoneIndex);
      }
    }
    var result = checkAnswer(state.answers);
    var indexDone = result[0];
    state.answers = result[1];
    if (indexDone != -1) {
      for (var cell in state.answers[indexDone][0]) {
        state.isDoneIndex!.add(cell[0]);
      }
      state.stage!.questions![indexDone].done = true;
      state.isDoneIndex = state.isDoneIndex!.toSet().toList();
      state.isDoneQuestion!.add(indexDone + 1);
      if (state.stage!.isChallenge!) {
        final _state = getIt.get<UserInfoCubit>().state;
        if (_state is LoadedState<UserModel>) {
          UserModel user = _state.data;
          int score = user.score ?? 0;
          score += 10;
          user.score = score;
          getIt.get<UserInfoCubit>().saveUserInfo(user);
          getIt.get<ScoreRemoteDataSource>().updateScore(user);
        }
      }
      if (state.isDoneQuestion!.length == state.stage!.questions!.length) {
        state.isWin = true;
        getIt.get<SoundCubit>().playMusic(AppSounds.WINNING);
        _showWinningDialog(context,state.seconds);
        final _state = getIt.get<UserInfoCubit>().state;
        if (_state is LoadedState<UserModel>) {
          UserModel user = _state.data;
          user.doneStages!.add(state.stage!.stage);
          int suggestion = user.suggestion ?? 3;
          suggestion += 1;
          user.suggestion = suggestion;
          state.suggestion = suggestion;
          getIt.get<UserInfoCubit>().saveUserInfo(user);
        }
        if (!state.stage!.isChallenge!) {
          SelectStageBody.stages[state.stage!.stage! - 1].done = true;
        }
      }
      if (!state.isWin!) {
        incrementIndex(state);
      }
    }
    getIt.get<GameCubit>().updateData(state);
  }
}

onDeleteText(GameStateModel state) {
  for (var cells in state.answers) {
    for (var cell in cells[0]) {
      if (cell[0] == state.currentSelectedIndex) {
        if (cell[2] != "") {
          cell[2] = "";
        } else {
          if (state.isHorizontal) {
            state.currentSelectedIndex = moveBackCondition(
                state.currentSelectedQuestion[0],
                state.currentSelectedIndex,
                state.isDoneIndex);
          } else {
            if (state.currentSelectedQuestion.length == 1) {
              state.currentSelectedIndex = moveBackCondition(
                  state.currentSelectedQuestion[0],
                  state.currentSelectedIndex,
                  state.isDoneIndex);
            } else {
              state.currentSelectedIndex = moveBackCondition(
                  state.currentSelectedQuestion[1],
                  state.currentSelectedIndex,
                  state.isDoneIndex);
            }
          }
          break;
        }
      }
    }
  }
  getIt.get<GameCubit>().updateData(state);
}
