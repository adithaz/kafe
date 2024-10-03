import 'package:flutter/material.dart';
import 'package:kafe/custom_theme.dart';

class CustomRatingWidget extends StatefulWidget {
  final ValueSetter onChanged;
  const CustomRatingWidget({super.key, required this.onChanged});

  @override
  State<CustomRatingWidget> createState() => _CustomRatingWidgetState();
}

class _CustomRatingWidgetState extends State<CustomRatingWidget> {
  double currentStars = 5;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for(int i = 0; i < 5; i++)...<Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                currentStars = i + 1;
              });
              widget.onChanged(currentStars);
            },
            child: Icon(
              i <= (currentStars - 1) ? Icons.star : Icons.star_border,
              color: ratingColor,
              size: 35,
            ),
          ),
        ],
      ],
    );
  }
}
