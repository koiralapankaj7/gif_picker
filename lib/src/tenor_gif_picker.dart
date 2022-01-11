import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gif_picker/gif_picker.dart';
import 'package:gif_picker/src/setting_page.dart';
import 'package:gif_picker/src/widgets/widgets.dart';

/// {@template tenor_gif_picker}
/// {@endtemplate}
class TenorGifPicker extends StatefulWidget {
  /// {@macro tenor_gif_picker}
  const TenorGifPicker({Key? key}) : super(key: key);

  ///
  /// Pick media
  static Future<TenorGif?> pick(BuildContext context) {
    if (context.slideController != null) {
      return context.slideController!.open<TenorGif>(const TenorGifPicker());
    } else {
      return Navigator.of(context).push<TenorGif?>(
        MaterialPageRoute(builder: (context) => const TenorGifPicker()),
      );
    }
  }

  @override
  State<TenorGifPicker> createState() => _TenorGifPickerState();
}

class _TenorGifPickerState extends State<TenorGifPicker>
    with SingleTickerProviderStateMixin {
  // late final GifController<TenorCategories> _categoriesController;
  // late final GifController<TenorCollection> _trendingController;
  late final ValueNotifier<TenorSetting> _settingNotifier;
  late final PickerNavigator _pickerNavigator;
  // late final ValueNotifier<TenorCategoryType> _categoryNotifier;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _settingNotifier = ValueNotifier(const TenorSetting())
      ..addListener(_fetchData);
    // _categoriesController = GifController();
    // _trendingController = GifController();
    _pickerNavigator = PickerNavigator();
    // _categoryNotifier = ValueNotifier(TenorCategoryType.featured)
    //   ..addListener(_fetchData);
    _fetchData();
    _tabController = TabController(
      length: TenorCategoryType.values.length,
      vsync: this,
    );
  }

  void _fetchData() {
    // _categoriesController.fetchCategories(
    //   _settingNotifier.value.categoriesQuery.copyWith(
    //     type: _categoryNotifier.value,
    //   ),
    // );
    // if (_categoryNotifier.value == TenorCategoryType.featured) {
    //   _trendingController.fetchTrendingGifs(
    //     _settingNotifier.value.trendingQuery,
    //   );
    // }
  }

  @override
  void dispose() {
    _settingNotifier.removeListener(_fetchData);
    // _categoryNotifier.removeListener(_fetchData);
    // _categoriesController.dispose();
    // _trendingController.dispose();
    // _categoryNotifier.dispose();
    _pickerNavigator.dispose();
    _settingNotifier.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pickerNavigator.isNotEmpty) {
          _pickerNavigator.pop();
          return false;
        }
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
        settingNotifier: _settingNotifier,
        pickerNavigator: _pickerNavigator,
        child: Builder(
          builder: (context) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              endDrawer: SizedBox(
                width: min(MediaQuery.of(context).size.width * 0.8, 400),
                child: SettingPage(provider: context.provider!),
              ),
              // appBar: fullScreenMode ? AppBar() : null,
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
                child: ValueListenableBuilder<List<Widget>>(
                  valueListenable: _pickerNavigator,
                  builder: (context, widgets, child) =>
                      widgets.isEmpty ? child! : widgets.last,
                  child: ResponsiveLayoutBuilder(
                    small: (context, child) {
                      return Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).padding.top,
                          ),
                          const SearchBar.dummy(),
                          _CategoryFilter(controller: _tabController),
                          Expanded(child: child!),
                        ],
                      );
                    },
                    medium: (context, child) {
                      return Column(
                        children: [
                          const SearchBar.dummy(),
                          _CategoryFilter(controller: _tabController),
                          Expanded(child: child!),
                        ],
                      );
                    },
                    large: (context, child) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              const Expanded(child: SearchBar.dummy()),
                              Expanded(
                                child:
                                    _CategoryFilter(controller: _tabController),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Expanded(child: child!),
                        ],
                      );
                    },
                    xLarge: (context, child) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              const Expanded(child: SearchBar.dummy()),
                              Expanded(
                                child:
                                    _CategoryFilter(controller: _tabController),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Expanded(child: child!),
                        ],
                      );
                    },
                    child: (size) => TabBarView(
                      controller: _tabController,
                      children: TenorCategoryType.values.map((type) {
                        return CategoriesView(
                          type: type,
                          provider: context.provider!,
                        );
                      }).toList(),
                    ),
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

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({
    Key? key,
    required this.controller,
  }) : super(key: key);

  ///
  final TabController controller;

  @override
  Widget build(BuildContext context) {
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
              controller: controller,
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
              }
              Scaffold.of(context).openEndDrawer();
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

///
class PickerNavigator extends ValueNotifier<List<Widget>> {
  ///
  PickerNavigator() : super([]);

  ///
  void pop() {
    value = value.sublist(0, value.length - 1);
  }

  ///
  void push(Widget widget) {
    value = value.toList()..add(widget);
  }

  ///
  bool get isEmpty => value.isEmpty;

  ///
  bool get isNotEmpty => value.isNotEmpty;
}
