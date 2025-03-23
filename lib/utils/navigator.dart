import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../routes.dart';
import '../ui/widget/custom_dialog.dart';

class NavigationService {
  NavigationService._internal();

  static final NavigationService instance = NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  pushReplacement(String routeName) {
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
    navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  popToRootView() {
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }

  pop() {
    navigatorKey.currentState?.pop();
  }

  popWithParam(param) {
    navigatorKey.currentState?.pop(param);
  }

  showDialogTokenExpired() {
    BuildContext? context = navigatorKey.currentState?.overlay?.context;
    if (context == null) {
      return;
    }
    String? message = AppLocalizations.of(context)!.token_expired_message;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CustomDialog(
        content: message,
        onSubmit: () {
          pushReplacement(Routes.loginScreen);
        },
      ),
    );
  }
}
