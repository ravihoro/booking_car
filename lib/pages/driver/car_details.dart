import 'package:booking_car/pages/driver/add_car_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:db_repository/db_repository.dart';

class CarDetails extends StatefulWidget {
  final String email;

  CarDetails({this.email});

  @override
  _CarDetailsState createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _nameController = TextEditingController();
  var _regNoController = TextEditingController();
  var dbRepository;
  var carData;

  // Future getCarDetails(String email) async {
  //   print("Car details function");
  //   var carData = await dbRepository.getCarDetails(name: email.trim());
  //   return carData;
  // }

  @override
  void initState() {
    super.initState();
    dbRepository = Provider.of<DbRepository>(context, listen: false);
    carData = dbRepository.getCarDetails(email: widget.email.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Details'),
      ),
      body: FutureBuilder(
        future: carData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error fetching car details',
              ),
            );
          }
          var data = snapshot.data;

          if (data.length == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No car data found. Please add car data',
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RaisedButton(
                    child:
                        Text('Add Car', style: TextStyle(color: Colors.white)),
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddCarDetails(
                                email: widget.email,
                              )));
                      //_showAddCarDetailsDialog(context);
                    },
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                children: [
                  Text('Car Name: ${data["name"]}'),
                  Text('Registration No. : ${data["reg_no"]}'),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _showAddCarDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Car Details"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Car Model',
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: _regNoController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Registration Number',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            RaisedButton(
              child: Text("Add"),
              onPressed: () async {
                String name = _nameController.text;
                String regNo = _regNoController.text;
                // bool isSaved = false;
                bool isSaved = await dbRepository.saveCarDetails(
                    name: name, email: widget.email, regNo: regNo);
                Navigator.of(context).pop();
                if (!isSaved) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content:
                        Text("Error saving car details. Please try again."),
                    backgroundColor: Colors.red,
                  ));
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Car details saved."),
                    backgroundColor: Colors.blue,
                  ));
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => CarDetails(
                            email: widget.email,
                          )));
                }
              },
            ),
            RaisedButton(
              child: Text("Cancel"),
              onPressed: () {
                _nameController.text = "";
                _regNoController.text = "";
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
