import 'package:valid_forms/src/valid_field_validator.dart';
import 'package:valid_forms/src/valid_form_field.dart';
import 'package:valid_forms/src/valid_text_form_field.dart';

class FakeNoValidatorsValidFormField
    extends ValidFormField<FakeNoValidatorsValidFormField, String> {
  FakeNoValidatorsValidFormField({
    required super.initial,
    required super.isRequired,
  });

  @override
  Iterable<ValidFieldValidator> get validators => [];
}

class FakeSingleValidatorValidFormField
    extends ValidFormField<FakeSingleValidatorValidFormField, String> {
  FakeSingleValidatorValidFormField({
    required super.initial,
    required super.isRequired,
  });

  @override
  Iterable<ValidFieldValidator> get validators => [
        ValidFieldValidator(
          predicate: () => value.length >= 3,
          invalidReason: 'should have at least 3 characters',
        ),
      ];
}

class FakeMultiValidatorValidFormField
    extends ValidFormField<FakeMultiValidatorValidFormField, String> {
  FakeMultiValidatorValidFormField({
    required super.initial,
    required super.isRequired,
  });

  @override
  Iterable<ValidFieldValidator> get validators => [
        ValidFieldValidator(
          predicate: () => value.length > 3,
          invalidReason: 'should have more than 3 characters',
        ),
        ValidFieldValidator(
          predicate: () => value.length < 5,
          invalidReason: 'should have less than 5 characters',
        ),
      ];
}

class FakeEmailAddressValidFormField
    extends ValidFormField<FakeEmailAddressValidFormField, String> {
  FakeEmailAddressValidFormField({
    required super.initial,
    required super.isRequired,
    super.description,
  });

  @override
  Iterable<ValidFieldValidator> get validators => [
        ValidFieldValidator(
          predicate: () => value.contains('@'),
          invalidReason: 'should contain @ symbol',
        ),
        ValidFieldValidator(
          predicate: () => value.endsWith('.com'),
          invalidReason: 'should end with ".com" only',
        ),
      ];
}

class FakeValidTextFormField
    extends ValidTextFormField<FakeValidTextFormField> {
  FakeValidTextFormField({
    required super.initial,
    required super.isRequired,
    super.trimExtraSpaces,
  });

  @override
  Iterable<ValidFieldValidator> get validators => [];
}
