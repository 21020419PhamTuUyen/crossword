import 'package:crossword/domain/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../blocs/base_bloc/base_state.dart';
import '../../blocs/score_cubit.dart';
import '../../blocs/user_info_cubit.dart';
import '../../domain/data/models/score_model.dart';
import '../../domain/repositories/score_repository.dart';
import '../../injection_container.dart';
import '../../res/colors.dart';
import '../../res/images.dart';
import '../../routes.dart';
import '../widget/base_loading.dart';
import '../widget/base_screen.dart';

class ScoreScreen extends StatelessWidget {
  const ScoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScoreCubit>(
        create: (_) => ScoreCubit(repository: getIt.get<ScoreRepository>()), child: ScoreBody());
  }
}

class ScoreBody extends StatefulWidget {
  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreBody> {
  late UserModel user;
  List<ScoreModel> rankingList = [];
  String? stt = 'Not found';

  @override
  void initState() {
    super.initState();
    getIt.get<ScoreCubit>().getAllScoresSortedByScore();
    final userInfoCubit = getIt.get<UserInfoCubit>();
    if (userInfoCubit.state is LoadedState<UserModel>) {
      user = (userInfoCubit.state as LoadedState<UserModel>).data;
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Xảy ra lỗi vui lòng thử lại sau")),
      );
      Navigator.pushNamedAndRemoveUntil(context, Routes.mainScreen,(route) => false);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      findUserPositionString();
    });
  }


  commonText(text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.black,
        fontSize: 20.sp,
      ),
    );
  }

  void findUserPositionString() {
    for(var i in rankingList){
      print(i.userId);
    }
    int position = rankingList.indexWhere((player) => player.userId == user.id);
    String r = '';
    if (position == -1) {
      r =  "Not found";
    } else if (position >= 100) {
      r =  "50+";
    } else {
      r = (position + 1).toString();
    }
      stt = r;
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        loadingWidget: CustomLoading<ScoreCubit>(),
        body: BlocBuilder<ScoreCubit, BaseState>(
            bloc: getIt.get<ScoreCubit>(),
            builder: (_, state) {
              if (state is LoadedState<List<ScoreModel>>) {
                rankingList = state.data;
                findUserPositionString();
              }
              return Container(
                color: Colors.blue[200],
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15.w),
                      height: 80.h,
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
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.score,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 50.sp, fontFamily: 'Charmonman'),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    Expanded(
                      child: state is LoadingState? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          backgroundColor: AppColors.base_color,
                        ),
                      ) : SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(20.w),
                              child: Center(
                                child: Wrap(
                                  spacing: 16.h,
                                  runSpacing: 16.h,
                                  children: rankingList.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    ScoreModel player = entry.value;

                                    return Container(
                                      padding: EdgeInsets.only(bottom: 5.w),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          commonText('${index + 1}'),
                                          commonText(player.username),
                                          commonText(player.score.toString()),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        color: Colors.black.withOpacity(0.2),
                        height: 70.h,
                        child: Container(
                            padding: EdgeInsets.all(20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                commonText(stt),
                                commonText(user.username),
                                commonText(user.score.toString()),
                              ],
                            )))
                  ],
                ),
              );
            }));
  }
}
