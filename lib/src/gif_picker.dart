import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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

  @override
  void initState() {
    super.initState();
    _categoriesController = GifController()..fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SearchBar(),
          Expanded(child: CategoriesView(controller: _categoriesController)),
        ],
      ),
    );
  }
}

///
class SearchBar extends StatelessWidget {
  ///
  const SearchBar({
    Key? key,
    this.padding,
  }) : super(key: key);

  ///
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: TextField(
        style: Theme.of(context).textTheme.subtitle1,
        decoration: InputDecoration(
          hintText: 'Search Tenor',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          fillColor: Colors.grey.shade400,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          isDense: true,
        ),
      ),
    );
  }
}

class _Categories extends StatelessWidget {
  const _Categories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      padding: const EdgeInsets.all(8),
      itemCount: 26,
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemBuilder: (context, index) {
        return _CategoryTile(
          index: index,
          width: 100,
          height: 100,
        );
      },
    );
  }
}

///
class _CategoryTile extends StatelessWidget {
  ///
  const _CategoryTile({
    Key? key,
    required this.index,
    required this.width,
    required this.height,
  }) : super(key: key);

  ///
  final int index;

  ///
  final int width;

  ///
  final int height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push<void>(
          MaterialPageRoute(
            builder: (context) => const GifsPage(),
          ),
        );
      },
      child: SizedBox(
        width: width.toDouble(),
        height: height.toDouble(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                'https://picsum.photos/$width/$height?random=$index',
                fit: BoxFit.cover,
              ),
              const Positioned.fill(child: ColoredBox(color: Colors.black38)),
              Positioned(
                left: 12,
                bottom: 12,
                child: Text(
                  'Trending',
                  style: Theme.of(context).textTheme.subtitle2?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
