import 'package:flutter/material.dart';
import 'package:kafe/custom_theme.dart';

class CustomPrimaryButton extends StatefulWidget {
  final String buttonText;
  final VoidCallback onTap;
  const CustomPrimaryButton({super.key, required this.buttonText, required this.onTap});

  @override
  State<CustomPrimaryButton> createState() => _CustomPrimaryButtonState();
}

class _CustomPrimaryButtonState extends State<CustomPrimaryButton> {
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        Feedback.forTap(context);
        widget.onTap();
      },
      child: Container(
        width: screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: primaryColor,
        ),
        margin: const EdgeInsets.only(
          top: 6,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        child: Center(
          child: Text(
            widget.buttonText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
