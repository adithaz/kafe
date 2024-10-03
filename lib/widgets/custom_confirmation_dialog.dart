import 'package:flutter/material.dart';
import 'package:kafe/custom_theme.dart';

class CustomConfirmationDialog extends StatefulWidget {
  final String title;
  final String description;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const CustomConfirmationDialog({super.key, required this.title, required this.description, required this.confirmText, required this.cancelText, required this.onConfirm, required this.onCancel, });

  @override
  State<CustomConfirmationDialog> createState() => _CustomConfirmationDialogState();
}

class _CustomConfirmationDialogState extends State<CustomConfirmationDialog> {
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
                widget.onConfirm();
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
                    widget.confirmText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6,),
            GestureDetector(
              onTap: () {
                Feedback.forTap(context);
                widget.onCancel();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                child: Center(
                  child: Text(
                    widget.cancelText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
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
