// Copyright (c) 2022, Joseph.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:valid_forms/src/input/core/valid_input.dart';

/// a text field to be validated against zero or more validators.
abstract class ValidTextInput<T> extends ValidInput<T, String> {
  ValidTextInput({
    required super.initial,
    required super.isRequired,
    this.trimExtraSpaces = true,
  });

  /// remove extra spaces from string.
  final bool trimExtraSpaces;

  /// update the value of this field.
  @override
  @mustCallSuper
  void update(String value) {
    super.update(trimExtraSpaces? _filterWhiteSpaces(value) : value);
  }

  String _filterWhiteSpaces(final String value) {
    final trimmed = value.trim();
    return trimmed.replaceAll(RegExp(r'\s{2,}'), ' ');
  }
}
