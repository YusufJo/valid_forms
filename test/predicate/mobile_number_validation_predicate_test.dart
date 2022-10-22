import 'package:test/test.dart';
import 'package:valid_forms/src/constant/phone_number_area.g.dart';
import 'package:valid_forms/src/predicate/mobile_number_validation_predicate.dart';

void main() {
  group('$MobileNumberValidationPredicate', () {
    group('$SomeMobileNumberValidationPredicate', () {
      test('should accept allowed numbers only', () {
        const allowedAreas = [
          PhoneNumberArea.unitedStates,
          PhoneNumberArea.egypt,
        ];

        final sut1 = SomeMobileNumberValidationPredicate(
          mobileNumber: '+12015550123',
          allowedAreas: allowedAreas,
        );

        final sut2 = SomeMobileNumberValidationPredicate(
          mobileNumber: '+201001234567',
          allowedAreas: allowedAreas,
        );

        final sut3 = SomeMobileNumberValidationPredicate(
          mobileNumber: '+41212345678',
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

    group('$AllMobileNumberValidationPredicate', () {
      test('should accept all numbers except blocked numbers', () {
        const forbiddenAreas = [PhoneNumberArea.egypt];

        final sut1 = AllMobileNumberValidationPredicate(
          mobileNumber: '+12015550123',
          forbiddenAreas: forbiddenAreas,
        );

        final sut2 = AllMobileNumberValidationPredicate(
          mobileNumber: '+201001234567',
          forbiddenAreas: forbiddenAreas,
        );

        final sut3 = AllMobileNumberValidationPredicate(
          mobileNumber: '+41781234567',
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
