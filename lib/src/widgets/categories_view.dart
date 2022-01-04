import 'package:flutter/material.dart';
import 'package:gif_picker/gif_picker.dart';
import 'package:gif_picker/src/category_details_page.dart';
import 'package:gif_picker/src/widgets/error_view.dart';
import 'package:gif_picker/src/widgets/gif_builder.dart';
import 'package:gif_picker/src/widgets/state_builder.dart';

///
class CategoriesView extends StatelessWidget {
  ///
  const CategoriesView({
    Key? key,
    required this.categoriesController,
    required this.trendingController,
  }) : super(key: key);

  ///
  final GifController<TenorCategories> categoriesController;

  /// Trending controller
  final GifController<TenorCollection> trendingController;

  @override
  Widget build(BuildContext context) {
    return StateBuilder<TenorCategories>(
      notifier: categoriesController,
      builder: (context, state, child) {
        return state.maybeMap(
          loading: (_) => const Center(child: CircularProgressIndicator()),
          error: (s) => ErrorView(error: s.error),
          success: (s) {
            return GridView.builder(
              padding: const EdgeInsets.all(4),
              itemCount: s.data.tags.length + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                mainAxisExtent: 100,
              ),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _TrendingView(controller: trendingController);
                }
                return _CategoryTile(tag: s.data.tags[index - 1]);
              },
            );
          },
          orElse: () => const SizedBox(),
        );
      },
    );
  }
}

class _TrendingView extends StatelessWidget {
  const _TrendingView({
    Key? key,
    required this.controller,
  }) : super(key: key);

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
              tag: TenorCategoryTag(
                image: gif.url,
                name: 'Trending',
              ),
              trendingController: controller,
            );
          },
          orElse: () => const SizedBox(),
        );
      },
    );
  }
}

///
class _CategoryTile extends StatelessWidget {
  ///
  const _CategoryTile({
    Key? key,
    required this.tag,
    this.trendingController,
  }) : super(key: key);

  ///
  final TenorCategoryTag tag;

  ///
  final GifController<TenorCollection>? trendingController;

  void _navigate(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => CategoryDetailPage(
          categoryTag: tag,
          trendingController: trendingController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTrending = tag.name == 'Trending';

    final text = Text(
      tag.name.replaceAll('#', ''),
      style: Theme.of(context).textTheme.subtitle2?.copyWith(
            color: Colors.white,
          ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            GifBuilder(
              url: tag.image,
              width: constraints.maxWidth,
              height: constraints.minHeight,
              onTap: () => _navigate(context),
              onTapUp: () => _navigate(context),
              color: Colors.black38,
              colorBlendMode: BlendMode.darken,
            ),
            Positioned(
              left: 12,
              bottom: 12,
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
