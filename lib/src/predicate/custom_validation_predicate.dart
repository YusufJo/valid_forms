import 'core/validation_predicate.dart';

class CustomValidationPredicate extends ValidationPredicate {
  const CustomValidationPredicate(bool Function() predicate)
      : _predicate = predicate;

  final bool Function() _predicate;

  @override
  bool call() => _predicate();
}
