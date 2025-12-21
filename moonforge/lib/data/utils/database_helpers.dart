// Helpers for database operations and logging
import 'package:moonforge/core/utils/logger.dart';

/// Logs a database query execution with context
Future<T> logDatabaseQuery<T>(
  String queryDescription,
  Future<T> Function() queryFunction,
) async {
  final startTime = DateTime.now();
  try {
    final result = await queryFunction();
    final duration = DateTime.now().difference(startTime);
    logger.i(
      'Database query succeeded: $queryDescription (Duration: ${duration.inMilliseconds} ms)',
      context: LogContext.database,
    );
    return result;
  } catch (e, s) {
    final duration = DateTime.now().difference(startTime);
    logger.e(
      'Database query failed: $queryDescription (Duration: ${duration.inMilliseconds} ms)',
      error: e,
      stackTrace: s,
      context: LogContext.database,
    );
    rethrow;
  }
}
