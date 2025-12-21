import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:moonforge/core/utils/logger.dart';

/// Base class for all service classes.
///
/// Provides common functionality like logging and error handling.
abstract class BaseService with ChangeNotifier {
  /// Service name for logging
  String get serviceName;
  LogContext get logContext;

  void logDebug(String message) {
    logger.d('[$serviceName] $message', context: logContext);
  }

  void logInfo(String message) {
    logger.i('[$serviceName] $message', context: logContext);
  }

  void logWarning(String message, [Object? warning, StackTrace? stackTrace]) {
    logger.w(
      '[$serviceName] $message',
      error: warning,
      stackTrace: stackTrace,
      context: logContext,
    );
  }

  void logError(String message, [Object? error, StackTrace? stackTrace]) {
    logger.e(
      '[$serviceName] $message',
      error: error,
      stackTrace: stackTrace,
      context: logContext,
    );
  }

  void logTrace(String message) {
    logger.t('[$serviceName] $message', context: logContext);
  }

  /// Execute operation with error handling
  Future<T> executeAsync<T>(
    Future<T> Function() operation, {
    String? operationName,
  }) async {
    try {
      logDebug('${operationName ?? "Operation"} started');
      final result = await operation();
      logDebug('${operationName ?? "Operation"} completed');
      return result;
    } catch (error, stackTrace) {
      logError('${operationName ?? "Operation"} failed', error, stackTrace);
      rethrow;
    }
  }

  T execute<T>(T Function() operation, {String? operationName}) {
    try {
      logDebug('${operationName ?? "Operation"} started');
      final result = operation();
      logDebug('${operationName ?? "Operation"} completed');
      return result;
    } catch (error, stackTrace) {
      logError('${operationName ?? "Operation"} failed', error, stackTrace);
      rethrow;
    }
  }
}
