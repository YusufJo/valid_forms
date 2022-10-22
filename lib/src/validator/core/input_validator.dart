// Copyright (c) 2022, Joseph.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:meta/meta.dart';

import '../../predicate/core/validation_predicate.dart';

/// A validator that validates a field based on a condition.
/// Has a [invalidReason] field that can be displayed when the field is invalid.
abstract class InputValidator {
  const InputValidator({
    required this.predicate,
    required this.invalidReason,
  });

  /// boolean callback to determine the validity of a field value.
  final ValidationPredicate predicate;

  /// description of why this validator might invalidate a value.
  final String invalidReason;

  /// determine the validity of a field.
  @internal
  bool get isValid => predicate();
}
