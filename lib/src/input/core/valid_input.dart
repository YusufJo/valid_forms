// Copyright (c) 2022, Joseph.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:valid_forms/src/core/listenable.dart';

import '../../validator/core/input_validator.dart';

/// a field to be validated against zero or more validators.
abstract class ValidInput<T, V> extends Listenable {
  ValidInput({
    required V initial,
    required this.isRequired,
    this.description = '',
  }) : _value = initial;

  /// marks a field as required.
  final bool isRequired;

  /// user friendly short description of the field.
  final String description;

  /// current value of the field.
  V _value;

  /// current value of the field.
  V get value => _value;

  /// a set of validators to be run on the value of this field.
  Iterable<InputValidator> get validators;

  /// determines wither the field is valid for all validators.
  @mustCallSuper
  bool get isValid {
    for (final validator in validators) {
      if (!validator.isValid) return false;
    }
    return true;
  }

  /// resolves the field validity. [onValid] will be invoked if the field is
  /// valid, other wise, [onInvalid] will be invoked.
  ///
  /// [onInvalid] will provide all error messages resulting from invalid values.
  @mustCallSuper
  void validate({
    required void Function(V value) onValid,
    required void Function(List<String> errors) onInvalid,
  }) {
    if (isValid) {
      onValid(_value);
    } else {
      final errors = <String>[];
      for (final validator in validators) {
        if (!validator.isValid) errors.add(validator.invalidReason);
      }
      onInvalid(errors);
    }
  }

  /// returns the type of this field.
  @internal
  Object get type => T;

  /// update the value of this field.
  @mustCallSuper
  void update(V value) {
    _value = value;
    notifyListeners();
  }
}
