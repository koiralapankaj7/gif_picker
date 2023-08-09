import 'package:flutter/material.dart';

///
class SuggestionChip extends StatelessWidget {
  ///
  const SuggestionChip({
    required this.label,
    super.key,
    this.color,
    this.onPressed,
  });

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
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white,
            ),
      ),
    );
  }
}
