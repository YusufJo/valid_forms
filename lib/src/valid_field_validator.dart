import 'package:meta/meta.dart';

/// A validator that validates a field based on a condition.
/// Has a [invalidReason] field that can be displayed when the field is invalid.
class ValidFieldValidator {
  const ValidFieldValidator({
    required this.predicate,
    required this.invalidReason,
  });

  /// boolean callback to determine the validity of a field value.
  final bool Function() predicate;

  /// description of why this validator might invalidate a value.
  final String invalidReason;

  /// determine the validity of a field.
  @internal
  bool get isValid => predicate();
}
