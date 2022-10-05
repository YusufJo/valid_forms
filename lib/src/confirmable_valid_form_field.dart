import 'package:meta/meta.dart';

import 'valid_form_field.dart';

/// a field to confirm the value of another field, and to be validated against
/// zero or more validators.
abstract class ConfirmableValidFormField<T1 extends ValidFormField<T1, V>,
    T2 extends ValidFormField<T2, V>, V> extends ValidFormField<T1, V> {
  // coverage:ignore-start
  ConfirmableValidFormField({
    required super.initial,
    required this.fieldToConfirm,
    required super.isRequired,
  }); // coverage:ignore-end

  /// field to confirm the correctness of its value.
  @protected
  final T2 fieldToConfirm;
}
