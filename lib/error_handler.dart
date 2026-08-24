/// Global error handling configuration for StatTrack application.
/// This file centralizes all error handling logic including Flutter errors,
/// platform errors, and custom error reporting.

library error_handler;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Setup global error handling for the application.
/// Call this method at the beginning of main, before calling runApp.
void setupErrorHandling() {
  // 1. Flutter framework errors (e.g., widget build errors)
  FlutterError.onError = (final details) {
    // Log to console in debug mode
    if (kDebugMode) {
      debugPrint(
        '═══════════════════════════════════════════════════════════',
      );
      debugPrint('❌ FLUTTER ERROR');
      debugPrint(
        '═══════════════════════════════════════════════════════════',
      );
      debugPrint('Exception: ${details.exception}');
      debugPrint('Library: ${details.library}');
      debugPrint('Context: ${details.context}');
      debugPrintStack(stackTrace: details.stack);
      debugPrint(
        '═══════════════════════════════════════════════════════════\n',
      );
    }

    _logErrorToCustomService(details);
  };

  // 2. Platform errors
  PlatformDispatcher.instance.onError = (final error, final stack) {
    if (kDebugMode) {
      debugPrint(
        '═══════════════════════════════════════════════════════════',
      );
      debugPrint('❌ PLATFORM ERROR');
      debugPrint(
        '═══════════════════════════════════════════════════════════',
      );
      debugPrint('Error: $error');
      debugPrintStack(stackTrace: stack);
      debugPrint(
        '═══════════════════════════════════════════════════════════\n',
      );
    }

    _logErrorToCustomService(
      FlutterErrorDetails(
        exception: error,
        stack: stack,
        library: 'Platform',
        context: null,
      ),
    );

    return true;
  };

  // 3. Custom error widget
  ErrorWidget.builder = (final details) {
    if (kDebugMode) {
      return ErrorWidget(details);
    }
    return _buildProductionErrorWidget(details);
  };
}

/// Log error to custom service.
void _logErrorToCustomService(final FlutterErrorDetails details) {
  if (!kDebugMode) {
    // Implement production error logging here.
  }
}

/// Build a user-friendly error widget for production.
Widget _buildProductionErrorWidget(final FlutterErrorDetails details) {
  return Center(
    child: Material(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Color(0xFFB00020),
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Une erreur est survenue',
              style: TextStyle(
                color: Color(0xFFB00020),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Désolé. Veuillez redémarrer l\'application.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB00020),
                foregroundColor: Colors.white,
              ),
              onPressed: () {},
              child: const Text('Redémarrer'),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Custom exception for application-specific errors.
class AppException implements Exception {
  const AppException(this.message, {this.code, this.details});

  final String message;
  final String? code;
  final Object? details;

  @override
  String toString() => 'AppException(code: $code, message: $message)';
}

/// Result wrapper for operations that can fail.
abstract class Result<T> {
  const factory Result.success(final T value) = _ResultSuccess<T>;
  const factory Result.error(final Object error) = _ResultError<T>;

  bool get isSuccess;
  bool get isError;
  T get value;
  Object? get error;

  T orElse(final T Function(Object error) orElse);

  R when<R>({
    required final R Function(T value) onSuccess,
    required final R Function(Object error) onError,
  });
}

class _ResultSuccess<T> implements Result<T> {
  const _ResultSuccess(this._value);

  final T _value;

  @override
  bool get isSuccess => true;

  @override
  bool get isError => false;

  @override
  T get value => _value;

  @override
  Object? get error => null;

  @override
  T orElse(final T Function(Object error) orElse) => _value;

  @override
  R when<R>({
    required final R Function(T value) onSuccess,
    required final R Function(Object error) onError,
  }) => onSuccess(_value);

  @override
  String toString() => 'Result.success($_value)';
}

class _ResultError<T> implements Result<T> {
  const _ResultError(this._error);

  final Object _error;

  @override
  bool get isSuccess => false;

  @override
  bool get isError => true;

  @override
  T get value => throw _error;

  @override
  Object? get error => _error;

  @override
  T orElse(final T Function(Object error) orElse) => orElse(_error);

  @override
  R when<R>({
    required final R Function(T value) onSuccess,
    required final R Function(Object error) onError,
  }) => onError(_error);

  @override
  String toString() => 'Result.error($_error)';
}

extension ResultExtensions<T> on T {
  Result<T> toResult() => Result.success(this);
}

extension ResultErrorExtensions<E extends Object> on E {
  Result<T> toErrorResult<T>() => Result.error(this);
}
