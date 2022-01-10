import 'package:flutter/material.dart';
import 'package:gif_picker/gif_picker.dart';
import 'package:gif_picker/src/setting_page.dart';
import 'package:gif_picker/src/widgets/widgets.dart';

/// {@template gif_picker}
/// {@endtemplate}
class GifPicker extends StatefulWidget {
  /// {@macro gif_picker}
  const GifPicker({Key? key}) : super(key: key);

  ///
  /// Pick media
  static Future<TenorGif?> pick(BuildContext context) {
    if (context.slideController != null) {
      context.slideController!.attachView(const GifPicker());
      return Future.value();
    } else {
      return Navigator.of(context).push<TenorGif?>(
        MaterialPageRoute(builder: (context) => const GifPicker()),
      );
    }
  }

  @override
  State createState() => _GifPickerState();
}

class _GifPickerState extends State<GifPicker> {
  late final GifController<TenorCategories> _categoriesController;
  late final GifController<TenorCollection> _trendingController;
  late final ValueNotifier<TenorSetting> _settingNotifier;
  late final ValueNotifier<Widget?> _widgetNotifier;
  late final ValueNotifier<TenorCategoryType> _categoryNotifier;

  @override
  void initState() {
    super.initState();
    _settingNotifier = ValueNotifier(const TenorSetting())
      ..addListener(_fetchData);
    _categoriesController = GifController();
    _trendingController = GifController();
    _widgetNotifier = ValueNotifier(null);
    _categoryNotifier = ValueNotifier(TenorCategoryType.featured)
      ..addListener(_fetchData);
    _fetchData();
  }

  void _fetchData() {
    _categoriesController.fetchCategories(
      _settingNotifier.value.categoriesQuery.copyWith(
        type: _categoryNotifier.value,
      ),
    );
    if (_categoryNotifier.value == TenorCategoryType.featured) {
      _trendingController.fetchTrendingGifs(
        _settingNotifier.value.trendingQuery,
      );
    }
  }

  @override
  void dispose() {
    _settingNotifier.removeListener(_fetchData);
    _categoryNotifier.removeListener(_fetchData);
    _categoriesController.dispose();
    _trendingController.dispose();
    _widgetNotifier.dispose();
    _settingNotifier.dispose();
    _categoryNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fullScreenMode = context.slideController == null;

    return WillPopScope(
      onWillPop: () async {
        final slide = context.slideController;
        if (slide?.isVisible ?? false) {
          if (slide!.slideState == SlideState.max) {
            slide.minimize();
          } else {
            slide.close();
          }
          return false;
        }
        return true;
      },
      child: Provider(
        categoriesController: _categoriesController,
        trendingController: _trendingController,
        settingNotifier: _settingNotifier,
        widgetNotifier: _widgetNotifier,
        categoryNotifier: _categoryNotifier,
        child: Builder(
          builder: (context) {
            return Scaffold(
              backgroundColor: fullScreenMode ? null : Colors.transparent,
              appBar: fullScreenMode
                  ? AppBar(
                      actions: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.settings),
                        ),
                      ],
                    )
                  : null,
              body: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.onBackground,
                      blurRadius: 8,
                      spreadRadius: -8,
                    ),
                  ],
                ),
                child: ValueListenableBuilder<Widget?>(
                  valueListenable: _widgetNotifier,
                  builder: (context, view, child) =>
                      view ??
                      Column(
                        children: [
                          _CategoryFilter(
                            initialIndex: TenorCategoryType.values
                                .indexOf(_categoryNotifier.value),
                          ),
                          const SearchBar.dummy(),
                          const SizedBox(height: 4),
                          const Expanded(child: CategoriesView()),
                        ],
                      ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryFilter extends StatefulWidget {
  const _CategoryFilter({
    Key? key,
    this.initialIndex = 0,
  }) : super(key: key);

  final int initialIndex;

  @override
  State<_CategoryFilter> createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<_CategoryFilter>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: TenorCategoryType.values.length,
      initialIndex: widget.initialIndex,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.provider!;

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.black38,
              ),
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.black,
              tabs: TenorCategoryType.values.map((type) {
                return Tab(text: type.name, height: 36);
              }).toList(),
              onTap: (index) {
                provider.categoryNotifier.value =
                    TenorCategoryType.values[index];
              },
            ),
          ),

          const SizedBox(width: 8),

          // Setting
          IconButton(
            onPressed: () {
              final slideController = context.slideController;
              if (slideController != null &&
                  slideController.slideState != SlideState.max) {
                slideController.maximize();
              } else {
                // Navigator.of(context).push<void>(
                //   MaterialPageRoute(
                //     builder: (context) => const GifSetting(),
                //   ),
                // );
              }
              final provider = context.provider!;
              provider.widgetNotifier.value = SettingPage(provider: provider);
            },
            icon: const Icon(Icons.settings),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints.tight(const Size(42, 42)),
          ),

          //
        ],
      ),
    );
  }
}
