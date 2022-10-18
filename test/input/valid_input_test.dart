import 'package:test/test.dart';
import 'package:valid_forms/src/input/valid_input.dart';

import '../fakes.dart';

void main() {
  group('$ValidInput', () {
    test('should know its type', () {
      // arrange
      final sut = FakeSingleValidatorValidFormField(
        initial: '-',
        isRequired: true,
      );

      // assert
      expect(sut.type, FakeSingleValidatorValidFormField);
    });

    test('should be valid when field has no validators', () {
      // arrange
      final sut =
          FakeNoValidatorsValidFormField(initial: '-', isRequired: true);

      // assert
      expect(sut.isValid, isTrue);
    });

    test('should return value of field regardless of its validity', () {
      // arrange
      const initialValue = '-';
      final sut = FakeSingleValidatorValidFormField(
        initial: initialValue,
        isRequired: true,
      );

      // act
      final value = sut.value;

      // assert
      expect(value, initialValue);
    });

    test('should invoke either onValid or onInvalid when validating', () {
      // arrange
      bool hasInvokedOnValid = false;
      bool hasInvokedOnInvalid = false;
      void onValid(_) => hasInvokedOnValid = true;
      void onInvalid(_) => hasInvokedOnInvalid = true;
      final sut = FakeSingleValidatorValidFormField(
        initial: '-',
        isRequired: true,
      );

      // act
      sut.validate(onValid: onValid, onInvalid: onInvalid);

      // assert
      expect(hasInvokedOnValid, isFalse);
      expect(hasInvokedOnInvalid, isTrue);

      // cleanup
      hasInvokedOnValid = false;
      hasInvokedOnInvalid = false;

      // act
      sut.update('1234');
      sut.validate(onValid: onValid, onInvalid: onInvalid);

      // assert
      expect(hasInvokedOnValid, isTrue);
      expect(hasInvokedOnInvalid, isFalse);
    });

    test('should be invalid if at least one validator is not valid', () {
      // arrange
      bool isValid = false;
      List<String> errorMessages = [];
      final sut = FakeMultiValidatorValidFormField(
        initial: '-',
        isRequired: true,
      );

      // assert
      expect(sut.isValid, isFalse);

      // act
      sut.update('12345');

      // assert
      sut.validate(
        onValid: (_) => isValid = true,
        onInvalid: (messages) => errorMessages = messages,
      );
      expect(isValid, isFalse);
      expect(errorMessages, equals(['should have less than 5 characters']));

      // cleanup
      isValid = false;
      errorMessages = [];

      // act
      sut.update('1234');

      // assert
      sut.validate(
        onValid: (_) => isValid = true,
        onInvalid: (messages) => errorMessages = messages,
      );
      expect(isValid, true);
      expect(errorMessages, isEmpty);
    });

    test('should return a list of all validation error messages on invalid',
        () {
      // arrange
      List<String> errorMessages = [];
      final sut = FakeEmailAddressValidFormField(
        initial: '-',
        isRequired: true,
      );

      // act
      sut.validate(
        onValid: (_) {},
        onInvalid: (messages) => errorMessages = messages,
      );

      // assert
      expect(
        errorMessages,
        equals(
          [
            'should contain @ symbol',
            'should end with ".com" only',
          ],
        ),
      );
    });

    test('should notify listeners on updates', () {
      // arrange
      bool isNotified = false;
      void notify() => isNotified = true;
      final sut = FakeSingleValidatorValidFormField(
        initial: '-',
        isRequired: true,
      );

      // act
      sut.addListener(notify);

      // assert
      expect(isNotified, isFalse);

      // act
      sut.update('--');

      // assert
      expect(isNotified, isTrue);
    });
  });
}
