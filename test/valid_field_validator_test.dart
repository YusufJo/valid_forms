import 'package:test/test.dart';
import 'package:valid_forms/src/valid_field_validator.dart';

class _FakeValidFieldValidator extends ValidFieldValidator {
  _FakeValidFieldValidator({
    required super.predicate,
    required super.invalidReason,
  });
}

void main() {
  group('$ValidFieldValidator', () {
    test('should return predicate value on validation', () {
      // arrange
      bool predicate() => false;
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
