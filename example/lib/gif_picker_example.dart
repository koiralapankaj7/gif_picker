import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gif_picker/gif_picker.dart';

class GifPickerExample extends StatefulWidget {
  const GifPickerExample({Key? key}) : super(key: key);

  @override
  _GifPickerExampleState createState() => _GifPickerExampleState();
}

class _GifPickerExampleState extends State<GifPickerExample> {
  TenorGif? _tenorGif;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gif Picker Example')),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Divider(),
            Expanded(
                child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    log('Test...');
                  },
                  child: const Text('Test Button'),
                ),
                if (_tenorGif != null)
                  Builder(
                    builder: (context) {
                      final gif = _tenorGif!.media.first.tinyGif;
                      return Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            gif.url,
                            width: gif.dimension[0].toDouble(),
                            height: gif.dimension[1].toDouble(),
                          ),
                        ),
                      );
                    },
                  ),

                //
                Builder(builder: (c) {
                  return ElevatedButton(
                    onPressed: () async {
                      final gif = await TenorGifPicker.pick(c);
                      if (gif != null) {
                        setState(() {
                          _tenorGif = gif;
                        });
                      }
                    },
                    child: const Text('Pick Gif'),
                  );
                }),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
