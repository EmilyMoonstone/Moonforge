import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Safely pops the current route if the widget is still mounted.
void mountedPop(BuildContext context) {
  if (context.mounted) {
    Navigator.of(context).pop();
  }
}
