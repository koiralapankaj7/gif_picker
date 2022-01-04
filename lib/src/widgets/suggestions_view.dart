import 'package:flutter/material.dart';
import 'package:gif_picker/gif_picker.dart';
import 'package:gif_picker/src/widgets/widgets.dart';

const _termSearchMessage = 'Enter a search term above and find the '
    'perfect GIF to express hou you really feel.';

const _suggestionTermsMessage =
    'Your perfect GIF is in another castle. Try the suggested keywords below!';

///
class SuggestionsView extends StatefulWidget {
  ///
  const SuggestionsView({
    Key? key,
    this.suggestionFor,
    this.onSelect,
  }) : super(key: key);

  ///
  final String? suggestionFor;

  ///
  final ValueSetter<String>? onSelect;

  @override
  State createState() => _SuggestionsViewState();
}

class _SuggestionsViewState extends State<SuggestionsView> {
  late final GifController<TenorTerms> _controller;

  @override
  void initState() {
    super.initState();
    _controller = GifController<TenorTerms>();
    if (widget.suggestionFor == null) {
      _controller.fetchTrendingSearchTerms(query: const TenorQuery(limit: 7));
    } else if (widget.suggestionFor != null) {
      _controller.fetchSuggestions(
        query: TenorSearchSuggestionsQuery(
          limit: 7,
          query: widget.suggestionFor!,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSuggestion = widget.suggestionFor != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          if (!isSuggestion) const CircleAvatar(child: Icon(Icons.search)),
          const SizedBox(height: 24),
          Text(
            widget.suggestionFor == null
                ? _termSearchMessage
                : _suggestionTermsMessage,
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          StateBuilder<TenorTerms>(
            notifier: _controller,
            builder: (context, state, child) {
              return state.maybeMap(
                success: (s) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: s.data.results.map((term) {
                      return SuggestionChip(
                        label: term,
                        onPressed: () => widget.onSelect?.call(term),
                      );
                    }).toList(),
                  );
                },
                orElse: () => const SizedBox(),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}