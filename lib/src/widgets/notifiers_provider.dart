import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gif_picker/gif_picker.dart';
import 'package:gif_picker/src/setting_page.dart';

///
class Provider extends InheritedWidget {
  /// Creates a widget that associates a notifiers with a subtree.
  const Provider({
    Key? key,
    required this.categoriesController,
    required this.trendingController,
    required this.settingNotifier,
    required this.widgetNotifier,
    required Widget child,
  }) : super(key: key, child: child);

  /// Categories controller
  final GifController<TenorCategories> categoriesController;

  /// Trending controller
  final GifController<TenorCollection> trendingController;

  /// Setting notifier
  final ValueNotifier<TenorSetting> settingNotifier;

  /// Widget notifier
  final ValueNotifier<Widget?> widgetNotifier;

  /// Returns the [SlideController] most closely associated with the given
  /// context.
  ///
  /// Returns null if there is no [SlideController] associated with the
  /// given context.
  static Provider? of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<Provider>();
    return result;
  }

  @override
  bool updateShouldNotify(covariant Provider oldWidget) =>
      categoriesController != oldWidget.categoriesController ||
      trendingController != oldWidget.trendingController ||
      settingNotifier != oldWidget.settingNotifier ||
      widgetNotifier != oldWidget.widgetNotifier;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Provider>(
        'provider',
        this,
        ifNull: 'no controller',
        showName: false,
      ),
    );
  }
}

///
extension ProviderX on BuildContext {
  /// [Provider] instance
  Provider? get provider => Provider.of(this);
}
