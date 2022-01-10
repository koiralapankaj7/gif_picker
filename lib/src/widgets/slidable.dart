import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

/// State of the slide
enum SlideState {
  /// slide is currently sliding up
  slidingUp,

  /// slide is currently sliding down
  slidingDown,

  /// slide is at its max size
  max,

  /// slide is at its min size
  min,

  /// slide is closed
  close,
}

///
/// Settings for slidable view
@immutable
class SlideSetting {
  /// {@macro slide setting}
  const SlideSetting({
    this.maxHeight,
    this.thumbHandlerSize = 25.0,
    this.snapingPoint = 0.4,
    this.headerBackground = Colors.black,
    this.foregroundColor = Colors.black,
    this.backgroundColor = Colors.black,
  }) : assert(
          snapingPoint >= 0.0 && snapingPoint <= 1.0,
          '[snapingPoint] value must be between 1.0 and 0.0',
        );

  /// slide maximum height
  ///
  /// mediaQuery = MediaQuery.of(context)
  /// Default: mediaQuery.size.height -  mediaQuery.padding.top
  final double? maxHeight;

  /// Slide thumb handler height, [thumbHandlerSize] from the top of the slide
  /// will be used to activate thumb gesture.
  ///
  /// Default: 25.0 px
  final double thumbHandlerSize;

  ///
  /// Minimize position of the slide
  /// Value must be between 0.0 - 1.0
  /// Default: 0.4
  final double snapingPoint;

  /// Background color for slide header,
  /// Default: [Colors.black]
  final Color headerBackground;

  /// Background color for slide,
  /// Default: [Colors.black]
  final Color foregroundColor;

  /// If [headerBackground] is missing [backgroundColor] will be applied
  /// If [foregroundColor] is missing [backgroundColor] will be applied
  ///
  /// Default: [Colors.black]
  final Color backgroundColor;

