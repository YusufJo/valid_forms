import '../predicate/mobile_number_validation_predicate.dart';
import 'core/input_validator.dart';

class MobileNumberInputValidator extends InputValidator {
  MobileNumberInputValidator({
    required final MobileNumberValidationPredicate predicate,
    required super.invalidReason,
  }) : super(predicate: predicate);
}
