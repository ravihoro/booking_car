import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String name;
  final String origin;
  final String destination;
  final DateTime date;
  final Function accept;
  final Function reject;
  final Function cancel;

  CustomCard({
    this.name,
    this.origin,
    this.destination,
    this.date,
    this.accept,
    this.reject,
    this.cancel,
  });

  final TextStyle style = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w300,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        elevation: 10,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(colors: [
              Colors.deepPurpleAccent,
              Colors.purple,
            ], begin: Alignment.centerLeft, end: Alignment.centerRight),
            //color: colors[random.nextInt(10)],
          ),
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CircleAvatar(
                maxRadius: 50,
                backgroundColor: Colors.amber,
                child: Text('A'),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: $name',
                    style: style,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    'Origin: $origin',
                    style: style,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    'Destination: $destination',
                    style: style,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    'Date: ${date.toString().substring(0, 10)}',
                    style: style,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      accept != null
                          ? RaisedButton(
                              color: Colors.blue,
                              child: Text('Accept',
                                  style: TextStyle(color: Colors.white)),
                              onPressed: accept,
                            )
                          : Container(),
                      SizedBox(
                        width: 50,
                      ),
                      reject != null
                          ? RaisedButton(
                              child: Text('Reject',
                                  style: TextStyle(color: Colors.white)),
                              color: Colors.red,
                              onPressed: reject,
                            )
                          : Container(),
                    ],
                  ),
                  cancel == null
                      ? Container()
                      : RaisedButton(
                          child: Text('Cancel',
                              style: TextStyle(color: Colors.white)),
                          color: Colors.red,
                          onPressed: cancel,
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
