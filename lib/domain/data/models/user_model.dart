import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../network/response_status.dart';
import '/domain/data/entities/entities.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserModel extends UserEntity {
  UserModel();

  UserModel.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : super.fromSnapshot(snapshot);

  loginValidate(BuildContext context){
    if (email == null || email!.isEmpty) {
      return AppLocalizations.of(context)!.email_required;
    }

    String emailPattern = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';
    RegExp regExp = RegExp(emailPattern);
    if (!regExp.hasMatch(email!)) {
      return AppLocalizations.of(context)!.email_not_valid;
   }

    if (password == null || password!.isEmpty) {
      return AppLocalizations.of(context)!.password_required;
    }
    return ResponseStatus.response200Ok;
  }

  signupValidate(BuildContext context, String confirmPassword) {
    if (email == null || email!.isEmpty) {
      return AppLocalizations.of(context)!.email_required;
    }

    String emailPattern = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';
    RegExp regExp = RegExp(emailPattern);
    if (!regExp.hasMatch(email!)) {
      return AppLocalizations.of(context)!.email_not_valid;
    }

    if (username == null || username!.isEmpty) {
      return AppLocalizations.of(context)!.username_required;
    }
    if (password == null || password!.isEmpty) {
      return AppLocalizations.of(context)!.password_required;
    }
    if (password!.length < 6) {
      return AppLocalizations.of(context)!.password_too_short;
    }
    if (confirmPassword.isEmpty) {
      return AppLocalizations.of(context)!.confirm_required;
    }
    if (password != confirmPassword) {
      return AppLocalizations.of(context)!.password_not_match;
    }
    return ResponseStatus.response200Ok;
  }

// get getSortName {
//   int length = userName?.length ?? 0;
//   if (length <= 1) {
//     return userName ?? "";
//   } else {
//     return "${userName![0]}${userName![length - 1]}";
//   }
// }
}
