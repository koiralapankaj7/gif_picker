import 'dart:async';

import 'package:flutter/material.dart';

///
class SearchBar extends StatefulWidget {
  ///
  const SearchBar({
    Key? key,
    this.onChanged,
  }) : super(key: key);

  ///
  final ValueChanged<String>? onChanged;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
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
        onChanged: _onChnaged,
      ),
    );
  }
}
