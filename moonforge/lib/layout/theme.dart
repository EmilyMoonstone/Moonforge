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

  ThemeData _theme = ThemeData(colorScheme: ColorSchemes.darkViolet);
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
