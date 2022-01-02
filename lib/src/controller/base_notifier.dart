import 'package:flutter/material.dart';
import 'package:gif_picker/gif_picker.dart';

/// BaseNotifier will handle unwanted value changes
abstract class BaseNotifier<T> extends ValueNotifier<BaseState<T>> {
  ///
  BaseNotifier({BaseState<T> state = const BaseState.initial()}) : super(state);

  @override
  set value(BaseState<T> value) {
    // TODO(koiralapankaj007): cancle token handlation
    // if (state is ErrorState<T> &&
    //     (state.failure.type == FailureType.cancel ||
    //         value.failure.code == 401)) {
    //   return;
    // }
    super.value = value;
  }
}
