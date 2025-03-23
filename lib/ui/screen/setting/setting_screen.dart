import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../blocs/base_bloc/base_state.dart';
import '../../../blocs/stage_cubit.dart';
import '../../../blocs/user_info_cubit.dart';
import '../../../domain/data/models/user_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../domain/network/response_status.dart';
import '../../../injection_container.dart';
import '../../../res/images.dart';
import '../../widget/base_screen.dart';
import '../../widget/show_animated_dialog.dart';
import '../../widget/toast.dart';
import '../auth/login_screen.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: SettingBody());
  }
}

class SettingBody extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        body: BlocBuilder<UserInfoCubit, BaseState>(
      bloc: getIt.get<UserInfoCubit>(),
      builder: (_, state) {
        if (state is LoadedState) {
          if (state.data == ResponseStatus.response200Ok) {
            showToast(AppLocalizations.of(context)!.logout_success);
            Navigator.of(context).pop();
            getIt.get<UserInfoCubit>().resetState();
          }
        } else if (state is ErrorState) {
          showToast(state.data);
        }
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: const BorderSide(color: Colors.black, width: 3),
          ),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: IconButton(
                    icon: Image.asset(
                      AppImages.CLOSE,
                      height: 24.h,
                      width: 24.w,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(40.sp),
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    SizedBox(height: 30.h),
                    Text(
                      AppLocalizations.of(context)!.setting,
                      style: TextStyle(
                        fontSize: 32.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      (state is LoadedState<UserModel>)
                          ? state.data.username ?? ""
                          : "",
                      style: TextStyle(fontSize: 16.sp, color: Colors.black),
                    ),
                    SizedBox(height: 16.h),
                    // (state is LoadedState<UserModel>)
                    //     ? ElevatedButton.icon(
                    //         onPressed: () {},
                    //         icon: const Icon(Icons.delete_sweep,
                    //             color: Colors.black),
                    //         label: Text(
                    //           Language.of(context)?.getText.call("wipe_data") ??
                    //               "",
                    //           style: const TextStyle(color: Colors.black),
                    //         ),
                    //         style: ElevatedButton.styleFrom(
                    //           padding: const EdgeInsets.symmetric(
                    //               horizontal: 20, vertical: 10),
                    //           textStyle: TextStyle(fontSize: 18.sp),
                    //         ),
                    //       )
                    SizedBox(height: 10.h),
                    SizedBox(height: 16.h),
                    (state is LoadedState<UserModel>)
                        ? ElevatedButton.icon(
                            onPressed: () {
                              getIt.get<UserInfoCubit>().clearData();
                              getIt.get<StageCubit>().clearData();
                            },
                            icon: const Icon(Icons.logout, color: Colors.black),
                            label: Text(
                              AppLocalizations.of(context)!.logout,
                              style: const TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              textStyle: TextStyle(fontSize: 18.sp),
                            ),
                          )
                        : ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                              DialogUtils.showAnimatedDialog(
                                context,
                                const LoginScreen(),
                              );
                            },
                            icon: const Icon(Icons.login, color: Colors.black),
                            label: Text(
                              AppLocalizations.of(context)!.login_lc,
                              style: const TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              textStyle: TextStyle(fontSize: 18.sp),
                            ),
                          ),
                  ]),
                ),
              ],
            ),
          ),
        );
      },
    ));
  }
}
