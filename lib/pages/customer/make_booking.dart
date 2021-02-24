import 'package:booking_car/pages/customer/calendar.dart';
//import 'package:booking_car/pages/customer/customer_home_page.dart';
import 'package:flutter/material.dart';
import 'package:db_repository/db_repository.dart';
import 'package:provider/provider.dart';
import '../../authentication/bloc/authentication_bloc.dart';

class MakeBooking extends StatefulWidget {
  final String driverEmail;
  final String driverName;

  MakeBooking({this.driverName, this.driverEmail});

  @override
  _MakeBookingState createState() => _MakeBookingState();
}

class _MakeBookingState extends State<MakeBooking> {
  TextEditingController _originController;
  TextEditingController _destinationController;
  TextEditingController _dateController;

  String customerEmail;
  String customerName;

  DbRepository dbRepository;

  GlobalKey<FormState> globalKey;

  @override
  void initState() {
    super.initState();
    _originController = TextEditingController();
    _destinationController = TextEditingController();
    _dateController = TextEditingController();
    var customer = context.read<AuthenticationBloc>().state.user;
    customerEmail = customer.email;
    customerName = customer.name;
    globalKey = GlobalKey<FormState>();
    //print(customerEmail);
    dbRepository = context.read<DbRepository>();
    //print(dbRepository.getDriverBookings(widget.driverEmail, DateTime.now()));
  }

  Future getDriverBookingDates(String email) async {
    return dbRepository.getDriverBookingDates(
        email: email, date: DateTime.now());
  }

  String selectedTime;
  timeCallback(callbacktime) {
    setState(() {
      selectedTime = callbacktime;
      _dateController.text =
          selectedTime == null ? "" : selectedTime.substring(0, 10);
    });
    print(callbacktime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Booking"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: globalKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _originController,
                  validator: (value) {
                    if (value == "") {
                      return "Origin cannot be empty";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Origin',
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: _destinationController,
                  validator: (value) {
                    if (value == "") {
                      return "Destination cannot be empty";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Destination',
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: _dateController,
                  validator: (value) {
                    print(value == "");
                    if (value == "" || value == null) {
                      return "Select date from Calendar.";
                    }
                    return null;
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      //enabled: false,
                      labelText: "Date"),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Flexible(
                  child: FutureBuilder(
                    future: getDriverBookingDates(widget.driverEmail),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Container(
                        decoration:
                            BoxDecoration(border: Border.all(width: 1.0)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Calendar(
                                dates: snapshot.data,
                                timecallback: timeCallback),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "Note: Can only select dates which are not already booked and greater than current date.",
                                  style: TextStyle(
                                    color: Colors.red,
                                  )),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Builder(
        builder: (context) {
          return Container(
            height: 50.0,
            child: RaisedButton(
              color: Colors.blue,
              child:
                  Text("Make booking", style: TextStyle(color: Colors.white)),
              onPressed: () {
                //print(_dateController.text);
                if (globalKey.currentState.validate()) {
                  print("Booking started");
                  makeBooking(context);
                }
              },
            ),
          );
        },
      ),
    );
  }

  void makeBooking(BuildContext context) async {
    bool val = await dbRepository.makeBooking(
      email: widget.driverEmail,
      name: widget.driverName,
      customerName: customerName,
      customerEmail: customerEmail,
      origin: _originController.text,
      destination: _destinationController.text,
      date: DateTime.parse(_dateController.text),
    );
    if (!val) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Booking failed"),
        backgroundColor: Colors.red,
      ));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Booking successful"),
        backgroundColor: Colors.blue,
      ));
    }
  }
}
