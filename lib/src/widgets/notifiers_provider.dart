import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gif_picker/src/setting_page.dart';

///
class Provider extends InheritedWidget {
  /// Creates a widget that associates a notifiers with a subtree.
  const Provider({
    required this.settingNotifier,
    required super.child,
    super.key,
  });

  /// Setting notifier
  final ValueNotifier<TenorSetting> settingNotifier;

  /// Returns the [Provider] most closely associated with the given
  /// context.
  ///
  /// Returns null if there is no [Provider] associated with the
  /// given context.
  static Provider? of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<Provider>();
    return result;
  }

  @override
  bool updateShouldNotify(covariant Provider oldWidget) =>
      settingNotifier != oldWidget.settingNotifier;

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