  /// Helper function
  SlideSetting copyWith({
    double? maxHeight,
    double? minHeight,
    double? headerHeight,
    double? thumbHandlerSize,
    double? snapingPoint,
    Color? headerBackground,
    Color? foregroundColor,
    Color? backgroundColor,
    SystemUiOverlayStyle? overlayStyle,
  }) {
    return SlideSetting(
      maxHeight: maxHeight ?? this.maxHeight,
      thumbHandlerSize: thumbHandlerSize ?? this.thumbHandlerSize,
      snapingPoint: snapingPoint ?? this.snapingPoint,
      headerBackground: headerBackground ?? this.headerBackground,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  String toString() {
    return '''
    slideSetting(
      maxHeight: $maxHeight, 
      thumbHandlerHeight: $thumbHandlerSize, 
      snapingPoint: $snapingPoint, 
      headerBackground: $headerBackground, 
      foregroundColor: $foregroundColor, 
      backgroundColor: $backgroundColor
    )''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SlideSetting &&
        other.maxHeight == maxHeight &&
        other.thumbHandlerSize == thumbHandlerSize &&
        other.snapingPoint == snapingPoint &&
        other.headerBackground == headerBackground &&
        other.foregroundColor == foregroundColor &&
        other.backgroundColor == backgroundColor;
  }

  @override
  int get hashCode {
    return maxHeight.hashCode ^
        thumbHandlerSize.hashCode ^
        snapingPoint.hashCode ^
        headerBackground.hashCode ^
        foregroundColor.hashCode ^
        backgroundColor.hashCode;
  }
}

///
class Slidable extends StatefulWidget {
  ///
  const Slidable({
    Key? key,
    this.controller,
    this.setting,
    required this.builder,
  }) : super(key: key);

  ///
  final SlideSetting? setting;

  ///
  final SlideController? controller;

  ///
  final Widget Function(BuildContext context, SlideSetting setting) builder;

  @override
  State<Slidable> createState() => _SlidableState();
}

class _SlidableState extends State<Slidable> with TickerProviderStateMixin {
  late double _slideMinHeight;
  late double _slideMaxHeight;
  late Size _size;
  late SlideSetting _setting;

  //
  late SlideController _slideController;

  // Scroll controller
  late ScrollController _scrollController;

  // Animation controller
  late AnimationController _animationController;

  // Tracking pointer velocity for snaping slide
  VelocityTracker? _velocityTracker;

  // Initial position of pointer
  var _pointerInitialPosition = Offset.zero;

  // true, if can slide to bottom
  var _scrollToBottom = false;

  // true, if can slide to top
  var _scrollToTop = false;

  // Initial position of pointer before sliding to min height.
  var _pointerPositionBeforeScroll = Offset.zero;

  // true, if pointer is above halfway of the screen, false otherwise.
  bool get _aboveHalfWay =>
      _slideController.value.factor > _setting.snapingPoint + 0.15;

  @override
  void initState() {
    super.initState();
    _setting = widget.setting ?? const SlideSetting();
    // Initialization of slide controller
    _slideController = (widget.controller ?? SlideController()).._init(this);
    _scrollController = _slideController.scrollController
      ..addListener(() {
        if ((_scrollToTop || _scrollToBottom) && _scrollController.hasClients) {
          _scrollController.position.hold(() {});
        }
      });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addListener(() {
        final source = _animationController.value.toStringAsFixed(2);
        final factor = double.parse(source);
        _slideController.attach(
          SlideValue(factor: factor, state: _getState(factor)),
        );
      });
  }

  SlideState _getState(double factor) {
    if (factor == 0.0) return SlideState.close;
    if (factor == _setting.snapingPoint) return SlideState.min;
    if (factor == 1.0) return SlideState.max;
    return _aboveHalfWay ? SlideState.slidingUp : SlideState.slidingDown;
  }

  void _onPointerDown(PointerDownEvent event) {
    _pointerInitialPosition = event.position;
    _velocityTracker ??= VelocityTracker.withKind(event.kind);
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!_slideController.isGestureEnabled) return;

    if (_animationController.isAnimating) return;

    if (!_shouldScroll(event.position.dy)) return;

    _velocityTracker!.addPosition(event.timeStamp, event.position);

    final state = _pointerInitialPosition.dy - event.position.dy < 0.0
        ? SlideState.slidingDown
        : SlideState.slidingUp;
    final slideState = _slideController.value.state;
    final mediaQuery = MediaQuery.of(context);

    if (!_scrollToTop &&
        slideState == SlideState.min &&
        state == SlideState.slidingUp) {
      final pointerReachedHandler =
          (mediaQuery.size.height - event.position.dy) >
              _slideMinHeight - _setting.thumbHandlerSize;
      _scrollToTop = pointerReachedHandler;
    }

    if (!_scrollToBottom &&
        slideState == SlideState.max &&
        state == SlideState.slidingDown) {
      final isControllerOffsetZero =
          _scrollController.hasClients && _scrollController.offset == 0.0;
      final headerMinPosition = _size.height - _slideMaxHeight;
      final headerMaxPosition = headerMinPosition + _setting.thumbHandlerSize;
      final isHandler = event.position.dy >= headerMinPosition &&
          event.position.dy <= headerMaxPosition;
      _scrollToBottom = isHandler || isControllerOffsetZero;
      if (_scrollToBottom) {
        _pointerPositionBeforeScroll = event.position;
      }
    }

    if (_scrollToTop || _scrollToBottom) {
      final startingPX = event.position.dy -
          _pointerPositionBeforeScroll.dy -
          (_setting.thumbHandlerSize * 2);
      final f = 1 - (startingPX / _slideMaxHeight);
      final factor = f.clamp(0.0, 1.0).toStringAsFixed(5);
      _slideController.attach(
        SlideValue(factor: double.parse(factor), state: state),
      );
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    if (!_slideController.isGestureEnabled) return;

    if (_animationController.isAnimating) return;

    if (!_shouldScroll(event.position.dy)) return;

    final velocity = _velocityTracker!.getVelocity();

    if (_scrollToTop || _scrollToBottom) {
      // +ve velocity -> top to bottom
      // -ve velocity -> bottom to top
      final dyVelocity = velocity.pixelsPerSecond.dy;
      final flingslide = dyVelocity.abs() > 800.0;
      final endValue = flingslide
          ? (dyVelocity.isNegative ? 1.0 : _setting.snapingPoint)
          : (_aboveHalfWay ? 1.0 : _setting.snapingPoint);
      _snapToPosition(endValue: endValue);
    }

    _scrollToTop = false;
    _scrollToBottom = false;
    _pointerInitialPosition = Offset.zero;
    _pointerPositionBeforeScroll = Offset.zero;
    _velocityTracker = null;
  }

  // If pointer is moved by more than 2 px then only begain
  bool _shouldScroll(double currentDY) {
    return (currentDY.abs() - _pointerInitialPosition.dy.abs()).abs() > 2.0;
  }

  void _snapToPosition({required double endValue, double? startValue}) {
    final Simulation simulation = SpringSimulation(
      SpringDescription.withDampingRatio(
        mass: 1,
        stiffness: 600,
        ratio: 1.1,
      ),
      startValue ?? _slideController.value.factor,
      endValue,
      0,
    );
    _animationController.animateWith(simulation);
  }

  @override
  Widget build(BuildContext context) {
    return SlideControllerProvider(
      controller: _slideController,
      child: ValueListenableBuilder<bool>(
        valueListenable: _slideController._slideVisibility,
        builder: (context, visible, child) =>
            visible ? child! : widget.builder(context, _setting),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final mediaQuery = MediaQuery.of(context);

            _size = constraints.biggest;
            _slideMaxHeight =
                _setting.maxHeight ?? _size.height - mediaQuery.padding.top;
            _slideMinHeight = _slideMaxHeight * _setting.snapingPoint;

            return Stack(
              fit: StackFit.expand,
              children: [
                // Parent view
                Column(
                  children: [
                    //
                    Expanded(child: widget.builder(context, _setting)),

                    // Space for panel min height
                    ValueListenableBuilder<bool>(
                      valueListenable: _slideController._slideVisibility,
                      builder: (context, isVisible, child) {
                        return Container(
                          height: isVisible ? _slideMinHeight : 0.0,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        );
                      },
                    ),

                    //
                  ],
                ),

                // Sliding view
                ValueListenableBuilder<bool>(
                  valueListenable: _slideController._slideVisibility,
                  builder: (context, bool isVisible, child) {
                    return isVisible ? child! : const SizedBox();
                  },
                  child: Builder(
                    builder: (context) {
                      return Column(
                        children: [
                          // Space between slide and status bar
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                final focusNode = FocusScope.of(context);
                                if (focusNode.hasFocus) {
                                  focusNode.unfocus();
                                }
                                if (_slideController.isVisible) {
                                  _slideController.close();
                                }
                              },
                              child: Container(),
                            ),
                          ),

                          // Sliding slide
                          ValueListenableBuilder(
                            valueListenable: _slideController,
                            // builder: (context, SlideValue value, child) {
                            // return SizedBox(
                            //   height: _slideMaxHeight,
                            //   child: Transform.translate(
                            //     offset: Offset(
                            //       0,
                            //       _slideMaxHeight * (1 - value.factor),
                            //     ),
                            //     child: child,
                            //   ),
                            // );
                            // },
                            builder: (context, SlideValue value, child) {
                              final height = (_slideMaxHeight * value.factor)
                                  .clamp(_slideMinHeight, _slideMaxHeight);
                              return SizedBox(height: height, child: child);
                            },
                            child: Listener(
                              onPointerDown: _onPointerDown,
                              onPointerMove: _onPointerMove,
                              onPointerUp: _onPointerUp,
                              child: _slideController._attachedView ??
                                  const SizedBox(),
                            ),
                          ),

                          ///
                        ],
                      );
                    },
                  ),
                ),

                //
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (widget.controller == null) {
      _slideController.dispose();
    }
    super.dispose();
  }
  //
}

/// Sliding slide controller
class SlideController extends ValueNotifier<SlideValue> {
  ///
  SlideController({
    ScrollController? scrollController,
  })  : _scrollController = scrollController ?? ScrollController(),
        _slideVisibility = ValueNotifier(false),
        super(const SlideValue());

  final ScrollController _scrollController;
  final ValueNotifier<bool> _slideVisibility;
  Completer? _completer;
  Widget? _attachedView;

  late _SlidableState _state;
  late SlideSetting _setting;

  // ignore: use_setters_to_change_properties
  void _init(_SlidableState state) {
    _state = state;
    _setting = state._setting;
  }

  bool _gesture = true;
  bool _internal = true;

  ///
  ScrollController get scrollController => _scrollController;

  ///
  ValueNotifier<bool> get slideVisibility => _slideVisibility;

  /// Current state of the pannel
  SlideState get slideState => value.state;

  /// If slide is open return true, otherwise false
  bool get isVisible => _slideVisibility.value;

  /// Gestaure status
  bool get isGestureEnabled => _gesture;

  Type? _type;

  ///
  Future<T?> attachView<T>(Widget view) async {
    _type = T;
    _completer = Completer<T?>();
    _attachedView = view;
    open();
    return (_completer as Completer<T?>?)!.future;
  }

  /// Change gesture status
  set isGestureEnabled(bool isEnable) {
    if (isGestureEnabled && isEnable) return;
    _gesture = isEnable;
  }

  ///
  /// Open slide to the viewport
  ///
  void open() {
    if (value.state != SlideState.close) return;
    _internal = true;
    _slideVisibility.value = true;
    _gesture = true;
    _state._snapToPosition(startValue: 0, endValue: _setting.snapingPoint);
  }

  ///
  /// Maximize slide to its full size
  ///
  void maximize() {
    if (value.state == SlideState.max) return;
    _state._snapToPosition(endValue: 1);
  }

  /// Minimize slide to its minimum size
  void minimize() {
    if (value.state == SlideState.min) return;
    _state._snapToPosition(endValue: _setting.snapingPoint);
  }

  ///
  /// Close slide from viewport
  ///
  void close({Object? result}) {
    if (!isVisible || value.state == SlideState.close) return;
    _state._snapToPosition(endValue: 0);
    _slideVisibility.value = false;
    _gesture = false;
    _completer?.complete(result.runtimeType != _type ? null : result);
  }

  ///
  @internal
  void attach(SlideValue sliderValue) {
    _internal = true;
    value = value.copyWith(
      factor: sliderValue.factor,
      offset: sliderValue.offset,
      position: sliderValue.position,
      state: sliderValue.state,
    );
  }

  @override
  set value(SlideValue newValue) {
    if (!_internal) return;
    super.value = newValue;
    _internal = false;
  }

  @override
  void dispose() {
    _slideVisibility.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  //
}

///
@immutable
class SlideValue {
  ///
  const SlideValue({
    this.state = SlideState.close,
    this.factor = 0.0,
    this.offset = 0.0,
    this.position = Offset.zero,
  });

  /// Sliding state
  final SlideState state;

  /// From 0.0 - 1.0
  final double factor;

  /// Height of the slide
  final double offset;

  /// Position of the slide
  final Offset position;

  ///
  SlideValue copyWith({
    SlideState? state,
    double? factor,
    double? offset,
    Offset? position,
  }) {
    return SlideValue(
      state: state ?? this.state,
      factor: factor ?? this.factor,
      offset: offset ?? this.offset,
      position: position ?? this.position,
    );
  }

  @override
  String toString() {
    return '''SlideValue(state: $state, factor: $factor, offset: $offset,position: $position)''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SlideValue &&
        other.state == state &&
        other.factor == factor &&
        other.offset == offset &&
        other.position == position;
  }

  @override
  int get hashCode {
    return state.hashCode ^
        factor.hashCode ^
        offset.hashCode ^
        position.hashCode;
  }
}

///
class SlideControllerProvider extends InheritedWidget {
  /// Creates a widget that associates a [SlideController] with a subtree.
  const SlideControllerProvider({
    Key? key,
    required SlideController this.controller,
    required Widget child,
  }) : super(key: key, child: child);

  /// Creates a subtree without an associated [SlideController].
  const SlideControllerProvider.none({
    Key? key,
    required Widget child,
  })  : controller = null,
        super(key: key, child: child);

  /// The [SlideController] associated with the subtree.
  ///
  final SlideController? controller;

  /// Returns the [SlideController] most closely associated with the given
  /// context.
  ///
  /// Returns null if there is no [SlideController] associated with the
  /// given context.
  static SlideController? of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<SlideControllerProvider>();
    return result?.controller;
  }

  @override
  bool updateShouldNotify(covariant SlideControllerProvider oldWidget) =>
      controller != oldWidget.controller;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<SlideController>(
        'controller',
        controller,
        ifNull: 'no controller',
        showName: false,
      ),
    );
  }
}

///
extension SlidControllerX on BuildContext {
  /// [SlideController] instance
  SlideController? get slideController => SlideControllerProvider.of(this);
}
