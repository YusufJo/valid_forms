// Copyright (c) 2022, Joseph.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:valid_forms/src/validator/input_validator.dart';

import 'international_phone_number.g.dart';

/// International fixed line number validator.
/// Depends on code generated by tool/libphonenumber_generator.
///
/// {@template input_guide}
/// Expected input should be in the form: +<country code><phone number>.
/// Input should only contain plus sign [+] followed by country code and then
/// the number.
///
///   Examples: +12015550123 & +20452555555.
/// {@endtemplate}
abstract class FixedLineNumberValidator {
  const FixedLineNumberValidator();

  InputValidator Function(String) get validator;
}

/// International fixed line number validator for some allowed areas.
///
/// Validating a valid number for an area that's not allowed will be
/// reported as invalid.
///
/// {@macro input_guide}
class SomeFixedLineNumberValidator extends FixedLineNumberValidator {
  const SomeFixedLineNumberValidator({
    required final List<InternationalPhoneNumber> allowedPhoneNumbers,
    required final String invalidReason,
  })  : _allowedPhoneNumbers = allowedPhoneNumbers,
        _invalidReason = invalidReason;

  final List<InternationalPhoneNumber> _allowedPhoneNumbers;
  final String _invalidReason;

  @override
  InputValidator Function(String) get validator {
    return (final value) => InputValidator(
          predicate: () => _allowedPhoneNumbers
              .map((e) => e.fixedLinePattern)
              .any((p) => p.hasMatch(value)),
          invalidReason: _invalidReason,
        );
  }
}

/// International fixed line number validator for all areas.
///
/// {@macro input_guide}
class AllFixedLineNumberValidator extends FixedLineNumberValidator {
  const AllFixedLineNumberValidator({
    required final String invalidReason,
    final List<InternationalPhoneNumber> blockedPhoneNumbers = const [],
  })  : _invalidReason = invalidReason,
        _blockedPhoneNumbers = blockedPhoneNumbers;

  final String _invalidReason;
  final List<InternationalPhoneNumber> _blockedPhoneNumbers;

  @override
  InputValidator Function(String) get validator {
    return (final value) => InputValidator(
          predicate: () => InternationalPhoneNumber.values
              .where((e) => !_blockedPhoneNumbers.contains(e))
              .map((e) => e.fixedLinePattern)
              .any((p) => p.hasMatch(value)),
          invalidReason: _invalidReason,
        );
  }
}