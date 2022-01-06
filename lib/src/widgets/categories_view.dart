import 'package:flutter/material.dart';
import 'package:gif_picker/gif_picker.dart';
import 'package:gif_picker/src/category_details_page.dart';
import 'package:gif_picker/src/widgets/widgets.dart';

///
class CategoriesView extends StatelessWidget {
  ///
  const CategoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.provider!;

    return StateBuilder<TenorCategories>(
      notifier: provider.categoriesController,
      builder: (context, state, child) {
        return state.maybeMap(
          loading: (_) => const _CategoriesShimmer(),
          error: (s) => ErrorView(error: s.error),
          success: (s) {
            final showTrending =
                provider.categoryNotifier.value == TenorCategoryType.featured;
            final isEmoji =
                provider.categoryNotifier.value == TenorCategoryType.emoji;

            return GridView.builder(
              padding: const EdgeInsets.all(4),
              itemCount: s.data.tags.length + (showTrending ? 1 : 0),
              controller: context.slideController?.scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isEmoji ? 3 : 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                mainAxisExtent: 100,
              ),
              itemBuilder: (context, index) {
                if (index == 0 && showTrending) {
                  return const _TrendingView();
                }

                final ind = showTrending ? index - 1 : index;
                return _CategoryTile(tag: s.data.tags[ind]);
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
  const _TrendingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.provider!;

    return StateBuilder<TenorCollection>(
      notifier: provider.trendingController,
      builder: (context, state, child) {
        return state.maybeMap(
          success: (s) {
            final tenorGif = s.data.items.first;
            final gif = tenorGif.media.first.tinyGif;
            return _CategoryTile(
              tag: TenorCategoryTag(
                image: gif.url,
                name: 'trending',
                searchTerm: 'trending',
              ),
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
    Key? key,
    required this.tag,
  }) : super(key: key);

  ///
  final TenorCategoryTag tag;

  void _navigate(BuildContext context) {
    final provider = context.provider!;
    context.provider!.widgetNotifier.value = CategoryDetailPage(
      categoryTag: tag,
      provider: provider,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTrending = tag.name == 'trending';

    final text = Text(
      // tag.searchTerm,
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
              emojiCharacter: tag.character,
              width: constraints.maxWidth,
              height: constraints.minHeight,
              onTap: () => _navigate(context),
              color: Colors.black38,
              colorBlendMode: BlendMode.darken,
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

class _CategoriesShimmer extends StatelessWidget {
  const _CategoriesShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEmoji =
        context.provider!.categoryNotifier.value == TenorCategoryType.emoji;
    return GridView.builder(
      padding: const EdgeInsets.all(4),
      controller: context.slideController?.scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isEmoji ? 3 : 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        mainAxisExtent: 100,
      ),
      itemBuilder: (context, index) => const GifShimmer(),
    );
  }
}
