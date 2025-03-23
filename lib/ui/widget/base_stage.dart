import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../blocs/game_cubit.dart';
import '../../domain/data/models/stage_model.dart';
import '../../injection_container.dart';
import '../../res/images.dart';
import '../../routes.dart';

class BaseStage extends StatefulWidget {
  final StageModel stage;

  BaseStage({super.key, required this.stage});

  @override
  State<BaseStage> createState() => _StageTileState();
}

class _StageTileState extends State<BaseStage> {

  @override
  Widget build(BuildContext context) {
    // Color? tileColor = done ? Colors.grey[700] : Colors.grey[400];

    return GestureDetector(
        onTap: () async {
          getIt<GameCubit>().currentStage(widget.stage);
          Navigator.pushNamed(context,
              Routes.gamePlayScreen);
        },
        child: Container(
          width: 120.w,
          height: 120.h,
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.STAGE),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Transform.translate(
                  offset: Offset(-10.0, 0.0),
                  child: Text(
                    widget.stage.stage.toString(),
                    style: TextStyle(fontSize: 35.sp, color: Colors.black87),
                  ),
                ),
              ),
              if (widget.stage.done ?? false)
                Center(
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 36.sp,
                  ),
                ),
            ],
          ),
        ));
  }
}
