import 'package:flutter/material.dart';
import 'package:gif_picker/gif_picker.dart';

class GifPickerExample extends StatefulWidget {
  const GifPickerExample({Key? key}) : super(key: key);

  @override
  _GifPickerExampleState createState() => _GifPickerExampleState();
}

class _GifPickerExampleState extends State<GifPickerExample> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      builder: (context, setting) {
        return Scaffold(
          appBar: AppBar(title: const Text('Gif Picker Example')),
          body: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    GifPicker.pick(context);
                  },
                  child: const Text('Pick Gif'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
