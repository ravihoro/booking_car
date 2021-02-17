part of 'sign_up_cubit.dart';

class SignUpState {
  final Name name;
  final UserType userType;
  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final FormzStatus status;
  final bool userPresent;

  const SignUpState({
    this.name = const Name.pure(),
    this.userType = const UserType.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.status = FormzStatus.pure,
    this.userPresent = false,
  });

  SignUpState copyWith({
    Name name,
    UserType userType,
    Email email,
    Password password,
    ConfirmedPassword confirmedPassword,
    FormzStatus status,
    bool userPresent,
  }) {
    return SignUpState(
      name: name ?? this.name,
      userType: userType ?? this.userType,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      status: status ?? this.status,
      userPresent: userPresent ?? this.userPresent,
    );
  }
}
