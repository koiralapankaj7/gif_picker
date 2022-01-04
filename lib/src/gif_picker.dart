import 'package:flutter/material.dart';
import 'package:gif_picker/gif_picker.dart';
import 'package:gif_picker/src/widgets/widgets.dart';

/// {@template gif_picker}
/// {@endtemplate}
class GifPicker extends StatefulWidget {
  /// {@macro gif_picker}
  const GifPicker({Key? key}) : super(key: key);

  @override
  State createState() => _GifPickerState();
}

class _GifPickerState extends State<GifPicker> {
  late final GifController<TenorCategories> _categoriesController;
  late final GifController<TenorCollection> _trendingController;

  @override
  void initState() {
    super.initState();
    _categoriesController = GifController()..fetchCategories();
    _trendingController = GifController()..fetchTrendingGifs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SizedBox(height: 12),
          const SearchBar.dummy(),
          const SizedBox(height: 8),
          Expanded(
            child: CategoriesView(
              categoriesController: _categoriesController,
              trendingController: _trendingController,
            ),
          ),
        ],
      ),
    );
  }
}
