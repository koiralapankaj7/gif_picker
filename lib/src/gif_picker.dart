import 'package:flutter/material.dart';
import 'package:gif_picker/gif_picker.dart';
import 'package:gif_picker/src/setting_page.dart';
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
  late final ValueNotifier<TenorSetting> _settingNotifier;

  @override
  void initState() {
    super.initState();
    _settingNotifier = ValueNotifier(const TenorSetting());
    _categoriesController = GifController()
      ..fetchCategories(_settingNotifier.value.categoriesQuery);
    _trendingController = GifController()
      ..fetchTrendingGifs(_settingNotifier.value.trendingQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (context) =>
                      SettingPage(settingNotifier: _settingNotifier),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          SearchBar.dummy(settingNotifier: _settingNotifier),
          const SizedBox(height: 8),
          Expanded(
            child: CategoriesView(
              categoriesController: _categoriesController,
              trendingController: _trendingController,
              settingNotifier: _settingNotifier,
            ),
          ),
        ],
      ),
    );
  }
}
