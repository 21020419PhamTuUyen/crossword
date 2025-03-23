import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/stage_cubit.dart';
import '../../domain/data/models/stage_model.dart';
import '../../domain/repositories/stage_repository.dart';
import '../../res/images.dart';
import '../../routes.dart';
import '../widget/background.dart';
import '../widget/base_screen.dart';
import '../widget/base_stage.dart';
import '/blocs/base_bloc/base_state.dart';
import '/injection_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectStageScreen extends StatelessWidget {
  const SelectStageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StageCubit>(
      create: (_) => StageCubit(repository: getIt.get<StageRepository>()),
      child: SelectStageBody(),
    );
  }
}

class SelectStageBody extends StatefulWidget {
  static List<StageModel> stages = [];

  @override
  _SelectStageScreenState createState() => _SelectStageScreenState();
}

class _SelectStageScreenState extends State<SelectStageBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<StageCubit>().fetchStagesWithPagination(limit: 15);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context
          .read<StageCubit>()
          .fetchStagesWithPagination(limit: 15)
          .then((_) {});
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseScreen(
        body: Stack(
          fit: StackFit.expand,
          children: [
            const Background(),
            Padding(
              padding: EdgeInsets.only(top: 100.h),
              child: BlocBuilder<StageCubit, BaseState>(
                builder: (context, state) {
                  if (state is LoadedState<List<StageModel>>) {
                    SelectStageBody.stages.addAll(state.data);
                  }
                  return SingleChildScrollView(
                    controller: _scrollController,
                    child: Container(
                        color: Colors.blue[200],
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Center(
                              child: Wrap(
                                spacing: 20.0,
                                runSpacing: 16.0,
                                children: SelectStageBody.stages.map((stageData) {
                                  return BaseStage(stage: stageData);
                                }).toList(),
                              ),
                            ),
                            state is LoadingState
                                ? Container(
                                    height: 50.h,
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  )
                                : SizedBox(height: 10),
                          ],
                        )),
                  );
                },
              ),
            ),
            Positioned(
              top: 25.h,
              left: 16.w,
              child: IconButton(
                icon: Image.asset(
                  AppImages.PREVIOUS,
                  height: 40.h,
                  width: 40.w,
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, Routes.selectLevelScreen, (route) => false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
