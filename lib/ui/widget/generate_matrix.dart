import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../blocs/game_cubit.dart';
import '../../domain/data/models/game_state_model.dart';
import '../../injection_container.dart';
import '../../utils/movement.dart';

generateMatrix(context, int gridSize, GameStateModel state) {
  List<Widget> rows = [];
  int adder = 0;
  for (int i = 1; i <= gridSize; i++) {
    rows.add(
        Row(children: generateRow(context, gridSize, state, adder: adder)));
    adder += gridSize;
  }
  return rows;
}

generateRow(context, int gridSize, GameStateModel state, {int adder = 0}) {
  List<Widget> cells = [];
  for (int i = 1; i <= gridSize; i++) {
    cells.add(letterCell(context,
        gridSize: gridSize, index: i + adder, state: state));
  }
  return cells;
}

letterCell(context,
    {required int gridSize,
    required int index,
    required GameStateModel state}) {
  Color primaryColor = Colors.white;
  bool isDisabled = true;
  bool isSelected = false;
  bool isDone = false;
  String qid = '';
  String currentLetter = '';

  for (var cell in state.stage!.inputCell) {
    if (cell.contains(index)) {
      try {
        isDisabled = false;
        int cellIndex = state.stage!.inputCell.indexOf(cell);
        if (index == state.stage!.questions![cellIndex].qid) {
          qid = state.stage!.questions![cellIndex].id.toString();
        }
      } catch (e) {
        print(e);
      }
    }
  }

  if (state.currentSelectedQuestion.length == 1) {
    if (state.currentSelectedQuestion[0].contains(index)) {
      try {
        isSelected = true;
      } catch (e) {
        print(e);
      }
    }
  } else if (state.currentSelectedQuestion.length == 2) {
    if (state.isHorizontal) {
      if (state.currentSelectedQuestion[0].contains(index)) {
        try {
          isSelected = true;
        } catch (e) {
          print(e);
        }
      }
    } else {
      if (state.currentSelectedQuestion[1].contains(index)) {
        try {
          isSelected = true;
        } catch (e) {
          print(e);
        }
      }
    }
  }

  if (state.isDoneIndex!.contains(index)) {
    isDone = true;
  }

  primaryColor = isDisabled ? Colors.transparent : primaryColor;
  if (isDone) {
    primaryColor = Colors.yellow.shade300;
  } else if (!isDisabled && state.currentSelectedIndex == index) {
    primaryColor = Colors.blueAccent.shade100;
  } else if (!isDisabled && isSelected) {
    primaryColor = Colors.blueAccent.withOpacity(0.5);
  }

  for (var cells in state.answers) {
    for (var cell in cells[0]) {
      if (cell[0] == index) {
        currentLetter = cell[2];
      }
    }
  }

  return GestureDetector(
    onTap: () {
      if (!state.isDoneIndex!.contains(index) && !isDisabled) {
        if (index == state.currentSelectedIndex) {
          state.isHorizontal = !state.isHorizontal;
          if (state.isHorizontal) {
            state.id = state.stage!.inputCell
                    .indexOf(state.currentSelectedQuestion[0]) +
                1;
          } else {
            if (state.currentSelectedQuestion.length == 1) {
              state.id = state.stage!.inputCell
                      .indexOf(state.currentSelectedQuestion[0]) +
                  1;
            } else {
              state.id = state.stage!.inputCell
                      .indexOf(state.currentSelectedQuestion[1]) +
                  1;
            }
          }
        } else {
          state.currentSelectedQuestion =
              checkInputCell(state.stage!.inputCell, index);
          if (state.currentSelectedQuestion.isNotEmpty) {
            state.currentSelectedIndex = index;
            state.id = updateIdFromIndex(state.stage!.inputCell, index) + 1;
            state.isHorizontal = true;
          }
        }
        getIt.get<GameCubit>().updateData(state);
      }
    },
    child: Container(
      height: (ScreenUtil().screenWidth - 20.w) / gridSize,
      width: (ScreenUtil().screenWidth - 20.w) / gridSize,
      decoration: BoxDecoration(
        color: !isDisabled ? primaryColor : Colors.transparent,
        border: Border.all(
          color: !isDisabled? Colors.black : Colors.transparent,
          width: state.currentSelectedIndex == index ? 2 : 1,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Text(
              qid,
              style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              !isDisabled ? currentLetter : '',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ),
  );
}
