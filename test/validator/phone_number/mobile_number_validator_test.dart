import 'package:test/test.dart';
import 'package:valid_forms/src/validator/phone_number/international_phone_number.g.dart';
import 'package:valid_forms/src/validator/phone_number/mobile_number_validator.dart';

void main() {
  group('$MobileNumberValidator', () {
    group('$SomeMobileNumberValidator', () {
      test('should accept allowed numbers only', () {
        final sut = SomeMobileNumberValidator(
          allowedPhoneNumbers: [
            InternationalPhoneNumber.unitedStates,
            InternationalPhoneNumber.egypt,
          ],
          invalidReason: 'phone number is not correct.',
        );

        // assert - US number
        expect(sut.validator('+12015550123').isValid, isTrue);

        // assert - EG number
        expect(sut.validator('+201001234567').isValid, isTrue);

        // assert - CH number (not allowed)
        expect(sut.validator('+41212345678').isValid, isFalse);
      });
    });

    group('$AllMobileNumberValidator', () {
      test('should accept all numbers except blocked numbers', () {
        final sut = AllMobileNumberValidator(
          invalidReason: 'phone number is not correct.',
          blockedPhoneNumbers: [InternationalPhoneNumber.egypt],
        );

        // assert - US number
        expect(sut.validator('+12015550123').isValid, isTrue);

        // assert - EG number (blocked)
        expect(sut.validator('+201001234567').isValid, isFalse);

        // assert - CH number
        expect(sut.validator('+41781234567').isValid, isTrue);
      });
    });
  });
}
