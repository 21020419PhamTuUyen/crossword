import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';
import '../localizations.dart';


class LanguageCubit extends Cubit<String> {
  LanguageCubit() : super(Constants.VI);

  void changeLanguage(String language) async {
    await LanguageDelegate().load(Locale(language));
    emit(language);
  }
}
