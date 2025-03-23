import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants.dart';
import '../../domain/data/models/user_model.dart';
import '../../res/images.dart';
import '../../routes.dart';
import '../widget/background.dart';
import '/blocs/base_bloc/base_state.dart';
import '/blocs/cubit.dart';
import '/injection_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: MainBody());
  }
}

class MainBody extends StatelessWidget {

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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Image.asset(
                              AppImages.SETTING,
                              height: 40.h,
                              width: 40.w,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, Routes.settingScreen);
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
                            if (state is LoadedState<UserModel>) {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  Routes.selectLevelScreen, (route) => false);
                            } else {
                              Navigator.pushNamed(context, Routes.loginScreen);
                            }
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.blue[50],
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.w, vertical: 12.h),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.play,
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
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.scoreScreen);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.blue[50],
                            // màu nền xanh dương nhạt
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.w, vertical: 12.h),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.score,
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
