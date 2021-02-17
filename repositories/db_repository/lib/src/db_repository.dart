import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/driver.dart';

final url = "http://192.168.0.6:3000";

class DbRepository {
  Future getDrivers({String name}) async {
    var response = await http.get(url + "/drivers/$name");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List;
      List<Driver> drivers = data.map((e) => Driver.fromJson(e)).toList();
      //print(drivers);
      return drivers;
    } else {
      return null;
    }
  }
}
