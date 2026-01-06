import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/core/providers/root_context_provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

enum NotificationType { info, success, warning, error }

/// Show a notification toast in the given [context].
/// 
/// Usage:
/// ```dart
/// showNotification(
///   context,
///   NotificationType.success,
///   'Success',
///   'Your operation was successful.',
///   null,
/// );
/// ```
void showNotification(
  BuildContext context,
  NotificationType type,
  String title,
  String message,
  Widget? action,
) {
  Widget buildToast(BuildContext context, ToastOverlay overlay) {
    return Alert(
      title: Text(title),
      content: Text(message),
      destructive: type == NotificationType.error,
      leading: Icon(
        switch (type) {
          NotificationType.info => Icons.info_outline,
          NotificationType.success => Icons.check_circle_outline,
          NotificationType.warning => Icons.warning_amber_outlined,
          NotificationType.error => Icons.error_outline,
        },
        color: switch (type) {
          NotificationType.info => Theme.of(context).colorScheme.primary,
          NotificationType.success => Theme.of(context).colorScheme.chart2,
          NotificationType.warning => Theme.of(context).colorScheme.chart3,
          NotificationType.error => Theme.of(context).colorScheme.destructive,
        },
      ),
      trailing: Center(child: action ?? const SizedBox.shrink()),
    );
  }

  showToast(
    context: context,
    builder: buildToast,
    location: ToastLocation.bottomRight,
    showDuration: switch (type) {
      NotificationType.info => Duration(seconds: 3),
      NotificationType.success => Duration(seconds: 3),
      NotificationType.warning => Duration(seconds: 5),
      NotificationType.error => Duration(seconds: 7),
    },
  );
}

void showNotificationFromRef(
  Ref ref,
  NotificationType type,
  String title,
  String message, {
  Widget? action,
}) {
  final context = ref.read(rootContextProvider);
  if (context == null) {
    return;
  }

  showNotification(context, type, title, message, action);
}
