import 'package:flutter/material.dart';
import 'package:kafe/custom_theme.dart';

class RatingStar extends StatelessWidget {
  final double rating;
  final double size;
  final int starCount;

  const RatingStar({super.key, this.rating = 0.0, this.starCount = 5, this.size = 30.0,});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        Icons.star_border,
        color: ratingColor,
        size: size,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        color: ratingColor,
        size: size,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: ratingColor,
        size: size,
      );
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        starCount, (index) => buildStar(context, index),
      ),
    );
  }
}