import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '/constants.dart';
import '/routes.dart';
import '/utils/navigator.dart';

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  final String? language;

  MyApp.language(this.language);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      navigatorKey: NavigationService.instance.navigatorKey,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      locale: this.language == null
          ? Constants.SUPPORT_LOCALE[0]
          : Locale(this.language ?? Constants.SUPPORT_LOCALE[0].languageCode),
      supportedLocales: Constants.SUPPORT_LOCALE,
      localeResolutionCallback: (locale, supportedLocales) => _localeCallback(locale, supportedLocales),
      initialRoute: Routes.initScreen(),
      onGenerateRoute: Routes.generateRoute,
    );
  }

  Locale _localeCallback(Locale? locale, Iterable<Locale> supportedLocales) {
    if (locale == null) {
      return supportedLocales.first;
    }
    // Check if the current device locale is supported
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }
    // If the locale of the device is not supported, use the first one
    // from the list (japanese, in this case).
    return supportedLocales.first;
  }
}
