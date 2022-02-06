import 'package:example/gif_picker_example.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

// final logger = Logger

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  ThemeData _copy(ThemeData themeData) {
    final scheme = themeData.colorScheme;

    return themeData.copyWith(
      dividerTheme: const DividerThemeData(
        thickness: 1.0,
        space: 1.0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0.0,
        selectedItemColor: scheme.onBackground,
        unselectedItemColor: scheme.onBackground.withOpacity(0.4),
      ),
      tabBarTheme: TabBarTheme(
        indicatorSize: TabBarIndicatorSize.tab,
        unselectedLabelColor: scheme.onSurface,
        labelColor: scheme.onSurface,
      ),
      iconTheme: themeData.iconTheme.copyWith(color: scheme.onSurface),
      canvasColor: scheme.surface,
      cardColor: scheme.surface,
      dialogBackgroundColor: scheme.surface,
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //
    final lightTheme = FlexColorScheme.light(
      colors: const FlexSchemeColor(
        primary: Color(0xFFfe4545), // RED-600
        primaryVariant: Color(0xFFd70153), // RED-900
        secondary: Color(0xFF2196f3), // BLUE-500
        secondaryVariant: Color(0xFF1565c0), // BLUE-800
      ),
      appBarStyle: FlexAppBarStyle.material,
      background: const Color(0xFFFFFFFF),
      onBackground: const Color(0xFF484848),
      surface: const Color(0xFFEEEEEE),
      onSurface: const Color(0xFF212121),
      scaffoldBackground: const Color(0xFFEEEEEE),
      bottomAppBarElevation: 0.0,
    ).toTheme;

    //
    final darkTheme = FlexColorScheme.dark(
      colors: const FlexSchemeColor(
        primary: Color(0xFFef5350), // RED-400
        primaryVariant: Color(0xFFd32f2f), // RED-700
        secondary: Color(0xFF64b5f6), // BLUE-300
        secondaryVariant: Color(0xFF1e88e5), // BLUE-600
      ),
      appBarStyle: FlexAppBarStyle.material,
      surface: const Color(0xFF121212),
      onSurface: const Color(0xFFAAAAAA),
      background: const Color(0xFF222222),
      onBackground: const Color(0xFFDDDDDD),
      scaffoldBackground: const Color(0xFF121212),
      bottomAppBarElevation: 0.0,
      primaryTextTheme: FlexColorScheme.m3TextTheme,
    ).toTheme;

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData.light(),
      // darkTheme: ThemeData.dark(),
      theme: _copy(lightTheme),
      darkTheme: _copy(darkTheme),
      themeMode: ThemeMode.dark,
      home: const GifPickerExample(),
    );
  }
}
