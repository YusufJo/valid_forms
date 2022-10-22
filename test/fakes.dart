import 'package:valid_forms/src/predicate/custom_validation_predicate.dart';
import 'package:valid_forms/src/validator/core/input_validator.dart';
import 'package:valid_forms/src/input/core/valid_input.dart';
import 'package:valid_forms/src/input/valid_text_input.dart';
import 'package:valid_forms/src/validator/custom_input_validator.dart';

class FakeNoValidatorsValidFormField
    extends ValidInput<FakeNoValidatorsValidFormField, String> {
  FakeNoValidatorsValidFormField({
    required super.initial,
    required super.isRequired,
  });

  @override
  Iterable<InputValidator> get validators => [];
}

class FakeSingleValidatorValidFormField
    extends ValidInput<FakeSingleValidatorValidFormField, String> {
  FakeSingleValidatorValidFormField({
    required super.initial,
    required super.isRequired,
  });

  @override
  Iterable<InputValidator> get validators => [
        CustomInputValidator(
          predicate: CustomValidationPredicate(() => value.length >= 3),
          invalidReason: 'should have at least 3 characters',
        ),
      ];
}

class FakeMultiValidatorValidFormField
    extends ValidInput<FakeMultiValidatorValidFormField, String> {
  FakeMultiValidatorValidFormField({
    required super.initial,
    required super.isRequired,
  });

  @override
  Iterable<InputValidator> get validators => [
        CustomInputValidator(
          predicate: CustomValidationPredicate(() => value.length > 3),
          invalidReason: 'should have more than 3 characters',
        ),
        CustomInputValidator(
          predicate: CustomValidationPredicate(() => value.length < 5),
          invalidReason: 'should have less than 5 characters',
        ),
      ];
}

class FakeEmailAddressValidFormField
    extends ValidInput<FakeEmailAddressValidFormField, String> {
  FakeEmailAddressValidFormField({
    required super.initial,
    required super.isRequired,
    super.description,
  });

  @override
  Iterable<InputValidator> get validators => [
        CustomInputValidator(
          predicate: CustomValidationPredicate(() => value.contains('@')),
          invalidReason: 'should contain @ symbol',
        ),
        CustomInputValidator(
          predicate: CustomValidationPredicate(() => value.endsWith('.com')),
          invalidReason: 'should end with ".com" only',
        ),
      ];
}

class FakeValidTextFormField extends ValidTextInput<FakeValidTextFormField> {
  FakeValidTextFormField({
    required super.initial,
    required super.isRequired,
    super.trimExtraSpaces,
  });

  @override
  Iterable<InputValidator> get validators => [];
}
