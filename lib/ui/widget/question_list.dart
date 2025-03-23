import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/data/models/game_state_model.dart';
import '../../utils/movement.dart';

class QuestionList extends StatelessWidget {
  final GameStateModel game;

  QuestionList({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: game.stage!.questions!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  if (!game.stage!.questions![index].done!) {
                    updateChosenIndex(game, index + 1);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(16.h),
                  child: Text(
                    '${index + 1}. ${game.stage!.questions![index].question}',
                    style: game.stage!.questions![index].done!
                        ? TextStyle(
                            fontSize: 18.sp,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          )
                        : TextStyle(
                            fontSize: 18.sp,
                          ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                color: Colors.grey,
                height: 1,
                thickness: 1,
              );
            },
          ),
        ),
      ],
    );
  }
}
