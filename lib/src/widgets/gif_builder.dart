import 'package:flutter/material.dart';

///
class GifBuilder extends StatefulWidget {
  ///
  const GifBuilder({
    Key? key,
    this.url,
    this.emojiCharacter,
    this.height,
    this.width,
    this.color,
    this.onTap,
    this.borderRadius = 6,
  }) : super(key: key);

  ///
  final double? width;

  ///
  final double? height;

  ///
  final String? url;

  ///
  final String? emojiCharacter;

  ///
  final Color? color;

  ///
  final double borderRadius;

  ///
  final VoidCallback? onTap;

  @override
  State<GifBuilder> createState() => _GifBuilderState();
}

class _GifBuilderState extends State<GifBuilder> {
  var _margin = 0.0;

  void _setMargin(double margin) {
    setState(() {
      _margin = margin;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget child = const SizedBox();

    if (widget.url?.isNotEmpty ?? false) {
      child = Image.network(
        widget.url!,
        fit: BoxFit.cover,
        height: widget.height,
        width: widget.width,
        frameBuilder: (
          BuildContext context,
          Widget c,
          int? frame,
          bool wasSynchronouslyLoaded,
        ) {
          final crossFadeState = frame == null
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond;

          return AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: crossFadeState,
            firstChild: SizedBox(
              height: widget.height,
              width: widget.width,
              child: ColoredBox(color: scheme.background),
            ),
            secondChild: InkWell(
              onTap: widget.onTap,
              onTapDown: (_) => _setMargin(4),
              // onTapUp: (_) => _setMargin(0),
              onTapCancel: () => _setMargin(0),
              child: c,
            ),
          );
        },
      );
    } else if (widget.emojiCharacter?.isNotEmpty ?? false) {
      child = InkWell(
        onTap: widget.onTap,
        onTapDown: (_) => _setMargin(4),
        // onTapUp: (_) => _setMargin(0),
        onTapCancel: () => _setMargin(0),
        child: Container(
          color: scheme.background,
          padding: const EdgeInsets.all(16),
          child: FittedBox(child: Text(widget.emojiCharacter!)),
        ),
      );
    }

    return MouseRegion(
      onEnter: (event) => _setMargin(4),
      onExit: (event) => _setMargin(0),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: widget.width,
        height: widget.height,
        padding: EdgeInsets.all(_margin),
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Container(
            foregroundDecoration: widget.color != null
                ? BoxDecoration(color: widget.color)
                : null,
            child: child,
            // child: SizedBox.expand(child: child),
          ),
        ),
      ),
    );
  }
}

///
class GifShimmer extends StatelessWidget {
  ///
  const GifShimmer({
    Key? key,
    this.height,
    this.width,
    this.color,
  }) : super(key: key);

  ///
  final double? width;

  ///
  final double? height;

  ///
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: scheme.background,
      ),
      foregroundDecoration: color != null
          ? BoxDecoration(borderRadius: BorderRadius.circular(8), color: color)
          : null,
    );
  }
}
