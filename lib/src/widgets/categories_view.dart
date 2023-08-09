import 'package:flutter/material.dart';
import 'package:gif_picker/gif_picker.dart';
import 'package:gif_picker/src/category_details_page.dart';
import 'package:gif_picker/src/setting_page.dart';
import 'package:gif_picker/src/widgets/widgets.dart';

///
class SliverCategoriesView extends StatefulWidget {
  ///
  const SliverCategoriesView({
    required this.type,
    super.key,
    // required this.provider,
  });

  ///
  final TenorCategoryType type;

  ///
  // final Provider provider;

  @override
  State<SliverCategoriesView> createState() => _SliverCategoriesViewState();
}

class _SliverCategoriesViewState extends State<SliverCategoriesView>
    with AutomaticKeepAliveClientMixin<SliverCategoriesView> {
  late final GifController<TenorCategories> _controller;
  late final GifController<TenorCollection> _trendingController;
  late final ValueNotifier<TenorSetting> _settingNotifier;

  @override
  void initState() {
    super.initState();
    _controller = GifController();
    _trendingController = GifController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _settingNotifier = context.provider!.settingNotifier
        ..addListener(_fetchData);
      _fetchData();
    });
    // widget.provider.settingNotifier.addListener(_fetchData);
  }

  // @override
  // void didUpdateWidget(covariant CategoriesView oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.type != widget.type) {
  //     // _fetchData();
  //   }
  // }

  void _fetchData() {
    final setting = _settingNotifier.value;
    _controller.fetchCategories(
      setting.categoriesQuery.copyWith(type: widget.type),
    );
    if (widget.type == TenorCategoryType.featured) {
      _trendingController.fetchTrendingGifs(setting.trendingQuery);
    }
  }

  @override
  void dispose() {
    _settingNotifier.removeListener(_fetchData);
    Future.delayed(
      const Duration(milliseconds: 500),
      _trendingController.dispose,
    );
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StateBuilder<TenorCategories>(
      notifier: _controller,
      builder: (context, state, child) {
        return state.maybeMap(
          loading: (_) => _SliverCategoriesShimmer(type: widget.type),
          error: (s) => SliverFillRemaining(
            child: ErrorView(error: s.error),
          ),
          success: (s) {
            final showTrending = widget.type == TenorCategoryType.featured;
            final isEmoji = widget.type == TenorCategoryType.emoji;

            final crossAxisCount = isEmoji ? 4 : 2;

            return SliverPadding(
              padding: const EdgeInsets.all(4),
              sliver: SliverGrid(
                key: PageStorageKey<String>('${widget.key}'),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  mainAxisExtent: 100,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == 0 && showTrending) {
                      return _TrendingView(
                        type: widget.type,
                        controller: _trendingController,
                      );
                    }

                    final ind = showTrending ? index - 1 : index;
                    return _CategoryTile(
                      tag: s.data.tags[ind],
                      type: widget.type,
                    );
                  },
                  childCount: s.data.tags.length + (showTrending ? 1 : 0),
                ),
              ),
            );
          },
          orElse: () => const SliverToBoxAdapter(),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

///
class CategoriesView extends StatefulWidget {
  ///
  const CategoriesView({
    required this.type,
    required this.provider,
    super.key,
  });

  ///
  final TenorCategoryType type;

  ///
  final Provider provider;

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView>
    with AutomaticKeepAliveClientMixin<CategoriesView> {
  late final GifController<TenorCategories> _controller;
  late final GifController<TenorCollection> _trendingController;

  @override
  void initState() {
    super.initState();
    _controller = GifController();
    _trendingController = GifController();
    widget.provider.settingNotifier.addListener(_fetchData);
    _fetchData();
  }

  void _fetchData() {
    final setting = widget.provider.settingNotifier.value;
    _controller.fetchCategories(
      setting.categoriesQuery.copyWith(type: widget.type),
    );
    if (widget.type == TenorCategoryType.featured) {
      _trendingController.fetchTrendingGifs(setting.trendingQuery);
    }
  }

  @override
  void dispose() {
    widget.provider.settingNotifier.removeListener(_fetchData);
    Future.delayed(
      const Duration(milliseconds: 500),
      _trendingController.dispose,
    );
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StateBuilder<TenorCategories>(
      notifier: _controller,
      builder: (context, state, child) {
        return state.maybeMap(
          loading: (_) => _CategoriesShimmer(type: widget.type),
          error: (s) => ErrorView(error: s.error),
          success: (s) {
            final showTrending = widget.type == TenorCategoryType.featured;
            final isEmoji = widget.type == TenorCategoryType.emoji;

            return ResponsiveLayoutBuilder(
              small: (context, child) => child!,
              medium: (context, child) => child!,
              large: (context, child) => child!,
              child: (size) {
                final crossAxisCount = isEmoji
                    ? size.gridCrossAxisCount + 1
                    : size.gridCrossAxisCount;

                return GridView.builder(
                  key: PageStorageKey<String>('${widget.key}'),
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.all(4),
                  itemCount: s.data.tags.length + (showTrending ? 1 : 0),
                  // controller: context.slideController?.scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    mainAxisExtent: 100,
                  ),
                  itemBuilder: (context, index) {
                    if (index == 0 && showTrending) {
                      return _TrendingView(
                        type: widget.type,
                        controller: _trendingController,
                      );
                    }

                    final ind = showTrending ? index - 1 : index;
                    return _CategoryTile(
                      tag: s.data.tags[ind],
                      type: widget.type,
                    );
                  },
                );
              },
            );
          },
          orElse: () => const SizedBox(),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _TrendingView extends StatelessWidget {
  const _TrendingView({
    required this.type,
    required this.controller,
  });

  final TenorCategoryType type;
  final GifController<TenorCollection> controller;

  @override
  Widget build(BuildContext context) {
    return StateBuilder<TenorCollection>(
      notifier: controller,
      builder: (context, state, child) {
        return state.maybeMap(
          success: (s) {
            final tenorGif = s.data.items.first;
            final gif = tenorGif.media.first.tinyGif;
            return _CategoryTile(
              type: type,
              tag: TenorCategoryTag(
                image: gif.url,
                name: 'trending',
                searchTerm: 'trending',
              ),
              trendingController: controller,
            );
          },
          orElse: () => const GifShimmer(),
        );
      },
    );
  }
}

///
class _CategoryTile extends StatelessWidget {
  ///
  const _CategoryTile({
    required this.tag,
    required this.type,
    this.trendingController,
  });

  ///
  final TenorCategoryTag tag;

  ///
  final TenorCategoryType type;

  final GifController<TenorCollection>? trendingController;

  void _navigate(BuildContext context) {
    final provider = context.provider!;
    context.xNavigator?.push(
      CategoryDetailPage(
        type: type,
        categoryTag: tag,
        controller: trendingController,
        provider: provider,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final scheme = Theme.of(context).colorScheme;

    final isTrending = tag.name == 'trending';

    final text = Text(
      // tag.searchTerm,
      tag.name.replaceAll('#', ''),
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.white,
          ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            GifBuilder(
              url: tag.image,
              emojiCharacter: tag.character,
              width: constraints.maxWidth,
              height: constraints.minHeight,
              onTap: () => _navigate(context),
              color: Colors.black38,
            ),
            Positioned(
              left: 8,
              bottom: 8,
              child: isTrending
                  ? Row(
                      children: [
                        const Icon(
                          Icons.trending_up,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        text
                      ],
                    )
                  : text,
            ),
          ],
        );
      },
    );
  }
}

class _SliverCategoriesShimmer extends StatelessWidget {
  const _SliverCategoriesShimmer({
    required this.type,
  });

  final TenorCategoryType type;

  @override
  Widget build(BuildContext context) {
    final isEmoji = type == TenorCategoryType.emoji;
    final crossAxisCount = isEmoji ? 4 : 2;
    return SliverPadding(
      padding: const EdgeInsets.all(4),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          mainAxisExtent: 100,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => const GifShimmer(color: Colors.black38),
        ),
      ),
    );
  }
}

class _CategoriesShimmer extends StatelessWidget {
  const _CategoriesShimmer({required this.type});

  final TenorCategoryType type;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      child: (size) {
        final isEmoji = type == TenorCategoryType.emoji;
        final crossAxisCount =
            isEmoji ? size.gridCrossAxisCount + 1 : size.gridCrossAxisCount;
        return GridView.builder(
          padding: const EdgeInsets.all(4),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            mainAxisExtent: 100,
          ),
          itemBuilder: (context, index) => const GifShimmer(),
        );
      },
    );
  }
}
