import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gif_picker/gif_picker.dart';
import 'package:gif_picker/src/setting_page.dart';
import 'package:gif_picker/src/widgets/widgets.dart';

///
class SearchPage extends StatefulWidget {
  ///
  const SearchPage({
    required this.provider,
    super.key,
  });

  ///
  final Provider provider;

  @override
  State createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final GifController<TenorCollection> _controller;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _controller = GifController(state: const BaseState.loading());
    _textController = TextEditingController();
    widget.provider.settingNotifier.addListener(_settingListener);
  }

  //
  void _settingListener() {
    _performSearch(_textController.text);
  }

  //
  void _performSearch(String text) {
    _controller.search(
      widget.provider.settingNotifier.value.searchQuery.copyWith(query: text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: const EdgeInsets.all(8),
            child: GifSearchBar.main(
              controller: _textController,
              onChanged: _performSearch,
            ),
          ),
          const Divider(),
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
                      /// Because of this issue
                      /// https://github.com/flutter/flutter/issues/55170
                      const SliverToBoxAdapter(),

                      // Grid view
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _textController,
                        builder: (context, value, child) {
                          if (value.text.isEmpty) {
                            return SliverFillRemaining(
                              child: SuggestionsView(
                                key: const ValueKey('SuggestionsView'),
                                settingNotifier:
                                    widget.provider.settingNotifier,
                                onSelect: (text) {
                                  _textController.text = text;
                                  _performSearch(text);
                                },
                              ),
                            );
                          }
                          return child!;
                        },
                        child: StateBuilder<TenorCollection>(
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
                      ),

                      // Suggested keywords
                      StateBuilder<TenorCollection>(
                        notifier: _controller,
                        builder: (context, state, child) {
                          return state.maybeMap(
                            success: (s) {
                              final hasNext = s.data.nextNum > 0;
                              if (hasNext) return const SliverToBoxAdapter();

                              return SliverToBoxAdapter(
                                child: ValueListenableBuilder<TextEditingValue>(
                                  valueListenable: _textController,
                                  builder: (context, value, child) {
                                    return SuggestionsView(
                                      suggestionFor: value.text,
                                      settingNotifier:
                                          widget.provider.settingNotifier,
                                      onSelect: (text) {
                                        _textController.text = text;
                                        _performSearch(text);
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

  @override
  void dispose() {
    widget.provider.settingNotifier.removeListener(_settingListener);
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }
}
