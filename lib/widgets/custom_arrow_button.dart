import 'package:flutter/material.dart';

class CustomArrowButton extends StatefulWidget {
  final String title;
  final String subTitle;
  final VoidCallback? onTap;
  const CustomArrowButton({super.key, required this.title, required this.subTitle, this.onTap,});

  @override
  State<CustomArrowButton> createState() => _CustomArrowButtonState();
}

class _CustomArrowButtonState extends State<CustomArrowButton> {
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: screenWidth,
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(5, 5),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.subTitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            Opacity(
              opacity: widget.onTap != null ? 1 : 0,
              child: const Icon(
                Icons.keyboard_arrow_right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
