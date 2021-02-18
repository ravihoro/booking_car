import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/driver.dart';
import 'package:meta/meta.dart';

final url = "http://192.168.0.6:3000";

class DbRepository {
  Future getDrivers({String name}) async {
    var response = await http.get(url + "/drivers/$name");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List;
      List<Driver> drivers = data.map((e) => Driver.fromJson(e)).toList();
      return drivers;
    } else {
      return null;
    }
  }

  Future getCarDetails({String email}) async {
    var response = await http.get(url + '/car_details/$email');
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      return {};
    }
  }

  Future<bool> saveCarDetails({
    @required String name,
    @required String email,
    @required String regNo,
  }) async {
    var response;
    try {
      Map data = {
        'name': name,
        'email': email,
        'reg_no': regNo,
      };

      String body = jsonEncode(data);

      response = await http.post(
        url + "/save_car_details",
        headers: {"Content-Type": "application/json"},
        body: body,
      );
    } catch (e) {
      print(e.toString());
    }

    if (response.statusCode == 409 || response.statusCode == 500) {
      return false;
    } else {
      return true;
    }
  }
}
