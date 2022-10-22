import 'package:valid_forms/src/predicate/fixed_line_number_validation_predicate.dart';

import 'core/input_validator.dart';

class FixedLineNumberInputValidator extends InputValidator {
  FixedLineNumberInputValidator({
    required final FixedLineNumberValidationPredicate predicate,
    required super.invalidReason,
  }) : super(predicate: predicate);
}
