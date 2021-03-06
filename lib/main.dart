import 'package:flutter/material.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:db_repository/db_repository.dart';
import './app.dart';

void main() {
  runApp(App(
    authenticationRepository: AuthenticationRepository(),
    dbRepository: DbRepository(),
  ));
}
