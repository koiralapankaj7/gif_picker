import 'package:flutter/material.dart';

///
class App extends StatefulWidget {
  ///
  const App({
    Key? key,
    required this.home,
  }) : super(key: key);

  ///
  final Widget home;

  @override
  State<App> createState() => _CustomAppState();
}

class _CustomAppState extends State<App> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late final XNavigator _navigator;

  @override
  void initState() {
    super.initState();
    _navigator = XNavigator(home: widget.home);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    // ignore: prefer_int_literals
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _navigator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _XNavigatorProvider(
      xNavigator: _navigator,
      child: AnimatedBuilder(
        animation: _navigator,
        builder: (context, child) {
          return IndexedStack(
            index: _navigator.currentIndex,
            children: _navigator.pages,
          );
        },
      ),
    );
  }
}

///
class XNavigator extends ChangeNotifier {
  ///
  XNavigator({required Widget home}) : _pages = [home];

  ///
  final List<Widget> _pages;

  ///
  List<Widget> get pages => _pages;

  ///
  Widget get currentPage => _pages.last;

  ///
  int get currentIndex => _pages.length - 1;

  ///
  void push(Widget page) {
    _pages.add(page);
    notifyListeners();
  }

  ///
  void pushReplacement(Widget page) {
    _pages
      ..removeLast()
      ..add(page);
    notifyListeners();
  }

  ///
  void pop() {
    if (_pages.length == 1) return;
    _pages.removeLast();
    notifyListeners();
  }
}

///
class _XNavigatorProvider extends InheritedWidget {
  ///
  const _XNavigatorProvider({
    Key? key,
    required this.xNavigator,
    required Widget child,
  }) : super(key: key, child: child);

  ///
  final XNavigator xNavigator;

  ///
  static XNavigator? _of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<_XNavigatorProvider>();
    return result?.xNavigator;
  }

  @override
  bool updateShouldNotify(covariant _XNavigatorProvider oldWidget) =>
      xNavigator != oldWidget.xNavigator;
}

///
extension XNavigatorProviderX on BuildContext {
  /// [XNavigator] instance
  XNavigator? get xNavigator => _XNavigatorProvider._of(this);
}
