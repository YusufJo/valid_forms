import 'package:test/test.dart';
import 'package:valid_forms/src/valid_form.dart';

import 'fakes.dart';

void main() {
  group('$ValidForm', () {
    test(
        'should throw assertion error when trying to add two fields '
        'of the same class', () {
      // arrange
      final firstField = FakeSingleValidatorValidFormField(
        initial: '-',
        isRequired: true,
      );
      final secondField = FakeSingleValidatorValidFormField(
        initial: '-',
        isRequired: false,
      );

      // assert
      expect(
        () => ValidForm(fields: [firstField, secondField]),
        throwsA(
          TypeMatcher<AssertionError>().having(
            (error) => error.message,
            'message',
            'fields contain more than one class of the same type',
          ),
        ),
      );
    });

    test('should unsubscribe to fields updates on dispose', () {
      // arrange
      final field = FakeSingleValidatorValidFormField(
        initial: '-',
        isRequired: true,
      );
      final sut = ValidForm(fields: [field]);

      // assert
      expect(field.isValid, isFalse);
      expect(sut.isValid, isFalse);

      // act
      field.update('123');

      // assert
      expect(field.isValid, isTrue);
      expect(sut.isValid, isTrue);

      // act
      sut.dispose();
      field.update('-');

      // assert
      expect(field.isValid, isFalse);
      expect(sut.isValid, isTrue);
    });

    test(
        'should throw assertion error when trying to access a field that is '
        'not added to the form', () {
      // arrange
      final sut = ValidForm(fields: []);

      // assert
      expect(
        () => sut.field<FakeSingleValidatorValidFormField>(),
        throwsA(
          TypeMatcher<AssertionError>().having(
            (error) => error.message,
            'message',
            '[$FakeSingleValidatorValidFormField] was not added to the form.',
          ),
        ),
      );
    });

    test('should return field based on its type', () {
      // arrange
      final firstField = FakeSingleValidatorValidFormField(
        initial: '-',
        isRequired: true,
      );

      final secondField = FakeMultiValidatorValidFormField(
        initial: '-',
        isRequired: true,
      );

      final sut = ValidForm(fields: [firstField, secondField]);

      // act
      final field = sut.field<FakeSingleValidatorValidFormField>();

      // assert
      expect(field, firstField);
    });

    test('should be invalid if at least one field is invalid', () {
      // arrange
      final simpleField = FakeSingleValidatorValidFormField(
        initial: '-',
        isRequired: true,
      );

      final emailField = FakeEmailAddressValidFormField(
        initial: 'test@email.com',
        isRequired: true,
      );

      final sut = ValidForm(fields: [simpleField, emailField]);

      // assert
      expect(simpleField.isValid, isFalse);
      expect(emailField.isValid, isTrue);
      expect(sut.isValid, isFalse);
    });

    test('should ignore non-required fields on validation', () {
      // arrange
      final requiredField = FakeSingleValidatorValidFormField(
        initial: '-',
        isRequired: true,
      );

      final nonRequiredField = FakeMultiValidatorValidFormField(
        initial: '-',
        isRequired: false,
      );

      final sut = ValidForm(fields: [requiredField, nonRequiredField]);

      // assert
      expect(requiredField.isValid, isFalse);
      expect(nonRequiredField.isValid, isFalse);
      expect(sut.isValid, isFalse);

      // act
      requiredField.update('1234');

      // assert
      expect(requiredField.isValid, isTrue);
      expect(nonRequiredField.isValid, isFalse);
      expect(sut.isValid, isTrue);
    });

    test('should invoke either onValid or onInvalid on validation', () {
      // arrange
      bool hasInvokedOnValid = false;
      bool hasInvokedOnInvalid = false;
      void onValid() => hasInvokedOnValid = true;
      void onInvalid(_) => hasInvokedOnInvalid = true;

      final field = FakeSingleValidatorValidFormField(
        initial: '-',
        isRequired: true,
      );

      final sut = ValidForm(fields: [field]);

      // assert
      expect(field.isValid, isFalse);
      expect(sut.isValid, isFalse);
      expect(hasInvokedOnInvalid, isFalse);
      expect(hasInvokedOnValid, isFalse);

      // act
      sut.validate(onValid: onValid, onInvalid: onInvalid);

      // assert
      expect(field.isValid, isFalse);
      expect(sut.isValid, isFalse);
      expect(hasInvokedOnValid, isFalse);
      expect(hasInvokedOnInvalid, isTrue);

      // cleanup
      hasInvokedOnValid = false;
      hasInvokedOnInvalid = false;

      // act
      field.update('1234');
      sut.validate(onValid: onValid, onInvalid: onInvalid);

      // assert
      expect(field.isValid, isTrue);
      expect(sut.isValid, isTrue);
      expect(hasInvokedOnValid, isTrue);
      expect(hasInvokedOnInvalid, isFalse);
    });

    test(
        'should return required fields error messages on validation '
        'when form is invalid', () {
      // arrange
      List<String> errorMessages = [];
      final simpleField = FakeSingleValidatorValidFormField(
        initial: '-',
        isRequired: true,
      );

      final nonRequiredField = FakeMultiValidatorValidFormField(
        initial: '-',
        isRequired: false,
      );

      final emailField = FakeEmailAddressValidFormField(
          initial: '-', isRequired: true, description: 'email address');

      final sut =
          ValidForm(fields: [simpleField, nonRequiredField, emailField]);

      // assert
      expect(simpleField.isValid, isFalse);
      expect(nonRequiredField.isValid, isFalse);
      expect(emailField.isValid, isFalse);
      expect(sut.isValid, isFalse);

      // act
      sut.validate(onValid: () {}, onInvalid: errorMessages.addAll);

      // assert
      expect(
          errorMessages,
          equals([
            'should have at least 3 characters',
            'email address should contain @ symbol',
            'email address should end with ".com" only',
          ]));
    });
  });
}
