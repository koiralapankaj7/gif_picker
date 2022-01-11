import 'package:flutter/widgets.dart';
import 'package:gif_picker/src/widgets/widgets.dart';

/// Represents the layout size passed to [ResponsiveLayoutBuilder.child].
enum ResponsiveLayoutSize {
  /// Small layout
  small,

  /// Medium layout
  medium,

  /// Large layout
  large,

  /// Extra Large layout
  xLarge
}

/// Signature for the individual builders (`small`, `medium`, `large`).
typedef ResponsiveLayoutWidgetBuilder = Widget Function(BuildContext, Widget?);

/// {@template responsive_layout_builder}
/// A wrapper around [LayoutBuilder] which exposes builders for
/// various responsive breakpoints.
/// {@endtemplate}
class ResponsiveLayoutBuilder extends StatelessWidget {
  /// {@macro responsive_layout_builder}
  const ResponsiveLayoutBuilder({
    Key? key,
    this.small,
    this.medium,
    this.large,
    this.xLarge,
    this.child,
  }) : super(key: key);

  /// [ResponsiveLayoutWidgetBuilder] for small layout.
  final ResponsiveLayoutWidgetBuilder? small;

  /// [ResponsiveLayoutWidgetBuilder] for medium layout.
  final ResponsiveLayoutWidgetBuilder? medium;

  /// [ResponsiveLayoutWidgetBuilder] for large layout.
  final ResponsiveLayoutWidgetBuilder? large;

  /// [ResponsiveLayoutWidgetBuilder] for large layout.
  final ResponsiveLayoutWidgetBuilder? xLarge;

  /// Optional child widget builder based on the current layout size
  /// which will be passed to the `small`, `medium` and `large` builders
  /// as a way to share/optimize shared layout.
  final Widget Function(ResponsiveLayoutSize currentSize)? child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.biggest.width;

        if (screenWidth <= Breakpoints.small) {
          final childView = child?.call(ResponsiveLayoutSize.small);
          return small?.call(context, childView) ??
              childView ??
              const SizedBox();
        }
        if (screenWidth <= Breakpoints.medium) {
          final childView = child?.call(ResponsiveLayoutSize.medium);
          return medium?.call(context, childView) ??
              childView ??
              const SizedBox();
        }
        if (screenWidth <= Breakpoints.large) {
          final childView = child?.call(ResponsiveLayoutSize.large);
          return large?.call(context, childView) ??
              childView ??
              const SizedBox();
        }

        if (screenWidth <= Breakpoints.xLarge) {
          final childView = child?.call(ResponsiveLayoutSize.xLarge);
          return xLarge?.call(context, childView) ??
              childView ??
              const SizedBox();
        }

        final childView = child?.call(ResponsiveLayoutSize.xLarge);
        return xLarge?.call(context, childView) ??
            childView ??
            const SizedBox();
      },
    );
  }
}

///
extension ResponsiveLayoutSizeX on ResponsiveLayoutSize {
  ///
  int get gridCrossAxisCount {
    switch (this) {
      case ResponsiveLayoutSize.small:
        return 2;
      case ResponsiveLayoutSize.medium:
        return 3;
      case ResponsiveLayoutSize.large:
        return 5;
      case ResponsiveLayoutSize.xLarge:
        return 7;
    }
  }
}
