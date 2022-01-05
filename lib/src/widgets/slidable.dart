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

  /// slide is in pause state, where gesture will not work
  paused,
}

///
/// Settings for slidable view
@immutable
class SlideSetting {
  /// {@macro slide setting}
  const SlideSetting({
    this.maxHeight,
    this.minHeight,
    this.headerHeight = kToolbarHeight,
    this.thumbHandlerHeight = 25.0,
    this.snapingPoint = 0.4,
    this.headerBackground = Colors.black,
    this.foregroundColor = Colors.black,
    this.backgroundColor = Colors.black,
    this.overlayStyle = SystemUiOverlayStyle.light,
  }) : assert(
          snapingPoint >= 0.0 && snapingPoint <= 1.0,
          '[snapingPoint] value must be between 1.0 and 0.0',
        );

  /// Margin for slide top. Which can be used to show status bar if you need
  /// to show slide above scaffold.
  // final double? topMargin;

  /// slide maximum height
  ///
  /// mediaQuery = MediaQuery.of(context)
  /// Default: mediaQuery.size.height -  mediaQuery.padding.top
  final double? maxHeight;

  /// slide minimum height
  /// Default: 37% of [maxHeight]
  final double? minHeight;

  /// slide header height
  ///
  /// Default:  [kToolbarHeight]
  final double headerHeight;

  /// slide thumb handler height, which will be used to drag the slide
  ///
  /// Default: 25.0 px
  final double thumbHandlerHeight;

  /// Point from where slide will start fling animation to snap it's height
  /// to [minHeight] or [maxHeight]
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

  ///
  final SystemUiOverlayStyle overlayStyle;

  /// Header max height
  double get headerMaxHeight => thumbHandlerHeight + headerHeight;

  /// Helper function
  SlideSetting copyWith({
    double? maxHeight,
    double? minHeight,
    double? headerHeight,
    double? thumbHandlerHeight,
    double? snapingPoint,
    Color? headerBackground,
    Color? foregroundColor,
    Color? backgroundColor,
    SystemUiOverlayStyle? overlayStyle,
  }) {
    return SlideSetting(
      maxHeight: maxHeight ?? this.maxHeight,
      minHeight: minHeight ?? this.minHeight,
      headerHeight: headerHeight ?? this.headerHeight,
      thumbHandlerHeight: thumbHandlerHeight ?? this.thumbHandlerHeight,
      snapingPoint: snapingPoint ?? this.snapingPoint,
      headerBackground: headerBackground ?? this.headerBackground,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      overlayStyle: overlayStyle ?? this.overlayStyle,
    );
  }

