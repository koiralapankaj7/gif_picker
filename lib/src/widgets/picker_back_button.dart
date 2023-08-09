import 'package:flutter/material.dart';

///
class PickerBackButton extends StatelessWidget {
  ///
  const PickerBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: Navigator.of(context).pop,
      icon: const Icon(Icons.close),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
    );
  }
}
