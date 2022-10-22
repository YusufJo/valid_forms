import 'package:test/test.dart';
import 'package:valid_forms/src/constant/phone_number_area.g.dart';
import 'package:valid_forms/src/predicate/fixed_line_number_validation_predicate.dart';

void main() {
  group('$FixedLineNumberValidationPredicate', () {
    group('$SomeFixedLineNumberValidationPredicate', () {
      test('should accept allowed numbers only', () {
        const allowedAreas = [
          PhoneNumberArea.unitedStates,
          PhoneNumberArea.egypt,
        ];

        final sut1 = SomeFixedLineNumberValidationPredicate(
          fixedLineNumber: '+12015550123',
          allowedAreas: allowedAreas,
        );

        final sut2 = SomeFixedLineNumberValidationPredicate(
          fixedLineNumber: '+20452555555',
          allowedAreas: allowedAreas,
        );

        final sut3 = SomeFixedLineNumberValidationPredicate(
          fixedLineNumber: '+41212345678',
          allowedAreas: allowedAreas,
        );

        // assert - US number
        expect(sut1(), isTrue);

        // assert - EG number
        expect(sut2(), isTrue);

        // assert - CH number (not allowed)
        expect(sut3(), isFalse);
      });
    });

    group('$AllFixedLineNumberValidationPredicate', () {
      test('should accept all numbers except blocked numbers', () {
        const forbiddenAreas = [PhoneNumberArea.egypt];

        final sut1 = AllFixedLineNumberValidationPredicate(
          fixedLineNumber: '+12015550123',
          forbiddenAreas: forbiddenAreas,
        );

        final sut2 = AllFixedLineNumberValidationPredicate(
          fixedLineNumber: '+20452555555',
          forbiddenAreas: forbiddenAreas,
        );

        final sut3 = AllFixedLineNumberValidationPredicate(
          fixedLineNumber: '+41212345678',
          forbiddenAreas: forbiddenAreas,
        );

        // assert - US number
        expect(sut1(), isTrue);

        // assert - EG number (blocked)
        expect(sut2(), isFalse);

        // assert - CH number
        expect(sut3(), isTrue);
      });
    });
  });
}
