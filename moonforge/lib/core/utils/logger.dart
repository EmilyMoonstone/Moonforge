import 'package:logger/logger.dart';

/// Log contexts for conditional logging
/// Use these to categorize logs so you can enable/disable specific areas
enum LogContext {
  /// General application logs (always enabled)
  general,

  /// Database operations, Sync-related operations (SyncCoordinator, InboundListener, OutboxProcessor)
  database,

  /// Authentication and user management
  auth,

  /// Navigation and routing
  navigation,

  /// UI state and widget lifecycle
  ui,
}

/// Conditional logger that supports enabling/disabling log contexts
class ConditionalLogger {
  final Logger _logger;
  final Set<LogContext> _enabledContexts = {LogContext.general};

  ConditionalLogger(this._logger);

  /// Enable logging for a specific context
  void enableContext(LogContext context) {
    _enabledContexts.add(context);
  }

  /// Disable logging for a specific context (except general)
  void disableContext(LogContext context) {
    if (context != LogContext.general) {
      _enabledContexts.remove(context);
    }
  }

  /// Enable multiple contexts at once
  void enableContexts(List<LogContext> contexts) {
    _enabledContexts.addAll(contexts);
  }

  /// Disable multiple contexts at once
  void disableContexts(List<LogContext> contexts) {
    for (final context in contexts) {
      disableContext(context);
    }
  }

  /// Check if a context is enabled
  bool isContextEnabled(LogContext context) {
    return _enabledContexts.contains(context);
  }

  /// Get all enabled contexts
  Set<LogContext> get enabledContexts => Set.unmodifiable(_enabledContexts);

  /// Log debug message with optional context
  void d(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
    LogContext context = LogContext.general,
  }) {
    if (_enabledContexts.contains(context)) {
      _logger.d(message, time: time, error: error, stackTrace: stackTrace);
    }
  }

  /// Log info message with optional context
  void i(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
    LogContext context = LogContext.general,
  }) {
    if (_enabledContexts.contains(context)) {
      _logger.i(message, time: time, error: error, stackTrace: stackTrace);
    }
  }

  /// Log warning message with optional context
  void w(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
    LogContext context = LogContext.general,
  }) {
    if (_enabledContexts.contains(context)) {
      _logger.w(message, time: time, error: error, stackTrace: stackTrace);
    }
  }

  /// Log error message with optional context (errors are always logged)
  void e(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
    LogContext context = LogContext.general,
  }) {
    // Errors are always logged regardless of context
    _logger.e(message, time: time, error: error, stackTrace: stackTrace);
  }

  /// Log trace/verbose message with optional context
  void t(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
    LogContext context = LogContext.general,
  }) {
    if (_enabledContexts.contains(context)) {
      _logger.t(message, time: time, error: error, stackTrace: stackTrace);
    }
  }

  /// Log fatal message with optional context (fatal errors are always logged)
  void f(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
    LogContext context = LogContext.general,
  }) {
    // Fatal errors are always logged regardless of context
    _logger.f(message, time: time, error: error, stackTrace: stackTrace);
  }
}

/// Core logger instance with conditional logging support
///
/// **SINGLETON INSTANCE** - This is the single global logger instance used throughout the app.
/// Import this logger from 'package:moonforge/core/utils/logger.dart' in all files that need logging.
///
/// **INITIALIZATION**: The logger is initialized in main.dart with default contexts enabled
/// based on the build mode (debug/release). You can enable/disable contexts at runtime.
///
/// Example usage:
///  logger.i('Informational message');
///  logger.e('Error message', error: exception, stackTrace: stackTrace);
///  logger.d('Debug message');
///  logger.w('Warning message');
///
/// For context-specific logging:
///  logger.d('Sync started', context: LogContext.sync);
///  logger.i('Database query', context: LogContext.database);
///
/// To enable/disable contexts at runtime:
///  logger.enableContext(LogContext.sync);
///  logger.disableContext(LogContext.sync);
///
/// Check if a context is enabled:
///  if (logger.isContextEnabled(LogContext.sync)) {
///    // Expensive debug operation
///  }
final ConditionalLogger logger = ConditionalLogger(
  Logger(
    printer: PrettyPrinter(
      noBoxingByDefault: true,
      errorMethodCount: 12,
      methodCount: 4,
    ),
  ),
);
