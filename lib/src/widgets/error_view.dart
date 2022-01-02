import 'package:flutter/material.dart';
import 'package:gif_picker/gif_picker.dart';

///
class ErrorView extends StatelessWidget {
  ///
  const ErrorView({
    Key? key,
    required this.error,
  }) : super(key: key);

  ///
  final GifPickerError error;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error, size: 80, color: Colors.red),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            error.message,
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
