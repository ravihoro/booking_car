import 'package:booking_car/pages/customer/image_screen.dart';
import 'package:booking_car/pages/customer/make_booking.dart';
import 'package:flutter/material.dart';
import 'package:db_repository/db_repository.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DriverDetails extends StatefulWidget {
  final Driver driver;

  DriverDetails({this.driver});

  @override
  _DriverDetailsState createState() => _DriverDetailsState();
}

class _DriverDetailsState extends State<DriverDetails> {
  var dbRepository;
  var carData;

  @override
  void initState() {
    super.initState();
    dbRepository = Provider.of<DbRepository>(context, listen: false);
    carData = dbRepository.getCarDetails(email: widget.driver.email.trim());
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
        title: Text("Driver Details"),
      ),
      body: FutureBuilder(
        future: carData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        child: Text('NA'),
                        backgroundColor: Colors.amber,
                        maxRadius: MediaQuery.of(context).size.width * 0.18,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${widget.driver.name}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            'Email: ${widget.driver.email}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Vehicle Details',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RichText(
                    text: TextSpan(
                        text: '\u2022 Vehicle Name: ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: '${snapshot.data['name']}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            ),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RichText(
                    text: TextSpan(
                        text: '\u2022 Registration No. : ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: '${snapshot.data['reg_no']}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            ),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RichText(
                    text: TextSpan(
                      text: '\u2022 Vehicle Photos : ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  FutureBuilder(
                    future: getImages(snapshot.data['images']),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      return SizedBox(
                        height: 200,
                        child: carDetails(snapshot.data),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
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
            var driverEmail = widget.driver.email;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MakeBooking(
                      driverName: widget.driver.name,
                      driverEmail: driverEmail,
                    )));
          },
        ),
      ),
    );
  }

  Widget carDetails(List<File> imageFiles) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: imageFiles.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Card(
            //elevation: 20.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Hero(
              tag: imageFiles[index],
              child: Container(
                height: MediaQuery.of(context).size.height * 0.01,
                width: MediaQuery.of(context).size.height * 0.2,
                //color: Colors.red,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1.0,
                    color: Colors.black,
                    //style: BorderStyle.solid,
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(
                      imageFiles[index],
                    ),
                  ),
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ImageScreen(
                      imageFiles: imageFiles,
                      currentIndex: index,
                    )));
          },
        );
      },
    );
  }
}
