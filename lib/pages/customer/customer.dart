import 'package:booking_car/widgets/driver_search.dart';
import 'package:flutter/material.dart';

class Customer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.amber,
            onPressed: () {
              showSearch(context: context, delegate: DriverSearch());
            },
          ),
        ],
      ),
    );
  }
}
