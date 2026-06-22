/// A lightweight, dependency-free `Result` type for modelling operations that
/// can fail in expected ways (e.g. data access, cloud sync, purchases).
///
/// Repositories and services return `Result<T>` instead of throwing for
/// recoverable errors, which keeps error handling explicit and testable.
/// Truly exceptional/programmer errors should still throw.
library;

import 'package:meta/meta.dart';

/// Base type for a computation that yields a [Success] or a [Failure].
@immutable
sealed class Result<T> {
  const Result();

  /// Wraps a successful [value].
  const factory Result.success(T value) = Success<T>;

  /// Wraps a [failure] describing why the operation did not succeed.
  const factory Result.failure(Failure failure) = ResultFailure<T>;

  /// Whether this result represents success.
  bool get isSuccess => this is Success<T>;

  /// Whether this result represents failure.
  bool get isFailure => this is ResultFailure<T>;

  /// The success value, or `null` if this is a failure.
  T? get valueOrNull => switch (this) {
    Success<T>(:final value) => value,
    ResultFailure<T>() => null,
  };

  /// Folds both branches into a single value of type [R].
  R fold<R>(
    R Function(T value) onSuccess,
    R Function(Failure failure) onFailure,
  ) {
    return switch (this) {
      Success<T>(:final value) => onSuccess(value),
      ResultFailure<T>(:final failure) => onFailure(failure),
    };
  }
}

/// A successful [Result] carrying a [value].
final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Success<T> && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// A failed [Result] carrying a [failure].
final class ResultFailure<T> extends Result<T> {
  const ResultFailure(this.failure);

  final Failure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResultFailure<T> && other.failure == failure;

  @override
  int get hashCode => failure.hashCode;
}

/// Describes why an operation failed, in domain terms.
@immutable
class Failure {
  const Failure(this.message, {this.code, this.cause});

  /// Human-readable description (suitable for logging; not necessarily UI).
  final String message;

  /// Optional stable machine code for branching/telemetry.
  final String? code;

  /// Optional underlying error/exception that triggered this failure.
  final Object? cause;

  @override
  String toString() => 'Failure(${code ?? '-'}: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure && other.message == message && other.code == code;

  @override
  int get hashCode => Object.hash(message, code);
}
