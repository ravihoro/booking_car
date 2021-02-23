import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/driver.dart';
import 'package:meta/meta.dart';
import '../model/booking.dart';

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

  Future getDriverBookingDates({String email, DateTime date}) async {
    var response = await http.get(url + "/driver_bookings_date/$email/$date");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List;
      List<String> bookingDates =
          data.map((e) => e['date'].toString()).toList();
      return bookingDates;
    } else {
      return null;
    }
  }

  Future getDriverBookings({String email, String status, DateTime date}) async {
    var response;
    if (date != null) {
      response =
          await http.get(url + "/driver_bookings/$email/$status/${date}");
    } else {
      response = await http.get(url + "/driver_bookings/$email/$status");
    }
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List;
      //List<Booking> bookings = data.map((e) => Booking.fromJson(e)).toList();
      List<Booking> bookings = List<Booking>();
      for (int i = 0; i < data.length; i++) {
        Booking booking = Booking.fromJson(data[i]);
        bookings.add(booking);
      }
      return bookings;
    } else {
      return null;
    }
  }

  Future getImage(String filename) async {
    final path = "$url/getImage/$filename";
    var response = await http.get(path);
    if (response.statusCode == 200) {
      return response;
    } else {
      print("Error fetching image");
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

  Future<bool> updateBookingStatus({
    @required String email,
    @required String customerEmail,
    @required DateTime date,
    @required String status,
  }) async {
    var response;
    Map<String, dynamic> data = {
      'email': email,
      'customer_email': customerEmail,
      'date': date.toIso8601String(),
      'status': status,
    };
    String body = jsonEncode(data);
    response = await http.put(
      url + "/update_booking_status",
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> makeBooking({
    @required String email,
    @required String customerName,
    @required String customerEmail,
    @required String origin,
    @required String destination,
    @required DateTime date,
  }) async {
    var response;
    try {
      Map<String, dynamic> data = {
        'email': email,
        'customer_name': customerName,
        'customer_email': customerEmail,
        'origin': origin,
        'destination': destination,
        'status': "unknown",
        'date': date.toIso8601String() + "z",
      };
      String body = jsonEncode(data);

      response = await http.post(
        url + "/make_booking",
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

  Future<bool> saveCarDetails({
    @required String name,
    @required String email,
    @required String regNo,
    @required List<String> imageFileNames,
  }) async {
    var response;
    try {
      Map<String, dynamic> data = {
        'name': name,
        'email': email,
        'reg_no': regNo,
        'images': imageFileNames,
      };
      print(data['images']);
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
