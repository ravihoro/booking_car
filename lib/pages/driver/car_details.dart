import 'package:booking_car/pages/driver/add_car_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:db_repository/db_repository.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarDetails extends StatefulWidget {
  final String email;

  CarDetails({this.email});

  @override
  _CarDetailsState createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  var dbRepository;
  var carData;

  final PageController pageController =
      PageController(initialPage: 0, viewportFraction: 0.8);

  TextStyle style = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );

  imageSlider(int index, List<dynamic> imageFiles) {
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, widget) {
        double value = 1;
        if (pageController.position.haveDimensions) {
          value = pageController.page - index;
          value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            //height: Curves.easeInOut.transform(value) * 500,
            //width: Curves.easeInOut.transform(value) * 400,
            child: widget,
          ),
        );
      },
      child: Card(
        elevation: 10.0,
        child: Container(
          margin: const EdgeInsets.all(5.0),
          child: Image.file(
            imageFiles[index],
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget customImageSlider(BuildContext context, List<dynamic> imageFiles) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: pageController,
            itemCount: imageFiles.length,
            itemBuilder: (context, index) {
              return imageSlider(index, imageFiles);
            },
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          child: SmoothPageIndicator(
            count: imageFiles.length,
            controller: pageController,
            effect: WormEffect(
              activeDotColor: Theme.of(context).accentColor,
              dotColor: Colors.grey,
              dotWidth: 10.0,
              dotHeight: 10.0,
            ),
          ),
        ),
      ],
    );
  }

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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: getImages(data['images']),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) return Text("Error");
                    return Container(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      color: Colors.grey[300],
                      height: 400,
                      width: MediaQuery.of(context).size.width,
                      child: customImageSlider(context, snapshot.data),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Car Details',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '\u2022 Car Name',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '   ${data["name"]}',
                        style: style,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '\u2022 Registration No. ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '  ${data["reg_no"]}',
                        style: style,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
