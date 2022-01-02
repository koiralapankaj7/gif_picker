import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gif_picker/gif_picker.dart';
import 'package:gif_picker/src/widgets/error_view.dart';
import 'package:gif_picker/src/widgets/gif_builder.dart';
import 'package:gif_picker/src/widgets/state_builder.dart';

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
  }) : super(key: key);

  ///
  final TenorCategoryTag? categoryTag;

  ///
  final GifController<TenorCollection>? trendingController;

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
      body: Padding(
        padding: MediaQuery.of(context).padding,
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              floating: true,
              // pinned: false,
              delegate: _SliverPersistentHeaderDelegate(
                tabController: _tabController,
              ),
            ),

            // Grid view
            StateBuilder<TenorCollection>(
              notifier: _controller,
              builder: (context, state, child) {
                return state.maybeMap(
                  initial: (_) {
                    return const SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 32,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: _SuggestionView(
                          label: _termSearchMessage,
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
                    return SliverPadding(
                      padding: const EdgeInsets.all(4),
                      sliver: SliverMasonryGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        childCount: s.data.items.length,
                        itemBuilder: (context, index) {
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
    );
  }
}

class _SuggestionView extends StatelessWidget {
  const _SuggestionView({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: List.generate(5, (index) {
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
                'Indexdsds $index',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Colors.white,
                    ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SliverPersistentHeaderDelegate({
    required this.tabController,
  });

  final TabController tabController;
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
          const SizedBox(height: 4),
          const Expanded(
            child: SearchBar(
              padding: EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 100;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

///
class SearchBar extends StatelessWidget {
  ///
  const SearchBar({
    Key? key,
    this.padding,
  }) : super(key: key);

  ///
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: TextField(
        style: Theme.of(context).textTheme.subtitle1,
        decoration: InputDecoration(
          hintText: 'Search Tenor',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          fillColor: Colors.grey.shade400,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          isDense: true,
        ),
      ),
    );
  }
}
