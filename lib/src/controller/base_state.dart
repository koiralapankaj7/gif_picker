import 'package:flutter/material.dart';
import 'package:gif_picker/gif_picker.dart';

///
/// Base state class which handles the states of the app.
abstract class BaseState<T> {
  /// Initial state
  const factory BaseState.initial({Json? extra}) = InitialState;

  /// Loading state
  const factory BaseState.loading({Json? extra}) = LoadingState;

  /// Error state
  const factory BaseState.error(GifPickerError error, {Json? extra}) =
      ErrorState;

  /// Success state
  const factory BaseState.success(T data, {Json? extra}) = SuccessState;
}

///
@immutable
class InitialState<T> implements BaseState<T> {
  ///
  const InitialState({
    Json? extra,
  }) : extra = extra ?? const <String, dynamic>{};

  ///
  final Json extra;

  ///
  InitialState<T> copyWith({Json? extra}) {
    return InitialState<T>(extra: extra ?? this.extra);
  }

  @override
  String toString() => 'InitialState(extra: $extra)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InitialState<T> && other.extra == extra;
  }

  @override
  int get hashCode => extra.hashCode;
}

///
@immutable
class LoadingState<T> implements BaseState<T> {
  ///
  const LoadingState({
    Json? extra,
  }) : extra = extra ?? const <String, dynamic>{};

  ///
  final Json extra;

  ///
  LoadingState<T> copyWith({Json? extra}) {
    return LoadingState<T>(extra: extra ?? this.extra);
  }

  @override
  String toString() => 'LoadingState(extra: $extra)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoadingState<T> && other.extra == extra;
  }

  @override
  int get hashCode => extra.hashCode;
}

///
@immutable
class ErrorState<T> implements BaseState<T> {
  ///
  const ErrorState(this.error, {Json? extra})
      : extra = extra ?? const <String, dynamic>{};

  ///
  final GifPickerError error;

  ///
  final Json extra;

  ///
  ErrorState<T> copyWith({
    GifPickerError? error,
    Json? extra,
  }) {
    return ErrorState<T>(error ?? this.error, extra: extra ?? this.extra);
  }

  @override
  String toString() => 'ErrorState(error: $error, extra: $extra)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ErrorState<T> &&
        other.error == error &&
        other.extra == extra;
  }

  @override
  int get hashCode => error.hashCode ^ extra.hashCode;
}

///
@immutable
class SuccessState<T> implements BaseState<T> {
  ///
  ///
  const SuccessState(this.data, {Json? extra})
      : extra = extra ?? const <String, dynamic>{};

  ///
  final T data;

  ///
  final Json extra;

  ///
  SuccessState<T> copyWith({
    T? data,
    Json? extra,
  }) =>
      SuccessState<T>(data ?? this.data, extra: extra ?? this.extra);

  ///
  @override
  String toString() => 'SuccessState(data: $data, extra: $extra)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SuccessState<T> &&
        other.data == data &&
        other.extra == extra;
  }

  @override
  int get hashCode => data.hashCode ^ extra.hashCode;
}

///
extension BaseStateX on BaseState {
  ///
  /// The [when] method is the equivalent to pattern matching.
  /// Its prototype depends on the [BaseState] defined.
  T when<T>({
    required T Function(InitialState state) initial,
    required T Function(LoadingState state) loading,
    required T Function(SuccessState state) success,
    required T Function(ErrorState state) error,
  }) {
    if (this is InitialState) {
      return initial(this as InitialState);
    } else if (this is LoadingState) {
      return loading(this as LoadingState);
    } else if (this is ErrorState) {
      return error(this as ErrorState);
    } else {
      return success(this as SuccessState);
    }
  }

  ///
  /// Similar to [when] but with optional parameters
  T mayBeMap<T>({
    T Function(InitialState state)? initial,
    T Function(LoadingState state)? loading,
    T Function(SuccessState state)? success,
    T Function(ErrorState state)? error,
    required T Function() orElse,
  }) {
    if (this is InitialState && initial != null) {
      return initial(this as InitialState);
    } else if (this is LoadingState && loading != null) {
      return loading(this as LoadingState);
    } else if (this is ErrorState && error != null) {
      return error(this as ErrorState);
    } else if (this is SuccessState && success != null) {
      return success(this as SuccessState);
    } else {
      return orElse();
    }
  }
}
