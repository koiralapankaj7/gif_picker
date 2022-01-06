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
    this.colorBlendMode,
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
  final BlendMode? colorBlendMode;

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
    Widget child = const SizedBox();

    if (widget.url?.isNotEmpty ?? false) {
      child = Image.network(
        widget.url!,
        fit: BoxFit.cover,
        height: widget.height,
        width: widget.width,
        color: widget.color,
        colorBlendMode: widget.colorBlendMode,
        frameBuilder: (
          BuildContext context,
          Widget child,
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
              child: const ColoredBox(color: Colors.grey),
            ),
            secondChild: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: widget.onTap,
              onTapDown: (_) => _setMargin(8),
              onTapUp: (_) => _setMargin(0),
              onTapCancel: () => _setMargin(0),
              child: child,
            ),
          );
        },
      );
    } else if (widget.emojiCharacter?.isNotEmpty ?? false) {
      child = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.onTap,
        onTapDown: (_) => _setMargin(8),
        onTapUp: (_) => _setMargin(0),
        onTapCancel: () => _setMargin(0),
        child: Container(
          color: Colors.grey.shade400,
          foregroundDecoration: const BoxDecoration(color: Colors.black38),
          padding: const EdgeInsets.all(8),
          child: FittedBox(
            child: Text(
              widget.emojiCharacter!,
              style: const TextStyle(fontSize: 100),
            ),
          ),
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: widget.width,
      height: widget.height,
      padding: EdgeInsets.all(_margin),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: child,
      ),
    );
  }
}

///
class GifShimmer extends StatelessWidget {
  ///
  const GifShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade200,
      ),
    );
  }
}
