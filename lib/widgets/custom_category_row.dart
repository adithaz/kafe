import 'package:flutter/material.dart';

class CustomCategoryRow extends StatelessWidget {
  final String category;
  final String detail;
  const CustomCategoryRow({super.key, required this.category, required this.detail});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        SizedBox(
          width: screenWidth / 4,
          child: Text(
            category,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            detail,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
