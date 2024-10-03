import 'package:flutter/material.dart';
import 'package:kafe/custom_theme.dart';

class CustomSettingsSwitch extends StatefulWidget {
  final String text;
  final bool value;
  final ValueSetter onTap;
  const CustomSettingsSwitch({super.key, required this.text, required this.value, required this.onTap});

  @override
  State<CustomSettingsSwitch> createState() => _CustomSettingsSwitchState();
}

class _CustomSettingsSwitchState extends State<CustomSettingsSwitch> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.text,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Switch(
          value: widget.value,
          activeTrackColor: primaryColor,
          inactiveTrackColor: Colors.white,
          onChanged: (v) {
            Feedback.forTap(context);
            widget.onTap(v);
            setState(() {});
          },
        ),
      ],
    );
  }
}
