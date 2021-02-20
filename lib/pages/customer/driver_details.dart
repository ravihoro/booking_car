import 'package:booking_car/pages/customer/make_booking.dart';
import 'package:flutter/material.dart';
import 'package:db_repository/db_repository.dart';

class DriverDetails extends StatelessWidget {
  final Driver driver;

  DriverDetails({this.driver});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Driver Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              CircleAvatar(
                child: Text('NA'),
                maxRadius: MediaQuery.of(context).size.width * 0.18,
              ),
              Text(
                'Name: ${driver.name}',
              ),
              Text(
                'Email: ${driver.email}',
              ),
              Text('Car Details'),
              SizedBox(
                height: 200,
                child: carDetails(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        //color: Colors.blueAccent,
        child: RaisedButton(
          color: Colors.blue,
          child: Text(
            'New Booking',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            // var customerEmail =
            //     context.read<AuthenticationBloc>().state.user.email;
            var driverEmail = driver.email;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MakeBooking(
                      driverEmail: driverEmail,
                    )));
          },
        ),
      ),
    );
  }

  Widget carDetails() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          elevation: 10.0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.01,
            width: MediaQuery.of(context).size.height * 0.2,
            color: Colors.red,
          ),
        );
      },
    );
  }
}
