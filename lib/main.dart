import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/language_cubit.dart';
import 'blocs/sound_cubit.dart';
import 'injection_container.dart' as getIt;
import 'ui/app.dart';
import 'utils/shared_preference.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getIt.init();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? language = preferences.getString(SPrefCache.PREF_KEY_LANGUAGE);



  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (_) => LanguageCubit(),
    ),
    BlocProvider(
      create: (_) => SoundCubit(),
    ),
  ], child: MyApp.language(language)));
}
