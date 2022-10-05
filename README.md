## Valid Forms

A simple form validation helper.

### Getting started
create a field and define its validity criteria.
```dart
class FirstNameField extends ValidFormField<FirstNameField, String> {
  const FirstNameField({required super.initial, required super.isRequired});

  @override
  Iterable<ValidFieldValidator> get validators => [
    ValidFieldValidator(
      predicate: () => value.length > 2,
      invalidReason: 'should have more than 2 characters',
    ),
  ];
}
```
a field can be validated on its own.

```dart
final firstName = FirstNameField(initial: '-', isRequired = true);

firstName.isValid; // false
firstName.update('Joseph');
firstName.value;  // 'Joseph'
firstName.addListener(doSomethingWhenValueChanges);
```

or it can be combined with other fields in a form.

```dart
final form = ValidForm(fields: [firstName, email, password]);
```
a form is only valid if all of its required fields are valid.

