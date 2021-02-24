import 'package:booking_car/pages/driver/add_car_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:db_repository/db_repository.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CarDetails extends StatefulWidget {
  final String email;

  CarDetails({this.email});

  @override
  _CarDetailsState createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  var dbRepository;
  var carData;

  TextStyle style = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );

  @override
  void initState() {
    super.initState();
    dbRepository = Provider.of<DbRepository>(context, listen: false);
    carData = dbRepository.getCarDetails(email: widget.email.trim());
  }

  Future<List<File>> getImages(List<dynamic> imageFileNames) async {
    List<File> imageFiles = List<File>();
    if (carData == null) return null;
    for (int i = 0; i < imageFileNames.length; i++) {
      File tempFile = await getImageFile(imageFileNames[i].toString());
      imageFiles.add(tempFile);
    }
    return imageFiles;
  }

  Future<File> getImageFile(String filename) async {
    var response = await dbRepository.getImage(filename);
    if (response.statusCode == 200) {
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      File file = new File('$tempPath/$filename.jpg');
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } else {
      return null;
    }
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
                    },
                  ),
                ],
              ),
            );
          } else {
            //print(data['images']);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Car Name: ${data["name"]}',
                    style: style,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Registration No. : ${data["reg_no"]}',
                    style: style,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Car Images: ",
                    style: style,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                    future: getImages(data['images']),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) return Text("Error");
                      return Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 2,
                                  crossAxisSpacing: 2),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 300,
                              width: 300,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(snapshot.data[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
