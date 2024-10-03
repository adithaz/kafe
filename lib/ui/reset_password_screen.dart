import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kafe/custom_strings.dart';
import 'package:kafe/custom_theme.dart';
import 'package:kafe/service/auth_service.dart';
import 'package:kafe/service/ui_service.dart';
import 'package:kafe/widgets/custom_form_field.dart';
import 'package:kafe/widgets/custom_primary_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  final AuthService _auth = AuthService();
  final UIService _ui = UIService();
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundMain,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: GestureDetector(
                  onTap: () {
                    Feedback.forTap(context);
                    _navigateBack();
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    "assets/images/ic-lock.svg",
                    width: screenWidth / 2,
                  ),
                ),
                const SizedBox(height: 20,),
                Text(
                  "Lupa Password?",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  "Silahkan masukan email kamu sebelumnya, tautan untuk mengubah password akan dikirimkan untuk kembali ke ${CustomStrings.appTitle}!",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 30,),
                CustomFormField(
                  controller: emailController,
                  label: "Email",
                  hint: "Masukan email kamu",
                ),
                const SizedBox(height: 20,),
                CustomPrimaryButton(
                  buttonText: "Kirim",
                  onTap: () {
                    final email = emailController.text.trim();

                    if(email.isEmpty) {
                      _handleError("Email tidak boleh kosong!");
                    } else if(!(_auth.isValidEmail(email))) {
                      _handleError("Format email tidak benar!");
                    } else {
                      _handleResetPassword(email);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleResetPassword(String email) {
    try {
      _ui.showSimpleConfirmationDialog(
        context,
        "Konfirmasi",
        "Tautan untuk mengubah password akan dikirimkan ke $email. Apakah email sudah benar?",
        "Kirim",
        "Batal",
        () async {
          _handleLoading(true);
          try {
            await _auth.resetPassword(email).then((_) {
              _handleLoading(false);
              _navigateBack();
              _ui.showSimpleInformationDialog(
                context,
                "Informasi",
                "Tautan untuk mengubah password sudah dikirimkan ke $email. Kamu akan menerima tautan jika akun dengan email tersebut tersedia.",
                "Baik",
                    () {
                  _navigateBack();
                  _navigateBack();
                },
              );
            });
          } on FirebaseAuthException catch (_) {
            _handleLoading(false);
            _navigateBack();
            _handleError('Proses gagal, silahkan coba lagi nanti!');
          } catch(e) {
            _handleLoading(false);
            _navigateBack();
            _handleError('Proses gagal, silahkan coba lagi nanti!');
          }
        },
        () {
          _navigateBack();
        },
      );
    } on FirebaseAuthException catch (_) {
      _handleError('Proses gagal, silahkan coba lagi nanti!');
    } catch (_) {
      _handleError('Proses gagal, silahkan coba lagi nanti!');
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

  void _navigateBack() {
    Navigator.pop(context);
  }
}
