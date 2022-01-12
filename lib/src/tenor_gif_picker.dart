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
      return context.slideController!.open<TenorGif?>(const TenorGifPicker());
    } else {
      final mediaQuery = MediaQuery.of(context);
      return showModalBottomSheet<TenorGif?>(
        context: context,
        builder: (context) => const TenorGifPicker(),
        isScrollControlled: true,
        constraints: BoxConstraints(
          maxHeight: min(mediaQuery.size.height - mediaQuery.padding.top, 900),
          maxWidth: min(mediaQuery.size.width, 800),
        ),
      );
    }
  }

  @override
  State<TenorGifPicker> createState() => _TenorGifPickerState();
}

class _TenorGifPickerState extends State<TenorGifPicker>
    with SingleTickerProviderStateMixin {
  late final ValueNotifier<TenorSetting> _settingNotifier;
  late final PickerNavigator _pickerNavigator;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _settingNotifier = ValueNotifier(const TenorSetting());
    _pickerNavigator = PickerNavigator();
    _tabController = TabController(
      length: TenorCategoryType.values.length,
      vsync: this,
    );
  }

  ///
  Future<bool> _onWillPop() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
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
              body: ValueListenableBuilder<List<Widget>>(
                valueListenable: _pickerNavigator,
                builder: (context, widgets, child) {
                  return IndexedStack(
                    index: _pickerNavigator.currentIndex,
                    children: [child!, ...widgets],
                  );
                },
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
                    physics: const NeverScrollableScrollPhysics(),
                    children: TenorCategoryType.values.map((type) {
                      return CategoriesView(
                        type: type,
                        provider: context.provider!,
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pickerNavigator.dispose();
    _settingNotifier.dispose();
    _tabController.dispose();
    super.dispose();
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
      margin: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 4),
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

  ///
  int get currentIndex => isEmpty ? 0 : value.length;
}
