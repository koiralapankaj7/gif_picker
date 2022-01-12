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
    // return Scaffold(
    //   appBar: AppBar(title: const Text('Gif Picker Example')),
    //   body: Align(
    //     alignment: Alignment.center,
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         if (_tenorGif != null)
    //           Builder(
    //             builder: (context) {
    //               final gif = _tenorGif!.media.first.tinyGif;
    //               return Padding(
    //                 padding: const EdgeInsets.all(32.0),
    //                 child: ClipRRect(
    //                   borderRadius: BorderRadius.circular(8),
    //                   child: Image.network(
    //                     gif.url,
    //                     width: gif.dimension[0].toDouble(),
    //                     height: gif.dimension[1].toDouble(),
    //                   ),
    //                 ),
    //               );
    //             },
    //           ),

    //         //
    //         ElevatedButton(
    //           onPressed: () async {
    //             final gif = await TenorGifPicker.pick(context);
    //             if (gif != null) {
    //               setState(() {
    //                 _tenorGif = gif;
    //               });
    //             }
    //           },
    //           child: const Text('Pick Gif'),
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    return Slidable(
      builder: (context, setting) {
        return Scaffold(
          appBar: AppBar(title: const Text('Gif Picker Example')),
          body: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  ElevatedButton(
                    onPressed: () async {
                      final gif = await TenorGifPicker.pick(context);
                      if (gif != null) {
                        setState(() {
                          _tenorGif = gif;
                        });
                      }
                    },
                    child: const Text('Pick Gif'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
