import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;
  String? _backgroundImagePath;
  ThemeProvider(this._themeData);

  ThemeData get themeData => _themeData;
  String? get backgroundImagePath => _backgroundImagePath;

  void updateThemeFromColors(Color primaryColor, Color accentColor) {
    _themeData = ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 6,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actionsIconTheme: const IconThemeData(
          color: Colors.white, // Icon color for action icons
        ),
        toolbarHeight: 80, // Custom toolbar height
        systemOverlayStyle: SystemUiOverlayStyle.light, // Status bar style
      ),
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: MaterialColor(
          primaryColor.value,
          <int, Color>{
            50: primaryColor.withOpacity(.1),
            100: primaryColor.withOpacity(.2),
            200: primaryColor.withOpacity(.3),
            300: primaryColor.withOpacity(.4),
            400: primaryColor.withOpacity(.5),
            500: primaryColor.withOpacity(.6),
            600: primaryColor.withOpacity(.7),
            700: primaryColor.withOpacity(.8),
            800: primaryColor.withOpacity(.9),
            900: primaryColor,
          },
        ),
      ).copyWith(secondary: accentColor),
      iconTheme: IconThemeData(color: accentColor),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        displayMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
        bodySmall: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
        labelLarge: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Color for button text
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColor, // Custom active color
        inactiveTrackColor:
            primaryColor.withOpacity(0.3), // Lighter inactive color
        thumbColor: accentColor, // Color for the slider thumb
        overlayColor:
            accentColor.withOpacity(0.2), // Overlay color when thumb is active
        trackHeight: 4.0, // Custom track height
      ),
    );
    notifyListeners();
  }

  void updatePrimaryColor(Color color) {
    _themeData = _themeData.copyWith(
      primaryColor: brightenColor(color),
    );
    notifyListeners();
  }

  Color brightenColor(Color color, [double amount = 0.2]) {
    HSLColor hsl = HSLColor.fromColor(color);
    HSLColor brighterHsl =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return brighterHsl.toColor();
  }

  Color getHSLComplementaryColor(Color color) {
    HSLColor hsl = HSLColor.fromColor(color);
    HSLColor complementaryHSL = hsl.withHue((hsl.hue + 190) % 360);
    return complementaryHSL.toColor();
  }

  Color getComplementaryColor(Color color) {
    return Color.fromARGB(
      color.alpha,
      255 - color.red,
      255 - color.green,
      255 - color.blue,
    );
  }

  void updateBackgroundImage(String imagePath) {
    _backgroundImagePath = imagePath;
    notifyListeners();
  }

  Color getMainColor(Color color) {
    // Define your main colors
    List<Color> mainColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.cyan,
      Colors.yellow,
      // Colors.brown,
      Colors.purple,
      Colors.white,
      Colors.brown,
      // Colors.black
    ];

    // Find the closest color match
    Color closestColor = mainColors.first;
    double closestDistance = _colorDistance(color, closestColor);

    for (Color mainColor in mainColors) {
      double distance = _colorDistance(color, mainColor);
      if (distance < closestDistance) {
        closestDistance = distance;
        closestColor = mainColor;
      }
    }
    return closestColor;
  }

  double _colorDistance(Color a, Color b) {
    // Calculate Euclidean distance in RGB space for color similarity
    return ((a.red - b.red) * (a.red - b.red) +
            (a.green - b.green) * (a.green - b.green) +
            (a.blue - b.blue) * (a.blue - b.blue))
        .toDouble();
  }
}