  @override
  String toString() {
    return '''
    slideSetting(
      maxHeight: $maxHeight, 
      minHeight: $minHeight, 
      headerHeight: $headerHeight, 
      thumbHandlerHeight: $thumbHandlerHeight, 
      snapingPoint: $snapingPoint, 
      headerBackground: $headerBackground, 
      foregroundColor: $foregroundColor, 
      backgroundColor: $backgroundColor, 
      overlayStyle: $overlayStyle
    )''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SlideSetting &&
        other.maxHeight == maxHeight &&
        other.minHeight == minHeight &&
        other.headerHeight == headerHeight &&
        other.thumbHandlerHeight == thumbHandlerHeight &&
        other.snapingPoint == snapingPoint &&
        other.headerBackground == headerBackground &&
        other.foregroundColor == foregroundColor &&
        other.backgroundColor == backgroundColor &&
        other.overlayStyle == overlayStyle;
  }

  @override
  int get hashCode {
    return maxHeight.hashCode ^
        minHeight.hashCode ^
        headerHeight.hashCode ^
        thumbHandlerHeight.hashCode ^
        snapingPoint.hashCode ^
        headerBackground.hashCode ^
        foregroundColor.hashCode ^
        backgroundColor.hashCode ^
        overlayStyle.hashCode;
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
  late double _remainingSpace;
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
      _slideController.value.factor > (_setting.snapingPoint);

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
        _slideController.attach(
          SlideValue(
            factor: _animationController.value,
            state: _aboveHalfWay ? SlideState.max : SlideState.min,
          ),
        );
      });
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
          (mediaQuery.size.height - event.position.dy) > _slideMinHeight;
      _scrollToTop = pointerReachedHandler;
    }

    if (!_scrollToBottom &&
        slideState == SlideState.max &&
        state == SlideState.slidingDown) {
      final isControllerOffsetZero =
          _scrollController.hasClients && _scrollController.offset == 0.0;

      final headerMinPosition = _size.height - _slideMaxHeight;
      final headerMaxPosition = headerMinPosition + _setting.headerHeight;
      final isHandler = event.position.dy >= headerMinPosition &&
          event.position.dy <= headerMaxPosition;
      _scrollToBottom = isHandler || isControllerOffsetZero;
      if (_scrollToBottom) {
        _pointerPositionBeforeScroll = event.position;
      }
    }

    if (_scrollToTop || _scrollToBottom) {
      final startingPX = event.position.dy -
          (_scrollToTop
              ? _setting.thumbHandlerHeight
              : _pointerPositionBeforeScroll.dy);
      final num remainingPX =
          (_remainingSpace - startingPX).clamp(0.0, _remainingSpace);

      final num factor = (remainingPX / _remainingSpace).clamp(0.0, 1.0);
      _slideslideWithPosition(factor as double, state);
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
          ? (dyVelocity.isNegative ? 1.0 : 0.0)
          : (_aboveHalfWay ? 1.0 : 0.0);
      _snapToPosition(endValue);
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

  void _slideslideWithPosition(double factor, SlideState state) {
    _slideController.attach(
      SlideValue(
        factor: factor,
        state: state,
      ),
    );
  }

  void _snapToPosition(double endValue, {double? startValue}) {
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final mediaQuery = MediaQuery.of(context);

          _size = constraints.biggest;
          _slideMaxHeight =
              _setting.maxHeight ?? _size.height - mediaQuery.padding.top;
          _slideMinHeight = _setting.minHeight ?? _slideMaxHeight * 0.37;
          _remainingSpace = _slideMaxHeight - _slideMinHeight;

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
                                _slideController.closeslide();
                              }
                            },
                            child: Container(),
                          ),
                        ),

                        // Sliding slide
                        ValueListenableBuilder(
                          valueListenable: _slideController,
                          builder: (context, SlideValue value, child) {
                            final height = (_slideMinHeight +
                                    (_remainingSpace * value.factor))
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
            ],
          );
        },
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
  Widget? _attachedView;

  late _SlidableState _state;

  // ignore: use_setters_to_change_properties
  void _init(_SlidableState state) {
    _state = state;
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

  ///
  void attachView(Widget view) {
    _attachedView = view;
    openslide();
  }

  /// Change gesture status
  set isGestureEnabled(bool isEnable) {
    if (isGestureEnabled && isEnable) return;
    _gesture = isEnable;
  }

  ///
  /// Open slide to the viewport
  ///
  void openslide() {
    _internal = true;
    if (value.state == SlideState.min) return;
    value = value.copyWith(
      state: SlideState.min,
      factor: 0,
      offset: 0,
      position: Offset.zero,
    );
    _slideVisibility.value = true;
    _gesture = true;
    _internal = false;
  }

  ///
  /// Maximize slide to its full size
  ///
  void maximizeslide() {
    if (value.state == SlideState.max) return;
    _state._snapToPosition(1);
  }

  /// Minimize slide to its minimum size
  void minimizeslide() {
    if (value.state == SlideState.min) return;
    _state._snapToPosition(0);
  }

  ///
  /// Close slide from viewport
  ///
  void closeslide() {
    if (!isVisible || value.state == SlideState.close) return;
    _internal = true;
    value = value.copyWith(
      state: SlideState.close,
      factor: 0,
      offset: 0,
      position: Offset.zero,
    );
    _slideVisibility.value = false;
    _gesture = false;
    _internal = false;
  }

  ///
  @internal
  void pauseslide() {
    _internal = true;
    if (value.state == SlideState.paused) return;
    value = value.copyWith(state: SlideState.paused);
    _slideVisibility.value = false;
    _internal = false;
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
    _internal = false;
  }

  @override
  set value(SlideValue newValue) {
    if (!_internal) return;
    super.value = newValue;
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
    return '''
    slideValue(
      state: $state, 
      factor: $factor, 
      offset: $offset, 
      position: $position
    )''';
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
