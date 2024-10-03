import 'package:flutter/material.dart';

class CustomFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String hint;
  final bool? obscure;
  final int? maxLines;
  const CustomFormField({super.key, required this.controller, this.label, required this.hint, this.obscure, this.maxLines = 1});

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label != null ? Text(
          widget.label!,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ) : const SizedBox(),
        Container(
          width: screenWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.black26,
            ),
          ),
          margin: EdgeInsets.only(
            top: widget.label != null ? 6 : 0,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 12,
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscure ?? false,
            style: Theme.of(context).textTheme.bodySmall,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hint,
              hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black45,
              ),
            ),
            minLines: 1,
            maxLines: widget.maxLines,
          ),
        ),
      ],
    );
  }
}
