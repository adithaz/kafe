import 'package:flutter/material.dart';
import 'package:kafe/custom_theme.dart';

class CustomIconInfoRow extends StatefulWidget {
  final IconData icon;
  final String text;
  const CustomIconInfoRow({super.key, required this.icon, required this.text});

  @override
  State<CustomIconInfoRow> createState() => _CustomIconInfoRowState();
}

class _CustomIconInfoRowState extends State<CustomIconInfoRow> {
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            widget.icon,
            color: primaryColor,
          ),
          const SizedBox(width: 6,),
          Expanded(
            child: Text(
              widget.text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
