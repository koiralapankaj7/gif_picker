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
  const factory BaseState.success(
    T data, {
    Json? extra,
    GifPickerError? error,
  }) = SuccessState;
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
  const SuccessState(this.data, {Json? extra, this.error})
      : extra = extra ?? const <String, dynamic>{};

  ///
  final T data;

  /// If error occurs during pagination or pull to refresh
  final GifPickerError? error;

  ///
  final Json extra;

  ///
  SuccessState<T> copyWith({
    T? data,
    Json? extra,
    GifPickerError? error,
  }) =>
      SuccessState<T>(
        data ?? this.data,
        extra: extra ?? this.extra,
        error: error ?? this.error,
      );

  ///
  @override
  String toString() =>
      'SuccessState(data: $data, extra: $extra, error: $error)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SuccessState<T> &&
        other.data == data &&
        other.extra == extra &&
        other.error == error;
  }

  @override
  int get hashCode => data.hashCode ^ extra.hashCode ^ error.hashCode;
}

///
extension BaseStateX<T> on BaseState<T> {
  ///
  /// The [when] method is the equivalent to pattern matching.
  /// Its prototype depends on the [BaseState] defined.
  A when<A>({
    required A Function(InitialState<T> state) initial,
    required A Function(LoadingState<T> state) loading,
    required A Function(SuccessState<T> state) success,
    required A Function(ErrorState<T> state) error,
  }) {
    if (this is InitialState<T>) {
      return initial(this as InitialState<T>);
    } else if (this is LoadingState<T>) {
      return loading(this as LoadingState<T>);
    } else if (this is ErrorState<T>) {
      return error(this as ErrorState<T>);
    } else {
      return success(this as SuccessState<T>);
    }
  }

  ///
  /// Similar to [when] but with optional parameters
  A maybeMap<A>({
    A Function(InitialState<T> state)? initial,
    A Function(LoadingState<T> state)? loading,
    A Function(SuccessState<T> state)? success,
    A Function(ErrorState<T> state)? error,
    required A Function() orElse,
  }) {
    if (this is InitialState<T> && initial != null) {
      return initial(this as InitialState<T>);
    } else if (this is LoadingState<T> && loading != null) {
      return loading(this as LoadingState<T>);
    } else if (this is ErrorState<T> && error != null) {
      return error(this as ErrorState<T>);
    } else if (this is SuccessState<T> && success != null) {
      return success(this as SuccessState<T>);
    } else {
      return orElse();
    }
  }
}
