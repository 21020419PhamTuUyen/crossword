import 'package:crossword/domain/data/models/stage_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/game_cubit.dart';
import '../../blocs/stage_cubit.dart';
import '../../constants.dart';
import '../../domain/repositories/stage_repository.dart';
import '../../res/images.dart';
import '../../routes.dart';
import '../widget/background.dart';
import '/blocs/base_bloc/base_state.dart';
import '/blocs/cubit.dart';
import '/injection_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectLevelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: SelectLevelBody());
  }
}

class SelectLevelBody extends StatelessWidget {
  final StageCubit cubit = StageCubit(repository: getIt.get<StageRepository>());


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocBuilder<UserInfoCubit, BaseState>(
          bloc: getIt.get<UserInfoCubit>(),
          builder: (_, state) {
            return Stack(
              fit: StackFit.expand,
              children: [
                const Background(),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Image.asset(
                              AppImages.PREVIOUS,
                              height: 40.h,
                              width: 40.w,
                            ),
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  Routes.mainScreen, (route) => false);
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Image.asset(
                          AppImages.LOGO,
                          width: 250.w,
                          height: 200.h,
                        ),
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Text(
                          Constants.CROSSWORD,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 65.sp,
                              fontFamily: 'Charmonman'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: Container(
                        width: 200.w,
                        child: FilledButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(context,
                                Routes.selectStageScreen, (route) => false);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.blue[50],
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.w, vertical: 12.h),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.practice,
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    Center(
                      child: Container(
                        width: 200.w,
                        child: FilledButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              barrierDismissible: false, // Không cho người dùng tắt dialog khi đang tải
                              builder: (context) {
                                return Center(child: CircularProgressIndicator());
                              },
                            );
                            await cubit.getChallengeStage();
                            if(cubit.state is LoadedState<StageModel?>){
                              final stageState = cubit.state as LoadedState<StageModel?>;
                              Navigator.pop(context);
                              if (stageState.data != null) {
                                getIt<GameCubit>().currentStage(stageState.data!); // Cập nhật stage vào GameCubit
                                Navigator.pushNamed(context, Routes.gamePlayScreen); // Điều hướng
                              } else {
                                // Hiển thị thông báo nếu không tìm thấy Challenge Stage
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Không tìm thấy màn chơi thử thách!")),
                                );
                              }
                            }else{
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Xảy ra lỗi vui lòng thử lại sau")),
                              );
                            }
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.blue[50],
                            // màu nền xanh dương nhạt
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.w, vertical: 12.h),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.challenge,
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: Colors.black, // chữ màu đen
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            );
          },
        ));
  }
}
