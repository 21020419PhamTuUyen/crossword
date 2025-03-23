import 'package:crossword/ui/screen/auth/login_screen.dart';
import 'package:crossword/ui/screen/auth/signup_screen.dart';
import 'package:crossword/ui/screen/game_play_screen.dart';
import 'package:crossword/ui/screen/main_screen.dart';
import 'package:crossword/ui/screen/score_screen.dart';
import 'package:crossword/ui/screen/select_level_screen.dart';
import 'package:crossword/ui/screen/select_stage_screen.dart';
import 'package:crossword/ui/screen/setting/setting_screen.dart';
import 'package:crossword/ui/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Routes {
  Routes._();

  //screen name
  static const String splashScreen = "/splashScreen";
  static const String loginScreen = "/loginScreen";
  static const String signupScreen = "/signupScreen";
  static const String mainScreen = "/mainScreen";
  static const String homeScreen = "/homeScreen";
  static const String settingScreen = "/settingScreen";
  static const String selectLevelScreen = "/selectLevelScreen";
  static const String selectStageScreen = "/selectStageScreen";
  static const String gamePlayScreen = "/gamePlayScreen";
  static const String scoreScreen = "/scoreScreen";

  //init screen name
  static String initScreen() => splashScreen;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mainScreen:
        return PageTransition(child: MainScreen(), type: PageTransitionType.fade);
      case splashScreen:
        return PageTransition(child: SplashScreen(), type: PageTransitionType.fade);
      case loginScreen:
        return PageTransition(child: LoginScreen(), type: PageTransitionType.fade);
      case signupScreen:
        return PageTransition(child: SignupScreen(), type: PageTransitionType.fade);
      case settingScreen:
        return PageTransition(child: SettingScreen(), type: PageTransitionType.fade);
      case selectLevelScreen:
        return PageTransition(child: SelectLevelScreen(), type: PageTransitionType.fade);
      case selectStageScreen:
        return PageTransition(child: SelectStageScreen(), type: PageTransitionType.fade);
      case gamePlayScreen:
        return PageTransition(child: GamePlayScreen(), type: PageTransitionType.fade);
      case scoreScreen:
        return PageTransition(child: ScoreScreen(), type: PageTransitionType.fade);
      default:
        return MaterialPageRoute(builder: (context) => Container());
    }
  }
}
