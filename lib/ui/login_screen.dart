import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kafe/custom_strings.dart';
import 'package:kafe/custom_theme.dart';
import 'package:kafe/service/auth_service.dart';
import 'package:kafe/service/ui_service.dart';
import 'package:kafe/ui/home_screen.dart';
import 'package:kafe/ui/reset_password_screen.dart';
import 'package:kafe/ui/sign_up_screen.dart';
import 'package:kafe/widgets/custom_form_field.dart';
import 'package:kafe/widgets/custom_primary_button.dart';
import 'package:page_transition/page_transition.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final UIService _ui = UIService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundMain,
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Stack(
          children: [
            Image.asset(
              "assets/images/bg-coffee1.png",
              width: screenWidth,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: screenHeight / 5,
                left: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CustomStrings.login,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Silahkan masuk terlebih dahulu sebelum menggunakan ${CustomStrings.appTitle}!",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (MediaQuery.of(context).viewInsets.bottom > 0) const SizedBox()
                    else AnimatedContainer(
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 300),
                      child: Transform.translate(
                        offset: const Offset(0, 1),
                        child: SvgPicture.asset(
                          "assets/images/bg-login-curve.svg",
                          width: screenWidth,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 300),
                      height: MediaQuery.of(context).viewInsets.bottom > 0 ? screenHeight : screenHeight / 2,
                      width: screenWidth,
                      color: backgroundMain,
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: MediaQuery.of(context).viewInsets.bottom > 0 ? 50 : 0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomFormField(controller: emailController, label: "Email", hint: "Masukan email kamu"),
                          const SizedBox(height: 12,),
                          CustomFormField(controller: passwordController, label: "Password", hint: "Masukan password kamu", obscure: true,),
                          const SizedBox(height: 6,),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    curve: Curves.ease,
                                    child: const ResetPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Lupa password?",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14,),
                          CustomPrimaryButton(
                            buttonText: CustomStrings.login,
                            onTap: () {
                              final email = emailController.text.trim();
                              final password = passwordController.text;

                              if(email.isEmpty) {
                                _handleError("Email tidak boleh kosong!");
                              } else if(!(_auth.isValidEmail(email))) {
                                _handleError("Format email tidak benar!");
                              } else if(password.isEmpty) {
                                _handleError("Password tidak boleh kosong!");
                              } else {
                                _handleLogin(email, password);
                              }
                            },
                          ),
                          const SizedBox(height: 6,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Belum memiliki akun? Silahkan ",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeftJoined,
                                      child: const SignUpScreen(),
                                      childCurrent: widget,
                                      curve: Curves.ease,
                                    ),
                                  );
                                },
                                child: Text(
                                  CustomStrings.signUp,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogin(String email, String password) async {
    _handleLoading(true);
    try {
      await _auth.signInUser(email, password).then((isValid) {
        _handleLoading(false);
        if(isValid) {
          _navigateHome();
        } else {
          _handleError("Login gagal, silahkan coba lagi.");
        }
      });
    } on FirebaseAuthException catch (_) {
      _handleLoading(false);
      _handleError("Login gagal, silahkan coba lagi.");
    }
  }

  void _handleLoading(bool show) {
    if(show) {
      _ui.showSimpleLoadingDialog(context);
    } else {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void _handleError(String message) {
    _ui.showSimpleSnackBar(context, message);
  }

  void _navigateHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
    );
  }
}
