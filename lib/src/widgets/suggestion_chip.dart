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
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
