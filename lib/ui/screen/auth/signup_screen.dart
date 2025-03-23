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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '/blocs/cubit.dart';
import '/domain/repositories/repositories.dart';
import '/injection_container.dart';
import '/routes.dart';
import '/ui/widget/widget.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
        create: (_) => AuthCubit(repositoryImpl: getIt.get<AuthRepository>()),
        child: SignupBody());
  }
}

class SignupBody extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupBody> {
  bool _isPasswordVisible = true;
  bool _isConfirmPasswordVisible = true;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        loadingWidget: CustomLoading<AuthCubit>(),
        messageNotify: CustomSnackBar<AuthCubit>(),
        body: Dialog(
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
                        AppLocalizations.of(context)!.register,
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
                          controller: _usernameController,
                          obscureText: false,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!.username,
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
                            labelText: AppLocalizations.of(context)!.password,
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
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: 225.w,
                        child: TextField(
                          controller: _confirmPasswordController,
                          obscureText: _isConfirmPasswordVisible,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText:
                                AppLocalizations.of(context)!.confirm_password,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      FilledButton(
                        onPressed: handleRegister,
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.grey),
                          minimumSize:
                              WidgetStateProperty.all(Size(170.w, 40.h)),
                          // Màu nền xám
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.register_lc,
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 16.h),
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
                              BlocProvider.of<AuthCubit>(context)
                                  .doSignInWithGoogle();
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
                              BlocProvider.of<AuthCubit>(context)
                                  .doSignInWithFacebook();
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 32.h),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: AppLocalizations.of(context)!.have_account,
                            style: const TextStyle(color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                text: AppLocalizations.of(context)!.login_lc,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pop();
                                    DialogUtils.showAnimatedDialog(
                                      context,
                                      LoginScreen(),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                      BlocListener<AuthCubit, BaseState>(
                        listener: (_, state) {
                          if (state is LoadedState) {
                            showToast(
                                AppLocalizations.of(context)!.register_success);
                            getIt.get<UserInfoCubit>().saveUserInfo(state.data);
                            Navigator.pushNamedAndRemoveUntil(
                                context, Routes.mainScreen, (route) => false);
                          }
                          if (state is ErrorState) {
                            if (state.data ==
                                ResponseStatus.response500InternalServerError
                                    .toString()) {
                              showToast(AppLocalizations.of(context)!
                                  .register_failed);
                            } else if (state.data ==
                                ResponseStatus.response409Conflict.toString()) {
                              showToast(
                                  AppLocalizations.of(context)!.email_in_use);
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

  void handleRegister() {
    UserModel user = UserModel();
    user.email = _emailController.text;
    user.username = _usernameController.text;
    user.password = _passwordController.text;
    var validator =
        user.signupValidate(context, _confirmPasswordController.text);
    if (validator != ResponseStatus.response200Ok) {
      showToast(validator);
    } else {
      BlocProvider.of<AuthCubit>(context).doSignUp(user);
    }
  }
}
