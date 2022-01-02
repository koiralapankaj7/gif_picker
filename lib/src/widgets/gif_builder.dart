import 'package:flutter/material.dart';

///
class GifBuilder extends StatefulWidget {
  ///
  const GifBuilder({
    Key? key,
    required this.url,
    this.height,
    this.width,
    this.color,
    this.colorBlendMode,
    this.onTap,
    this.onTapUp,
    this.borderRadius = 6,
  }) : super(key: key);

  ///
  final double? width;

  ///
  final double? height;

  ///
  final String url;

  ///
  final Color? color;

  ///
  final BlendMode? colorBlendMode;

  ///
  final double borderRadius;

  ///
  final VoidCallback? onTap;

  ///
  final VoidCallback? onTapUp;

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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: widget.width,
      height: widget.height,
      padding: EdgeInsets.all(_margin),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Image.network(
          widget.url,
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
        ),
      ),
    );
  }
}
