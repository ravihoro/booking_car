import 'package:flutter/material.dart';
import 'package:authentication_repository/authentication_repository.dart';
import './app.dart';

void main() {
  // runApp(MaterialApp(
  //   home: Scaffold(
  //     body: Center(child: Text("Hello")),
  //   ),
  // ));
  runApp(App(
    authenticationRepository: AuthenticationRepository(),
  ));
}
