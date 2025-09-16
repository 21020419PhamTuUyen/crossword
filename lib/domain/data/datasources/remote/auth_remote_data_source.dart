import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crossword/domain/data/datasources/remote/score_remote_data_source.dart';
import 'package:crossword/domain/data/models/score_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../injection_container.dart';
import '../../../network/exception_code.dart';
import '../../../network/response_status.dart';
import '../../models/user_model.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> login(UserModel userModel) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: userModel.email!, password: userModel.password!);
      if (credential.user != null) {
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('user')
                .where('email', isEqualTo: credential.user?.email)
                .get();
        UserModel userModel = UserModel();
        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
              querySnapshot.docs.first;
          userModel = UserModel.fromSnapshot(documentSnapshot);
        }
        return {
          'status': ResponseStatus.response200Ok,
          'data': userModel,
        };
      } else {
        return {
          'status': ResponseStatus.response500InternalServerError,
        };
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == ExceptionCode.invalidCredential) {
        return {
          'status': ResponseStatus.response401Unauthorized,
        };
      } else {
        return {
          'status': e.code,
        };
      }
    }
  }

  Future<Map<String, dynamic>> register(UserModel user) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: user.email!, password: user.password!);
      if (credential.user != null) {
        await FirebaseFirestore.instance.collection('user').add(user.toMap());
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('user')
                .where('email', isEqualTo: user.email)
                .get();
        UserModel userModel = UserModel();
        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
              querySnapshot.docs.first;
          userModel = UserModel.fromSnapshot(documentSnapshot);
        }
        return {
          'status': ResponseStatus.response201Created,
          'data': userModel,
        };
      } else {
        return {
          'status': ResponseStatus.response500InternalServerError,
        };
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == ExceptionCode.emailInUse) {
        return {
          'status': ResponseStatus.response409Conflict,
        };
      } else {
        return {
          'status': e.code,
        };
      }
    }
  }

  Future<Map<String, dynamic>> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
      UserCredential credential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      if (credential.user != null) {
        UserInfo user = credential.user!.providerData.first;
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('user')
                .where('email', isEqualTo: user.email)
                .get();
        UserModel userModel = UserModel();
        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
              querySnapshot.docs.first;
          userModel = UserModel.fromSnapshot(documentSnapshot);
        } else {
          userModel.email = user.email;
          userModel.username = user.displayName;
          await FirebaseFirestore.instance
              .collection('user')
              .add(userModel.toMap());
        }
        return {
          'status': ResponseStatus.response200Ok,
          'data': userModel,
        };
      } else {
        return {
          'status': ResponseStatus.response500InternalServerError,
        };
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == ExceptionCode.invalidCredential) {
        return {
          'status': ResponseStatus.response401Unauthorized,
        };
      } else if (e.code == ExceptionCode.otherCredential) {
        return {
          'status': 'Tài khoản đã được đăng ký ở nền tảng khác',
        };
      } else {
        return {
          'status': e.code,
        };
      }
    }
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId:
            "930197604365-c7b2jsdt0da8n92kquk73jnvqdts43l4.apps.googleusercontent.com",
      );

      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final googleAuthCredential = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
      UserCredential credential = await FirebaseAuth.instance
          .signInWithCredential(googleAuthCredential);
      if (credential.user != null) {
        UserInfo user = credential.user!.providerData.first;
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('user')
                .where('email', isEqualTo: user.email)
                .get();
        UserModel userModel = UserModel();
        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
              querySnapshot.docs.first;
          userModel = UserModel.fromSnapshot(documentSnapshot);
        } else {
          userModel.email = user.email;
          userModel.username = user.displayName;
          await FirebaseFirestore.instance
              .collection('user')
              .add(userModel.toMap());
        }
        return {
          'status': ResponseStatus.response200Ok,
          'data': userModel,
        };
      } else {
        return {
          'status': ResponseStatus.response500InternalServerError,
        };
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == ExceptionCode.invalidCredential) {
        return {
          'status': ResponseStatus.response401Unauthorized,
        };
      } else {
        return {
          'status': e.code,
        };
      }
    }
  }
}
