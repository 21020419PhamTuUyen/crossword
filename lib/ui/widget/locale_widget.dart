import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/blocs/language_cubit.dart';
import '/localizations.dart';

class LocaleWidget extends StatelessWidget {
  final builder;

  const LocaleWidget({Key? key, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, String>(
      builder: (context, state) {
        return builder(Language.of(context));
      },
    );
  }
}
