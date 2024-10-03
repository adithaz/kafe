import 'package:flutter/material.dart';
import 'package:kafe/custom_theme.dart';

class CustomFloatingNavigationCircle extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  const CustomFloatingNavigationCircle({super.key, required this.icon, required this.onTap});

  @override
  State<CustomFloatingNavigationCircle> createState() => _CustomFloatingNavigationCircleState();
}

class _CustomFloatingNavigationCircleState extends State<CustomFloatingNavigationCircle> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            widget.icon,
            color: primaryColor,
            size: 35,
          ),
        ),
      ),
    );
  }
}
