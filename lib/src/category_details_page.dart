import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gif_picker/gif_picker.dart';
import 'package:gif_picker/src/setting_page.dart';
import 'package:gif_picker/src/widgets/widgets.dart';

///
class CategoryDetailPage extends StatefulWidget {
  ///
  const CategoryDetailPage({
    Key? key,
    required this.type,
    required this.categoryTag,
    required this.provider,
    this.controller,
  }) : super(key: key);

  ///
  final TenorCategoryType type;

  ///
  final TenorCategoryTag categoryTag;

  ///
  final Provider provider;

  ///
  final GifController<TenorCollection>? controller;

  @override
  State createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage>
    with TickerProviderStateMixin {
  final rnd = Random();
  late List<int> extents;
  late final GifController<TenorCollection> _controller;
  late bool _isTrending;

  @override
  void initState() {
    super.initState();
    extents = List<int>.generate(20, (int index) => rnd.nextInt(5) + 1);
    _isTrending = widget.controller != null;
    _controller = widget.controller ?? GifController();
    _fetchDetail();
    widget.provider.settingNotifier.addListener(_settingListener);
  }

  //
  void _fetchDetail() {
    final setting = widget.provider.settingNotifier.value;
    if (!_isTrending) {
      _controller.search(
        setting.searchQuery.copyWith(
          query: widget.categoryTag.searchTerm,
          isEmoji: widget.type == TenorCategoryType.emoji,
        ),
      );
    }
  }

  //
  void _settingListener() {
    if (!_isTrending) {
      _fetchDetail();
    } else {
      final setting = widget.provider.settingNotifier.value;
      _controller.fetchTrendingGifs(setting.trendingQuery);
    }
  }

  @override
  void dispose() {
    widget.provider.settingNotifier.removeListener(_settingListener);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  onPressed: context.xNavigator?.pop,
                  icon: const Icon(CupertinoIcons.chevron_left),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.type == TenorCategoryType.emoji
                        ? widget.categoryTag.name
                        : widget.categoryTag.searchTerm,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          //
          Expanded(
            child: LazyLoad(
              onEndOfPage: _controller.loadMore,
              scrollOffset: MediaQuery.of(context).size.height * 0.5,
              child: ResponsiveLayoutBuilder(
                child: (size) {
                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    slivers: [
                      // Workaround for sliver bugs
                      const SliverToBoxAdapter(),

                      // Grid view
                      StateBuilder<TenorCollection>(
                        notifier: _controller,
                        builder: (context, state, child) {
                          return state.maybeMap(
                            loading: (_) => SliverGridShimmer(size: size),
                            error: (s) => SliverFillRemaining(
                              child: ErrorView(error: s.error),
                            ),
                            success: (s) {
                              final hasNext = s.data.nextNum > 0;
                              final items = s.data.items;
                              const placeholderCount = 10;
                              final childCount = items.length +
                                  (hasNext ? placeholderCount : 0);

                              return SliverPadding(
                                padding: const EdgeInsets.all(4),
                                sliver: SliverMasonryGrid.count(
                                  crossAxisCount: size.gridCrossAxisCount,
                                  mainAxisSpacing: 4,
                                  crossAxisSpacing: 4,
                                  childCount: childCount,
                                  itemBuilder: (context, index) {
                                    if (index > items.length - 1) {
                                      return GifShimmer(
                                        width: 100,
                                        height: 100.0 * (index % 3 + 1),
                                      );
                                    }

                                    final tenorGif = s.data.items[index];
                                    final gif = tenorGif.media.first.tinyGif;
                                    return GifBuilder(
                                      url: gif.url,
                                      width: gif.dimension[0].toDouble(),
                                      height: gif.dimension[1].toDouble(),
                                      onTap: () {
                                        Navigator.of(context).pop(tenorGif);
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                            orElse: () => const SliverToBoxAdapter(),
                          );
                        },
                      ),

                      //
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
