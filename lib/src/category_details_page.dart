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
                  const SliverToBoxAdapter(),

                  // Grid view
                  StateBuilder<TenorCollection>(
                    notifier: _controller,
                    builder: (context, state, child) {
                      // return ValueListenableBuilder<TextEditingValue>(
                      //   valueListenable: _textController,
                      //   builder: (context, value, child) {
                      //     if (value.text.trim().isNotEmpty) {
                      //       // Suggestions
                      //       return const SizedBox();
                      //     }
                      //   },
                      // );
                      return state.maybeMap(
                        initial: (_) {
                          return SliverPadding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 32,
                            ),
                            sliver: SliverToBoxAdapter(
                              child: SuggestionsView(
                                settingNotifier:
                                    widget.provider.settingNotifier,
                              ),
                            ),
                          );
                        },
                        loading: (_) => const SliverGridShimmer(),
                        error: (s) => SliverToBoxAdapter(
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
                                );
                              },
                            ),
                          );
                        },
                        orElse: () => const SliverToBoxAdapter(),
                      );
                    },
                  ),

                  // Suggestion terms
                  // SliverPadding(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 16,
                  //     vertical: 32,
                  //   ),
                  //   sliver: SliverToBoxAdapter(
                  //     child: ValueListenableBuilder<TextEditingValue>(
                  //       valueListenable: _textController,
                  //       builder: (context, value, child) {
                  //         return SuggestionsView(suggestionFor: value.text);
                  //       },
                  //     ),
                  //   ),
                  // ),

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

// class MasonryPage extends StatelessWidget {
//   const MasonryPage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MasonryGridView.count(
//       crossAxisCount: 2,
//       mainAxisSpacing: 4,
//       crossAxisSpacing: 4,
//       itemBuilder: (context, index) {
//         return SizedBox(
//           width: 10,
//           height: 10,
//           child: GifShimmer(),
//         );
//         // return Tile(
//         //   index: index,
//         //   extent: (index % 5 + 1) * 100,
//         // );
//       },
//     );
//   }
// }

///
class SliverGridShimmer extends StatefulWidget {
  ///
  const SliverGridShimmer({Key? key}) : super(key: key);

  @override
  State<SliverGridShimmer> createState() => _MasonryPageState();
}

class _MasonryPageState extends State<SliverGridShimmer> {
  final rnd = Random();
  late List<int> extents;
  int crossAxisCount = 2;

  @override
  void initState() {
    super.initState();
    extents = List<int>.generate(100, (int index) => rnd.nextInt(5) + 1);
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(4),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childCount: extents.length,
        itemBuilder: (context, index) {
          final height = extents[index] * 70.0;
          return SizedBox(
            width: 100,
            height: height,
            child: const GifShimmer(),
          );
        },
      ),
    );
  }
}
