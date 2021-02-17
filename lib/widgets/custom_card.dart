import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String name;
  final String location;
  final DateTime date;
  final DateTime time;
  final Function accept;
  final Function reject;

  CustomCard(
      {this.name,
      this.location,
      this.date,
      this.time,
      this.accept,
      this.reject});

  TextStyle style = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        color: Colors.grey[400],
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Name: $name',
              style: style,
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'Location: $location',
              style: style,
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'Date: $date',
              style: style,
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'Time: $time',
              style: style,
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                accept != null
                    ? RaisedButton(
                        child: Text('Accept'),
                        onPressed: accept,
                      )
                    : Container(),
                reject != null
                    ? RaisedButton(
                        child: Text('Reject'),
                        color: Colors.red,
                        onPressed: reject,
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
