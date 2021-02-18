import 'dart:convert';
import '../model/user.dart';
import 'package:meta/meta.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

final url = "http://192.168.0.6:3000";

class AuthenticationRepository {
  final _userController = StreamController<User>();

  Stream<User> get user async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield User.empty;
    yield* _userController.stream;
  }

  Future<bool> login(
      {@required String email, @required String password}) async {
    var response;
    try {
      Map data = {
        'email': email,
        'password': password,
      };

      String body = jsonEncode(data);

      response = await http.post(
        url + "/login",
        headers: {"Content-Type": "application/json"},
        body: body,
      );
    } catch (e) {
      print(e.toString());
    }
    if (response.statusCode == 401) {
      return false;
    } else {
      var data = jsonDecode(response.body);
      _userController.add(User(
          name: data['name'],
          userType: data['user_type'],
          email: data['email'],
          password: data['password']));
      return true;
    }
  }

  void logOut() {
    _userController.add(User.empty);
  }

  Future<bool> signUp({
    @required String name,
    @required String userType,
    @required String email,
    @required String password,
  }) async {
    var response;
    try {
      Map data = {
        'name': name,
        'user_type': userType,
        'email': email,
        'password': password,
      };

      String body = jsonEncode(data);

      response = await http.post(
        url + "/signup",
        headers: {"Content-Type": "application/json"},
        body: body,
      );
    } catch (e) {
      print(e.toString());
    }

    //print(response.body);
    if (response.statusCode == 409) {
      return false;
    } else {
      return true;
    }
  }

  void dispose() {
    _userController.close();
  }
}
