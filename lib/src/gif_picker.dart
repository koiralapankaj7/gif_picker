import 'package:flutter/material.dart';
import 'package:gif_picker/gif_picker.dart';
import 'package:gif_picker/src/gifs_page.dart';
import 'package:gif_picker/src/widgets/categories_view.dart';

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
  late final GifController<TenorTerms> _trendingTermsController;

  @override
  void initState() {
    super.initState();
    _categoriesController = GifController()..fetchCategories();
    _trendingController = GifController()..fetchTrendingGifs();
    _trendingTermsController = GifController()..fetchTrendingSearchTerms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _SearchBar(
            trendingTermsController: _trendingTermsController,
          ),
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

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    Key? key,
    required this.trendingTermsController,
  }) : super(key: key);

  ///
  final GifController<TenorTerms>? trendingTermsController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push<void>(
          MaterialPageRoute(
            builder: (context) => GifsPage(
              trendingTermsController: trendingTermsController,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Text(' Search', style: Theme.of(context).textTheme.subtitle1),
            const Spacer(),
            const Icon(Icons.search, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
