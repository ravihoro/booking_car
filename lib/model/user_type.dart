import 'package:formz/formz.dart';

enum UserTypeValidationError { invalid }

class UserType extends FormzInput<String, UserTypeValidationError> {
  const UserType.pure() : super.pure('');
  const UserType.dirty([String value = '']) : super.dirty(value);

  UserTypeValidationError validator(String value) {
    return value.isEmpty ? UserTypeValidationError.invalid : null;
  }
}
