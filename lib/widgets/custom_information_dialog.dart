import 'package:flutter/material.dart';
import 'package:kafe/custom_theme.dart';

class CustomInformationDialog extends StatefulWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onTap;

  const CustomInformationDialog({super.key, required this.title, required this.description, required this.buttonText, required this.onTap});

  @override
  State<CustomInformationDialog> createState() => _CustomInformationDialogState();
}

class _CustomInformationDialogState extends State<CustomInformationDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20,),
            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30,),
            GestureDetector(
              onTap: () {
                Feedback.forTap(context);
                widget.onTap();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: primaryColor,
                ),
                child: Center(
                  child: Text(
                    widget.buttonText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
