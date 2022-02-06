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
    final mediaQuery = MediaQuery.of(context);
    return showModalBottomSheet<TenorGif?>(
      context: context,
      builder: (context) => const TenorGifPicker(),
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      constraints: BoxConstraints(
        maxHeight: mediaQuery.size.height - 40,
        maxWidth: min(mediaQuery.size.width, 800),
      ),
    );

    // return showBottomSheet<TenorGif?>(
    //   context: context,
    //   enableDrag: false,
    //   // constraints: BoxConstraints(
    //   //   maxHeight: MediaQuery.of(context).size.height * 0.8,
    //   //   maxWidth: 480,
    //   // ),
    //   backgroundColor: Colors.transparent,
    //   clipBehavior: Clip.none,
    //   builder: (context) => const TenorGifPicker(),
    // ).closed;
  }

  @override
  State<TenorGifPicker> createState() => _TenorGifPickerState();
}

class _TenorGifPickerState extends State<TenorGifPicker> {
  ///
  Future<bool> _onWillPop() async {
    // if (_context != null && Scaffold.of(_context!).isEndDrawerOpen) {
    //   Navigator.of(_context!).pop();
    //   return false;
    // }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return const App(home: _Home());
    // return Stack(
    //   children: [
    //     Positioned.fill(
    //       child: GestureDetector(
    //         onTap: Navigator.of(context).pop,
    //       ),
    //     ),
    //     Positioned.fill(
    //       child: WillPopScope(
    //         onWillPop: _onWillPop,
    //         child: const App(home: _Home()),
    //       ),
    //     ),
    //     // Positioned(
    //     //   right: 8,
    //     //   bottom: 8,
    //     //   child: SizedBox(
    //     //     width: 400,
    //     //     height: MediaQuery.of(context).size.height * 0.8,
    //     //     child: Material(
    //     //       elevation: 8,
    //     //       borderRadius: const BorderRadius.horizontal(
    //     //         left: Radius.circular(8),
    //     //         right: Radius.circular(8),
    //     //       ),
    //     //       child: WillPopScope(
    //     //         onWillPop: _onWillPop,
    //     //         child: PageStorage(
    //     //           bucket: _bucket,
    //     //           child: const App(home: _Home()),
    //     //         ),
    //     //       ),
    //     //     ),
    //     //   ),
    //     // ),
    //   ],
    // );
  }
}

class _Home extends StatefulWidget {
  const _Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<_Home> with SingleTickerProviderStateMixin {
  late final ValueNotifier<TenorSetting> _settingNotifier;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _settingNotifier = ValueNotifier(const TenorSetting());
    _tabController = TabController(
      length: TenorCategoryType.values.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    // _settingNotifier.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final widgets = TenorCategoryType.values
    //     .map(
    //       (e) => CategoriesView(
    //         type: e,
    //         key: GlobalKey(),
    //       ),
    //     )
    //     .toList();

    return Provider(
      settingNotifier: _settingNotifier,
      child: Builder(
        builder: (context) {
          return Scaffold(
            endDrawer: SizedBox(
              width: min(MediaQuery.of(context).size.width * 0.8, 400),
              child: SettingPage(provider: context.provider!),
            ),
            body: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                // Header
                SliverPersistentHeader(
                  floating: true,
                  delegate: _SliverHeader(
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          _CategoryFilter(controller: _tabController),
                          const SizedBox(height: 8),
                          const SearchBar.dummy(),
                        ],
                      ),
                    ),
                  ),
                ),

                // Body
                // AnimatedBuilder(
                //   animation: _tabController,
                //   builder: (context, child) =>
                //       widgets[_tabController.index],
                // ),
                // widgets[_tabController.index],
                CategoriesView(
                  type: TenorCategoryType.featured,
                ),

                //
              ],
            ),
          );
        },
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
    final scheme = Theme.of(context).colorScheme;
    return Container(
      // margin: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 4),
      height: 40,
      decoration: BoxDecoration(
        color: scheme.surface,
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
                color: scheme.background,
              ),
              unselectedLabelColor: scheme.onSurface.withOpacity(0.5),
              tabs: TenorCategoryType.values.map((type) {
                return Tab(text: type.name, height: 36);
              }).toList(),
            ),
          ),

          const SizedBox(width: 8),

          // Setting
          IconButton(
            onPressed: Scaffold.of(context).openEndDrawer,
            // onPressed: () {},
            icon: const Icon(Icons.settings, size: 20),
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

class _SliverHeader extends SliverPersistentHeaderDelegate {
  _SliverHeader({required this.child});

  final Widget child;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => (40 * 2) + 24;

  @override
  double get minExtent => (40 * 2) + 24;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
