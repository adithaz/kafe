import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kafe/custom_theme.dart';
import 'package:kafe/firebase_options.dart';
import 'package:kafe/ui/splash_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildThemeData(),
      home: const SplashScreen(),
    );
  }
}

ThemeData _buildThemeData() {
  return ThemeData(
    primarySwatch: primarySwatch,
    useMaterial3: true,
    fontFamily: 'Jakarta',
    textTheme: const TextTheme(
      headlineLarge: customHeadlineLarge,
      headlineSmall: customHeadlineSmall,
      bodyLarge: customBodyTextLarge,
      bodyMedium: customBodyTextMedium,
      bodySmall: customBodyTextSmall,
    ),
  );
}