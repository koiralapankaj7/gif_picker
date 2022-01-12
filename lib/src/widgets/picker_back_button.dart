import 'package:flutter/material.dart';
import 'package:gif_picker/src/widgets/notifiers_provider.dart';

///
class PickerBackButton extends StatelessWidget {
  ///
  const PickerBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        final provider = context.provider!;
        if (provider.pickerNavigator.isEmpty) {
          Navigator.of(context).pop();
        } else {
          context.provider!.pickerNavigator.pop();
        }
      },
      icon: const Icon(Icons.close),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
    );
  }
}
