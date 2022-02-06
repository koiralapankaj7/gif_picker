import 'package:flutter/material.dart';

///
class SuggestionChip extends StatelessWidget {
  ///
  const SuggestionChip({
    Key? key,
    required this.label,
    this.color,
    this.onPressed,
  }) : super(key: key);

  ///
  final String label;

  ///
  final Color? color;

  ///
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      labelPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 2,
      ),
      onPressed: onPressed ?? () {},
      label: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyText1?.copyWith(
              color: Colors.white,
            ),
      ),
    );
  }
}
