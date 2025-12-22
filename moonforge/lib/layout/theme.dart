import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' hide Window;
import 'package:flutter_acrylic/flutter_acrylic.dart';

class AppTheme extends ChangeNotifier {
  ColorScheme _colorScheme = ColorSchemes.darkViolet;
  ColorScheme get colorScheme => _colorScheme;
  set colorScheme(final ColorScheme colorScheme) {
    _colorScheme = colorScheme;
    _theme = ThemeData(colorScheme: _colorScheme);
    notifyListeners();
  }

  ThemeData _theme = ThemeData(
    colorScheme: ColorSchemes.darkViolet,
    typography: Typography.geist(
      sans: GoogleFonts.notoSans(),
      //mono: const TextStyle(fontFamily: 'GeistMono', package: 'shadcn_flutter'),
    ),
  );
  ThemeData get theme => _theme;
  set theme(final ThemeData theme) {
    _theme = theme;
    notifyListeners();
  }

  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;
  set mode(final ThemeMode mode) {
    _mode = mode;
    notifyListeners();
  }

  WindowEffect _windowEffect = WindowEffect.disabled;
  WindowEffect get windowEffect => _windowEffect;
  set windowEffect(final WindowEffect windowEffect) {
    _windowEffect = windowEffect;
    notifyListeners();
  }

  void setEffect(final WindowEffect effect, final BuildContext context) {
    final theme = Theme.of(context);
    Window.setEffect(
      effect: effect,
      color: [WindowEffect.solid, WindowEffect.acrylic].contains(effect)
          ? theme.colorScheme.background.withValues(alpha: 0.05)
          : Colors.transparent,
      dark: theme.brightness == Brightness.dark,
    );
  }
}

/// TextStyle extensions for letter spacing (tracking).
/// 
/// Usage:
/// ```dart
/// Text('Hello', style: theme.typography.h1.trackingWide);
/// ```
extension LetterSpacing on TextStyle {
  TextStyle get trackingTighter => _withTrackingEm(-0.05);
  TextStyle get trackingTight => _withTrackingEm(-0.025);
  TextStyle get trackingNormal => _withTrackingEm(0);
  TextStyle get trackingWide => _withTrackingEm(0.025);
  TextStyle get trackingWider => _withTrackingEm(0.05);
  TextStyle get trackingWidest => _withTrackingEm(0.1);

  // Converts em values to logical px using the current fontSize.
  TextStyle _withTrackingEm(final double em) {
    final size = fontSize;
    return copyWith(letterSpacing: size == null ? em : size * em);
  }
}
