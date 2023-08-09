import 'package:flutter/material.dart';
import 'package:gif_picker/gif_picker.dart';
import 'package:gif_picker/src/widgets/widgets.dart';

///
class HomeTabs extends StatefulWidget {
  ///
  const HomeTabs({
    super.key,
    this.initialIndex = 0,
  });

  ///
  final int initialIndex;

  @override
  State<HomeTabs> createState() => _StickersTabsState();
}

class _StickersTabsState extends State<HomeTabs> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: TenorCategoryType.values.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top),
        const Padding(
          padding: EdgeInsets.all(8),
          child: GifSearchBar.dummy(),
        ),
        const Divider(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: TenorCategoryType.values.map((type) {
              return CategoriesView(
                key: Key('CategoryTabs_${type}_TabBarView'),
                type: type,
                provider: context.provider!,
              );
            }).toList(),
          ),
        ),
        const Divider(),
        TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: BoxDecoration(
            color: scheme.background,
            borderRadius: BorderRadius.circular(16),
          ),
          indicatorPadding: const EdgeInsets.symmetric(vertical: 8),
          // unselectedLabelColor: scheme.onSurface.withOpacity(0.5),
          tabs: TenorCategoryType.values.map((type) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Tab(
                key: Key('CategoryTabs_${type}_Tab'),
                text: type.name,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
