import 'package:test/test.dart';
import 'package:valid_forms/src/predicate/custom_validation_predicate.dart';
import 'package:valid_forms/src/validator/core/input_validator.dart';

class _FakeValidFieldValidator extends InputValidator {
  _FakeValidFieldValidator({
    required super.predicate,
    required super.invalidReason,
  });
}

void main() {
  group('$InputValidator', () {
    test('should return predicate value on validation', () {
      // arrange
      final predicate = CustomValidationPredicate(() => false);
      const invalidReason = 'value is false';
      final sut = _FakeValidFieldValidator(
        predicate: predicate,
        invalidReason: invalidReason,
      );

      // act
      final result = sut.isValid;

      // assert
      expect(result, predicate());
    });
  });
}
