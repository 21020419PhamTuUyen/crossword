import 'package:crossword/ui/screen/auth/signup_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../domain/data/models/user_model.dart';
import '../../../domain/network/response_status.dart';
import '../../../res/images.dart';
import '../../widget/show_animated_dialog.dart';
import '../../widget/toast.dart';
import '/blocs/base_bloc/base_state.dart';
import '/blocs/cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '/domain/repositories/repositories.dart';
import '/injection_container.dart';
import '/routes.dart';
import '/ui/widget/widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
        create: (_) => AuthCubit(repositoryImpl: getIt.get<AuthRepository>()),
        child: LoginBody());
  }
}

class LoginBody extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginBody> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        loadingWidget: CustomLoading<AuthCubit>(),
    messageNotify: CustomSnackBar<AuthCubit>(),
    body:Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        side: const BorderSide(color: Colors.black, width: 3),
      ),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: 8.0,
              right: 8.0,
              child: IconButton(
                icon: Image.asset(
                  AppImages.CLOSE,
                  height: 24.h,
                  width: 24.w,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(40.sp),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 30.h),
                  Text(
                    AppLocalizations.of(context)!.login,
                    style: TextStyle(
                      fontSize: 32.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: 225.w,
                    child: TextField(
                      controller: _emailController,
                      obscureText: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'email',
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: 225.w,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _isPasswordVisible,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText:
                        AppLocalizations.of(context)!.password,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  FilledButton(
                    onPressed: _handleLogin,
                    // handleLogin,
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.grey),
                      minimumSize: WidgetStateProperty.all(Size(170.w, 40.h)),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.login_lc,
                      style: TextStyle(fontSize: 16.sp, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Image.asset(
                          AppImages.GOOGLE_ICON,
                          height: 24.h,
                          width: 24.w,
                        ),
                        onPressed: () {
                          BlocProvider.of<AuthCubit>(context).doSignInWithGoogle();
                        },
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      IconButton(
                        icon: Image.asset(
                          AppImages.FACEBOOK_ICON,
                          height: 24.h,
                          width: 24.w,
                        ),
                        onPressed: () {
                          BlocProvider.of<AuthCubit>(context).doSignInWithFacebook();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text:
                        AppLocalizations.of(context)!.dont_have_account,
                        style: const TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                            AppLocalizations.of(context)!.register_lc,
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pop();
                                DialogUtils.showAnimatedDialog(
                                  context,
                                  SignupScreen(),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  BlocListener<AuthCubit, BaseState>(
                    listener: (_, state) {
                      if (state is LoadingState) {
                        Center(
                          child: BaseProgressIndicator(),
                        );
                      }
                      if (state is LoadedState) {
                        showToast(
                            AppLocalizations.of(context)!.login_success);
                        getIt.get<UserInfoCubit>().saveUserInfo(state.data);
                        Navigator.pushNamedAndRemoveUntil(
                            context, Routes.mainScreen, (route) => false);
                      }
                      if (state is ErrorState) {
                        if (state.data ==
                            ResponseStatus.response500InternalServerError
                                .toString()) {
                          showToast(
                              AppLocalizations.of(context)!.login_failed);
                        } else if (state.data ==
                            ResponseStatus.response401Unauthorized.toString()) {
                          showToast(
                              AppLocalizations.of(context)!.invalid_account);
                        } else {
                          showToast(state.data);
                        }
                      }
                    },
                    child: Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void _handleLogin() {
    UserModel user = UserModel();
    user.email = _emailController.text;
    user.password = _passwordController.text;
    var validator = user.loginValidate(context);
    if (validator != ResponseStatus.response200Ok) {
      showToast(validator);
    } else {
      BlocProvider.of<AuthCubit>(context).doLogin(user);
    }
  }

}
