import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gif_picker/src/search_page.dart';

///
class SearchBar extends StatelessWidget {
  ///
  SearchBar.main({
    Key? key,
    ValueSetter<String>? onSubmit,
    ValueChanged<String>? onChanged,
    TextEditingController? controller,
  })  : child = _SearchBar(
          onSubmit: onSubmit,
          onChanged: onChanged,
          controller: controller,
        ),
        super(key: key);

  ///
  const SearchBar.dummy({Key? key})
      : child = const _DummySearchBar(),
        super(key: key);

  ///
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

///
class _SearchBar extends StatefulWidget {
  ///
  const _SearchBar({
    Key? key,
    this.onSubmit,
    this.onChanged,
    this.controller,
  }) : super(key: key);

  ///
  final ValueChanged<String>? onChanged;

  ///
  final ValueSetter<String>? onSubmit;

  ///
  final TextEditingController? controller;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = widget.controller ?? TextEditingController();
  }

  Timer? _debounce;

  void _onChnaged(String text) {
    if (widget.onChanged == null) return;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () {
      widget.onChanged!(text);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          const Icon(CupertinoIcons.chevron_left, color: Colors.black),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              style: Theme.of(context).textTheme.subtitle1,
              controller: widget.controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: Theme.of(context).textTheme.subtitle1?.copyWith(
                      color: Colors.black54,
                    ),
                border: InputBorder.none,
                isDense: true,
              ),
              onChanged: _onChnaged,
              onSubmitted: widget.onSubmit,
            ),
          ),
          const SizedBox(width: 8),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, child) {
              return InkWell(
                onTap: () {
                  if (value.text.isNotEmpty) {
                    _controller.clear();
                  }
                },
                child: Icon(
                  value.text.isEmpty
                      ? CupertinoIcons.search
                      : CupertinoIcons.clear_circled,
                  color: Colors.black,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DummySearchBar extends StatelessWidget {
  const _DummySearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push<void>(
          MaterialPageRoute(
            builder: (context) => const SearchPage(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Text(' Search', style: Theme.of(context).textTheme.subtitle1),
            const Spacer(),
            const Icon(Icons.search, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}

///
class AutoComplete extends StatefulWidget {
  ///
  const AutoComplete({
    Key? key,
    required this.query,
  }) : super(key: key);

  ///
  final String query;

  @override
  State createState() => _AutoCompleteState();
}

class _AutoCompleteState extends State<AutoComplete> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.all(12),
            child: const Text('Testing'),
          ),
        ],
      ),
    );
  }
}
