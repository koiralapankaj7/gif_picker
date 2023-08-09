import 'package:flutter/material.dart';
import 'package:gif_picker/gif_picker.dart';
import 'package:gif_picker/src/setting_page.dart';
import 'package:gif_picker/src/widgets/widgets.dart';

const _termSearchMessage = 'Enter a search term above and find the '
    'perfect GIF to express hou you really feel.';

const _suggestionTermsMessage =
    'Your perfect GIF is in another castle. Try the suggested keywords below!';

///
class SuggestionsView extends StatefulWidget {
  ///
  const SuggestionsView({
    required this.settingNotifier,
    super.key,
    this.suggestionFor,
    this.onSelect,
  });

  ///
  final String? suggestionFor;

  ///
  final ValueSetter<String>? onSelect;

  ///
  final ValueNotifier<TenorSetting> settingNotifier;

  @override
  State createState() => _SuggestionsViewState();
}

class _SuggestionsViewState extends State<SuggestionsView>
    with AutomaticKeepAliveClientMixin {
  late final GifController<TenorTerms> _controller;

  @override
  void initState() {
    super.initState();
    _controller = GifController<TenorTerms>();
    if (widget.suggestionFor == null) {
      _controller.fetchTrendingSearchTerms(
        widget.settingNotifier.value.tenorQuery.copyWith(limit: 7),
      );
    } else if (widget.suggestionFor != null) {
      _controller.fetchSuggestions(
        widget.settingNotifier.value.tenorSuggestionsQuery.copyWith(
          limit: 7,
          query: widget.suggestionFor,
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
    super.build(context);

    final isSuggestion = widget.suggestionFor != null;

    return Center(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            if (!isSuggestion)
              const CircleAvatar(
                child: Icon(Icons.search, size: 20),
              ),
            const SizedBox(height: 24),
            Text(
              widget.suggestionFor == null
                  ? _termSearchMessage
                  : _suggestionTermsMessage,
              style: Theme.of(context).textTheme.bodyMedium,
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
                      alignment: WrapAlignment.center,
                      children: s.data.results.map((term) {
                        return RawChip(
                          label: Text(term),
                          onPressed: () => widget.onSelect?.call(term),
                          visualDensity: VisualDensity.compact,
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
