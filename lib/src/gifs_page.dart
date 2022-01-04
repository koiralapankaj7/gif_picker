import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gif_picker/gif_picker.dart';
import 'package:gif_picker/src/widgets/widgets.dart';

const String _termSearchMessage = 'Enter a search term above and find the '
    'perfect GIF to express hou you really feel.';

const String _suggestionTermsMessage =
    'Your perfect GIF is in another castle. Try the suggested keywords below!';

///
class GifsPage extends StatefulWidget {
  ///
  const GifsPage({
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
  State createState() => _GifsPageState();
}

class _GifsPageState extends State<GifsPage> with TickerProviderStateMixin {
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
                  return state.maybeMap(
                    initial: (_) {
                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 32,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: _SuggestionView(
                            label: _termSearchMessage,
                            controller: widget.trendingTermsController,
                          ),
                        ),
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
              // const SliverPadding(
              //   padding: EdgeInsets.symmetric(
              //     horizontal: 16,
              //     vertical: 32,
              //   ),
              //   sliver: SliverToBoxAdapter(
              //     child: _SuggestionView(
              //       label: _suggestionTermsMessage,
              //       // label: _termSearchMessage,
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

class _SuggestionView extends StatelessWidget {
  const _SuggestionView({
    Key? key,
    required this.label,
    this.controller,
  }) : super(key: key);

  final String label;

  final GifController<TenorTerms>? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          child: Icon(Icons.search),
        ),
        const SizedBox(height: 24),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyText2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        if (controller != null)
          StateBuilder<TenorTerms>(
            notifier: controller!,
            builder: (context, state, child) {
              return state.maybeMap(
                success: (s) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: s.data.results.map((term) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          term,
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      );
                    }).toList(),
                  );
                },
                orElse: () => const SizedBox(),
              );
            },
          ),
      ],
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
          Expanded(child: Align(child: SearchBar(onChanged: onTextChanged))),
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
