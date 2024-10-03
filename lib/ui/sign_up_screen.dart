import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kafe/custom_strings.dart';
import 'package:kafe/custom_theme.dart';
import 'package:kafe/service/auth_service.dart';
import 'package:kafe/service/firestore_service.dart';
import 'package:kafe/service/ui_service.dart';
import 'package:kafe/ui/home_screen.dart';
import 'package:kafe/widgets/custom_form_field.dart';
import 'package:kafe/widgets/custom_primary_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _auth = AuthService();
  final FirestoreService _firestore = FirestoreService();
  final UIService _ui = UIService();
  TextEditingController usernameController = TextEditingController();
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
              "assets/images/bg-coffee2.png",
              width: screenWidth,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () {
                    Feedback.forTap(context);
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.white,
                  ),
                ),
              ),
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
                    CustomStrings.signUp,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Silahkan buat akun terlebih dahulu, kemudian mari kita jelajahi ${CustomStrings.appTitle}!",
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
                          "assets/images/bg-signup-curve.svg",
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
                        top: MediaQuery.of(context).viewInsets.bottom > 0 ? 50 : 0
                      ),
                      child: Column(
                        children: [
                          CustomFormField(controller: usernameController, label: "Username", hint: "Masukan username kamu"),
                          const SizedBox(height: 12,),
                          CustomFormField(controller: emailController, label: "Email", hint: "Masukan email kamu"),
                          const SizedBox(height: 12,),
                          CustomFormField(controller: passwordController, label: "Password", hint: "Masukan password kamu", obscure: true,),
                          const SizedBox(height: 20,),
                          CustomPrimaryButton(
                            buttonText: CustomStrings.signUp,
                            onTap: () {
                              final username = usernameController.text.trim().toLowerCase();
                              final email = emailController.text.trim();
                              final password = passwordController.text;

                              if(username.isEmpty) {
                                _handleError("Username tidak boleh kosong!");
                              } else if(username.length < 5) {
                                _handleError("Username harus terdiri dari minimal 5 karakter!");
                              } else if(username.contains(" ")) {
                                _handleError("Username tidak boleh berisi spasi");
                              } else if(email.isEmpty) {
                                _handleError("Email tidak boleh kosong!");
                              } else if(!(_auth.isValidEmail(email))) {
                                _handleError("Format email tidak benar!");
                              } else if(password.isEmpty) {
                                _handleError("Password tidak boleh kosong!");
                              } else if(password.length < 8) {
                                _handleError("Password harus terdiri dari minimal 8 karakter!");
                              } else {
                                _handleRegistration(username, email, password);
                              }
                            },
                          ),
                          const SizedBox(height: 6,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Sudah memiliki akun? Silahkan ",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  CustomStrings.login,
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

  void _handleRegistration(String username, String email, String password) async {
    _handleLoading(true);
    if(!(await _firestore.checkUsernameAvailability(username))) {
      _handleLoading(false);
      _handleError("Username telah digunakan sebelumnya.");
    } else {
      try {
        await _auth.registerUser(username, email, password).then((_) {
          _handleLoading(false);
          _navigateHome();
        });
      } on FirebaseAuthException catch (e) {
        _handleLoading(false);
        if (e.code == 'email-already-in-use') {
          _handleError('Email sudah dipakai sebelumnya!');
        } else if (e.code == 'invalid-email') {
          _handleError('Email tidak bisa digunakan.');
        }
      }
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
    Future.delayed(const Duration(milliseconds: 1000), () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false,
      );
    });
  }
}
