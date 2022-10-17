// Copyright (c) 2022, Joseph.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:meta/meta.dart';

import 'valid_input.dart';

/// a field to confirm the value of another field, and to be validated against
/// zero or more validators.
abstract class ConfirmableValidInput<T1 extends ValidInput<T1, V>,
    T2 extends ValidInput<T2, V>, V> extends ValidInput<T1, V> {
  // coverage:ignore-start
  ConfirmableValidInput({
    required super.initial,
    required this.fieldToConfirm,
    required super.isRequired,
  }); // coverage:ignore-end

  /// field to confirm the correctness of its value.
  @protected
  final T2 fieldToConfirm;
}
