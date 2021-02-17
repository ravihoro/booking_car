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
            _showBookingDialog(context);
          },
        ),
      ),
    );
  }

  void _showBookingDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("New Booking"),
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Origin',
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Destination',
                    ),
                  ),
                ],
              ),
            ),
          );
        });
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
