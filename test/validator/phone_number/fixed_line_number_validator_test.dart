import 'package:test/test.dart';
import 'package:valid_forms/src/validator/phone_number/fixed_line_number_validator.dart';
import 'package:valid_forms/src/validator/phone_number/international_phone_number.g.dart';

void main() {
  group('$FixedLineNumberValidator', () {
    group('$SomeFixedLineNumberValidator', () {
      test('should accept allowed numbers only', () {
        final sut = SomeFixedLineNumberValidator(
          allowedPhoneNumbers: [
            InternationalPhoneNumber.unitedStates,
            InternationalPhoneNumber.egypt,
          ],
          invalidReason: 'phone number is not correct.',
        );

        // assert - US number
        expect(sut.validator('+12015550123').isValid, isTrue);

        // assert - EG number
        expect(sut.validator('+20452555555').isValid, isTrue);

        // assert - CH number (not allowed)
        expect(sut.validator('+41212345678').isValid, isFalse);
      });
    });

    group('$AllFixedLineNumberValidator', () {
      test('should accept all numbers except blocked numbers', () {
        final sut = AllFixedLineNumberValidator(
          invalidReason: 'phone number is not correct.',
          blockedPhoneNumbers: [InternationalPhoneNumber.egypt],
        );

        // assert - US number
        expect(sut.validator('+12015550123').isValid, isTrue);

        // assert - EG number (blocked)
        expect(sut.validator('+20452555555').isValid, isFalse);

        // assert - CH number
        expect(sut.validator('+41212345678').isValid, isTrue);
      });
    });
  });
}
