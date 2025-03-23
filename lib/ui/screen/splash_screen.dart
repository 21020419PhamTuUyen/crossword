import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_config/flutter_config.dart';

import '../../blocs/sound_cubit.dart';
import '../../blocs/user_info_cubit.dart';
import '../../injection_container.dart';
import '../../res/sounds.dart';
import '/res/resources.dart';
import '/routes.dart';
import '/utils/shared_preference.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:scale_size/scale_size.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashState();
  }
}

class _SplashState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  Animation<Color?>? _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 10), // 10 giây để chạy từ 0 đến 1
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller!)
      ..addListener(() {
        setState(() {});
      });

    _colorAnimation = ColorTween(
            begin: Colors.blue[100], // Xanh dương nhạt
            end: Colors.blue[700] // Xanh dương đậm
            )
        .animate(_controller!);

    _controller!.forward();

    SchedulerBinding.instance.addPostFrameCallback((_) => openScreen(context));
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScaleSize.init(context, designWidth: 375, designHeight: 812);

    int percentage = (_animation!.value * 100).toInt(); // tính toán phần trăm

    return Scaffold(
      body: Container(
        color: AppColors.base_color,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.BACKGROUND),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Center(
              child: SizedBox(
                height: 300,
                width: 300,
                child: LiquidCustomProgressIndicator(
                    value: _animation!.value,
                    valueColor: AlwaysStoppedAnimation(_colorAnimation!.value!),
                    backgroundColor: Colors.white,
                    direction: Axis.vertical,
                    center: Text(
                      "$percentage%", // hiển thị phần trăm
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    shapePath: _buildPath(Size(300, 300))),
              ),
            )
          ],
        ),
      ),
    );
  }

  openScreen(BuildContext context) async {
    String token = await SharedPreferenceUtil.getToken();
    try {
      await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyDHDir_8j9UwSwr2PbgoEYJC5hmDiGDcnQ",
              authDomain: "crossword-e69bd.firebaseapp.com",
              projectId: "crossword-e69bd",
              storageBucket: "crossword-e69bd.firebasestorage.app",
              messagingSenderId: "930197604365",
              appId: "1:930197604365:web:23a6cc82fb0a11e833ad44",
              measurementId: "G-8PXQK4R6V4"));
      print('Firebase initialized successfully');
    } catch (e) {
      print('Failed to initialize Firebase: $e');
    }

    await FlutterConfig.loadEnvVariables();

    if (token.isNotEmpty) {
      getIt.get<UserInfoCubit>().getUserInfo(token);
    }
    await Future.delayed(Duration(seconds: 11));
    Navigator.pushNamedAndRemoveUntil(context, Routes.mainScreen, (route) => false);
    getIt.get<SoundCubit>().playBackgroundMusic(AppSounds.BACKGROUND_1);
  }

  Path _buildPath(Size size) {
    Rect rect = Rect.fromLTWH(
      size.width * 0.2,
      size.height * 0.25,
      size.width * 0.6,
      size.height * 0.5,
    );
    return Path()
      ..addOval(rect)
      ..moveTo(size.width * 0.5 - 75, size.height * 0.5 - 43)
      ..quadraticBezierTo(size.width * 0.5 - 60, size.height * 0.5 - 150, size.width * 0.5 - 20, size.height * 0.5 - 74)
      ..moveTo(size.width * 0.5 + 20, size.height * 0.5 - 74)
      ..quadraticBezierTo(size.width * 0.5 + 60, size.height * 0.5 - 150, size.width * 0.5 + 75, size.height * 0.5 - 43)
      ..close();
  }
}
