// Copyright (c) 2022, Joseph.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:valid_forms/valid_forms.dart';

import 'listenable.dart';

import '../input/core/valid_input.dart';

/// A container for multiple fields that need validation.'
///
/// An instance of this class will subscribe to all changes made
/// to all of the added fields.
///
/// The constructor will allow only unique types, meaning that adding
/// a field of the same type more than once will throw an assertion error.
class ValidForm extends Listenable {
  ValidForm({
    required Iterable<ValidInput> fields,
  }) {
    assert(fields.map((e) => e.type).toSet().length == fields.length,
        'fields contain more than one class of the same type');
    _fields = <Object, ValidInput>{
      for (final f in fields) f.type: f,
    };
    _requiredFieldsValidation = <Object, bool>{
      for (final f in fields.where((e) => e.isRequired)) f.type: f.isValid
    };
    _fieldSubscriptions = <Object, void Function()>{};
    _subscribeToRequiredFieldsChanges();
  }

  /// all the fields of the form mapped to their types.
  late final Map<Object, ValidInput> _fields;

  /// all the required fields of the form mapped to their types.
  late final Map<Object, bool> _requiredFieldsValidation;

  /// all the callbacks to be invoked when required fields change in state.
  late final Map<Object, void Function()> _fieldSubscriptions;

  /// release all resources used by this form.
  ///
  /// unsubscribes the required fields changes.
  @override
  void dispose() {
    _unsubscribeToRequiredFieldChanges();
    super.dispose();
  }

  /// returns the field corresponding to type [T].
  T field<T>() {
    assert(_fields.containsKey(T), '[$T] was not added to the form.');
    return _fields[T] as T;
  }

  /// returns the validity status of the form.
  bool get isValid {
    return !(_requiredFieldsValidation.values.contains(false));
  }

  /// resolves the form validity. [onValid] will be invoked if the form is
  /// valid, other wise, [onInvalid] will be invoked.
  ///
  /// [onInvalid] will provide all error messages resulting from invalid values.
  /// Error messages can be prepended with a description of the field by setting
  /// [addFieldDescriptionToMessages] to true.
  void validate({
    required void Function() onValid,
    required void Function(Iterable<String> errors) onInvalid,
    bool addFieldDescriptionToMessages = false,
  }) {
    if (isValid) {
      onValid();
    } else {
      final errors = <String>[];
      for (final field in _fields.values.where((e) => e.isRequired)) {
        field.validate(
          // coverage:ignore-start
          onValid: (_) {}, // coverage:ignore-end
          onInvalid: (e) => errors.addAll(
            e.map(
              (e) =>
                  field.description.isNotEmpty ? '${field.description} $e' : e,
            ),
          ),
        );
      }
      onInvalid(errors);
    }
  }

  void _subscribeToRequiredFieldsChanges() {
    for (final field in _fields.values) {
      if (!field.isRequired) continue;
      void subscription() {
        _requiredFieldsValidation[field.type] = field.isValid;
        notifyListeners();
      }

      _fieldSubscriptions[field.type] = subscription;
      field.addListener(subscription);
    }
  }

  void _unsubscribeToRequiredFieldChanges() {
    for (final field in _fields.values) {
      field.removeListener(_fieldSubscriptions[field.type]!);
    }
  }
}
