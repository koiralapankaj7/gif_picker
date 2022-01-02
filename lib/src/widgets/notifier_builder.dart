import 'package:flutter/material.dart';

///
class NotifierBuilder<T> extends StatelessWidget {
  ///
  const NotifierBuilder({
    Key? key,
    required this.notifier,
    required this.builder,
    this.child,
  }) : super(key: key);

  ///
  final ValueNotifier<T> notifier;

  ///
  final Widget Function(BuildContext context, T value, Widget? child) builder;

  ///
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: notifier,
      builder: builder,
      child: child,
    );
  }
}
