import 'package:flutter/material.dart';

class SettingsItem extends StatefulWidget {

  final String label;
  final Widget item;

  const SettingsItem({super.key, required this.label, required this.item});

  @override
  State<SettingsItem> createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 150,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(widget.label)
          ),
        ),
        const SizedBox(width: 10,),
        SizedBox(
          width: 220,
          child: widget.item
        )
      ],
    );
  }
}