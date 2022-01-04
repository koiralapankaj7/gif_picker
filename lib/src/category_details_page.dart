import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gif_picker/gif_picker.dart';
import 'package:gif_picker/src/widgets/widgets.dart';

///
class CategoryDetailPage extends StatefulWidget {
  ///
  const CategoryDetailPage({
    Key? key,
    this.categoryTag,
    this.trendingController,
    this.trendingTermsController,
  }) : super(key: key);

  ///
  final TenorCategoryTag? categoryTag;

  ///
  final GifController<TenorCollection>? trendingController;

  ///
  final GifController<TenorTerms>? trendingTermsController;

  @override
  State createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage>
    with TickerProviderStateMixin {
  final rnd = Random();
  late List<int> extents;
  late TabController _tabController;
  late final GifController<TenorCollection> _controller;

  @override
  void initState() {
    super.initState();
    extents = List<int>.generate(20, (int index) => rnd.nextInt(5) + 1);
    _tabController = TabController(length: 3, vsync: this);
    _controller = widget.trendingController ?? GifController();
    if (widget.categoryTag != null && widget.trendingController == null) {
      _controller.search(
        query: TenorSearchQuary(query: widget.categoryTag!.searchTerm),
      );
    }
  }

  @override
  void dispose() {
    if (widget.trendingController == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.grey.shade300,
      body: LazyLoad(
        onEndOfPage: _controller.loadMore,
        scrollOffset: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: MediaQuery.of(context).padding,
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                floating: true,
                // pinned: false,
                delegate: _SliverPersistentHeaderDelegate(
                  tabController: _tabController,
                  onTextChanged: (text) {
                    // On change => Auto-complete
                    // On submit => search
                  },
                ),
              ),

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
                      return const SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 32,
                        ),
                        sliver: SliverToBoxAdapter(child: SuggestionsView()),
                      );
                    },
                    loading: (_) => const SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
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
    );
  }
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SliverPersistentHeaderDelegate({
    required this.tabController,
    required this.onTextChanged,
  });

  final TabController tabController;
  final ValueChanged<String>? onTextChanged;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.cyan,
              borderRadius: BorderRadius.circular(4),
            ),
            child: TabBar(
              controller: tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.black87,
              ),
              tabs: List.generate(3, (index) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text('Index $index'),
                );
              }),
            ),
          ),
          const SizedBox(height: 2),
          // Expanded(
          //   child: Align(child: SearchBar.main(onChanged: onTextChanged)),
          // ),
          const SizedBox(height: 2),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 90;

  @override
  double get minExtent => 90;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
