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
                children: [
                  CircleAvatar(
                    child: Text('NA'),
                    maxRadius: MediaQuery.of(context).size.width * 0.18,
                  ),
                  Text(
                    'Name: ${widget.driver.name}',
                  ),
                  Text(
                    'Email: ${widget.driver.email}',
                  ),
                  Text('Car Details'),
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
            // var customerEmail =
            //     context.read<AuthenticationBloc>().state.user.email;
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
            elevation: 10.0,
            child: Hero(
              tag: imageFiles[index],
              child: Container(
                height: MediaQuery.of(context).size.height * 0.01,
                width: MediaQuery.of(context).size.height * 0.2,
                //color: Colors.red,
                decoration: BoxDecoration(
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
