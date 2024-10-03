import 'package:flutter/material.dart';
import 'package:kafe/custom_theme.dart';

class CustomLoadingDialog extends StatefulWidget {
  const CustomLoadingDialog({super.key});

  @override
  State<CustomLoadingDialog> createState() => _CustomLoadingDialogState();
}

class _CustomLoadingDialogState extends State<CustomLoadingDialog> {
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10), () {
      if(mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      child: SizedBox(
        width: screenWidth / 2,
        height: screenWidth / 2,
        child: const Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
