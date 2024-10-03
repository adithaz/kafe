import 'package:flutter/material.dart';
import 'package:kafe/custom_theme.dart';

class CustomPreferenceListSettings extends StatefulWidget {
  final List<String> list;
  final List<String> chosenList;
  final ValueSetter<String> onTap;
  const CustomPreferenceListSettings({super.key, required this.list, required this.chosenList, required this.onTap});

  @override
  State<CustomPreferenceListSettings> createState() => _CustomPreferenceListSettingsState();
}

class _CustomPreferenceListSettingsState extends State<CustomPreferenceListSettings> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 8,
      spacing: 8,
      direction: Axis.horizontal,
      children: [
        for(int i = 0; i < widget.list.length; i++)...<Widget>[
          IntrinsicWidth(
            child: GestureDetector(
              onTap: () {
                Feedback.forTap(context);
                widget.onTap(widget.list[i]);
                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                  color: widget.chosenList.contains(widget.list[i]) ? primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: widget.chosenList.contains(widget.list[i]) ? Colors.transparent : secondaryText,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Center(
                  child: Text(
                    widget.list[i],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: widget.chosenList.contains(widget.list[i]) ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]
      ],
    );
  }
}
