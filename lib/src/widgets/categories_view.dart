import 'package:flutter/material.dart';
import 'package:gif_picker/gif_picker.dart';
import 'package:gif_picker/src/gifs_page.dart';
import 'package:gif_picker/src/widgets/error_view.dart';
import 'package:gif_picker/src/widgets/gif_builder.dart';
import 'package:gif_picker/src/widgets/state_builder.dart';

///
class CategoriesView extends StatelessWidget {
  ///
  const CategoriesView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  ///
  final GifController<TenorCategories> controller;

  @override
  Widget build(BuildContext context) {
    return StateBuilder<TenorCategories>(
      notifier: controller,
      builder: (context, state, child) {
        return state.maybeMap(
          loading: (_) => const Center(child: CircularProgressIndicator()),
          error: (s) => ErrorView(error: s.error),
          success: (s) {
            return GridView.builder(
              padding: const EdgeInsets.all(4),
              itemCount: s.data.tags.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                mainAxisExtent: 100,
              ),
              itemBuilder: (context, index) {
                return _CategoryTile(tag: s.data.tags[index]);
              },
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
  }) : super(key: key);

  ///
  final TenorCategoryTag tag;

  void _navigate(BuildContext context) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => GifsPage(categoryTag: tag),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              child: Text(
                tag.name.replaceAll('#', ''),
                style: Theme.of(context).textTheme.subtitle2?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }
}
