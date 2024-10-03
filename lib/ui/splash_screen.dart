import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kafe/custom_strings.dart';
import 'package:kafe/custom_theme.dart';
import 'package:kafe/ui/home_screen.dart';
import 'package:kafe/ui/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  void initState() {
    super.initState();
    launchApp();
  }

  void launchApp() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthWrapper(),)
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/logo-white.svg",
              width: screenWidth / 2,
              placeholderBuilder: (context) => const CircularProgressIndicator(),
            ),
            const SizedBox(height: 12,),
            Text(
              CustomStrings.appTitle,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    if(FirebaseAuth.instance.currentUser == null) {
      return const LoginScreen();
    } else {
      return const HomeScreen();
    }
  }
}
