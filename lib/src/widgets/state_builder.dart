import 'package:flutter/material.dart';
import 'package:gif_picker/gif_picker.dart';

///
class StateBuilder<T> extends StatelessWidget {
  ///
  const StateBuilder({
    required this.notifier,
    required this.builder,
    super.key,
    this.child,
  });

  ///
  final ValueNotifier<BaseState<T>> notifier;

  ///
  final Widget Function(BuildContext context, BaseState<T> state, Widget? child)
      builder;

  ///
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<BaseState<T>>(
      valueListenable: notifier,
      builder: builder,
      child: child,
    );
  }
}
