import 'package:meta/meta.dart';

class User {
  final String name;
  final String userType;
  final String email;
  final String password;

  const User(
      {@required this.name,
      @required this.userType,
      @required this.email,
      @required this.password});

  static const empty = User(name: '', userType: '', email: '', password: '');
}
