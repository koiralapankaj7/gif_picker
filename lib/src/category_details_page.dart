import 'dart:math';

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
    required this.categoryTag,
    required this.provider,
  }) : super(key: key);

  ///
  final TenorCategoryTag categoryTag;

  ///
  final Provider provider;

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
    _isTrending = widget.categoryTag.name == 'trending';
    _controller =
        _isTrending ? widget.provider.trendingController : GifController();
    if (!_isTrending) {
      _controller.search(
        widget.provider.settingNotifier.value.searchQuery.copyWith(
          query: widget.categoryTag.searchTerm,
          isEmoji:
              widget.provider.categoryNotifier.value == TenorCategoryType.emoji,
        ),
      );
    }
  }

  @override
  void dispose() {
    if (!_isTrending) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.grey.shade300,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    widget.provider.widgetNotifier.value = null;
                  },
                  icon: const Icon(Icons.arrow_back),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.categoryTag.searchTerm,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ],
            ),
          ),

          //
          Expanded(
            child: LazyLoad(
              onEndOfPage: _controller.loadMore,
              scrollOffset: MediaQuery.of(context).size.height * 0.5,
              child: CustomScrollView(
                controller: context.slideController?.scrollController,
                slivers: [
                  // Workaround for sliver bugs
                  const SliverToBoxAdapter(),

                  // Grid view
                  StateBuilder<TenorCollection>(
                    notifier: _controller,
                    builder: (context, state, child) {
                      return state.maybeMap(
                        loading: (_) => const SliverGridShimmer(),
                        error: (s) => SliverFillRemaining(
                          child: ErrorView(error: s.error),
                        ),
                        success: (s) {
                          final hasNext = s.data.nextNum > 0;
                          final items = s.data.items;
                          const placeholderCount = 10;
                          final childCount =
                              items.length + (hasNext ? placeholderCount : 0);

                          return SliverPadding(
                            padding: const EdgeInsets.all(4),
                            sliver: SliverMasonryGrid.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              childCount: childCount,
                              itemBuilder: (context, index) {
                                if (index > items.length - 1) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
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
                                    if (context.slideController != null) {
                                      context.slideController!
                                          .close(result: tenorGif);
                                    } else {
                                      Navigator.of(context).pop(tenorGif);
                                    }
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
