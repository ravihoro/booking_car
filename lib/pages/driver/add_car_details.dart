import 'dart:typed_data';
import 'package:booking_car/pages/driver/car_details.dart';
import 'package:db_repository/db_repository.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:math';
import 'package:provider/provider.dart';

class AddCarDetails extends StatefulWidget {
  final String email;

  AddCarDetails({this.email});

  @override
  _AddCarDetailsState createState() => _AddCarDetailsState();
}

class _AddCarDetailsState extends State<AddCarDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _nameController = TextEditingController();
  var _regNoController = TextEditingController();
  List<String> imageFileNames = List<String>();
  File _image;

  @override
  void initState() {
    super.initState();
    imageFileNames = List<String>();
  }

  List<Asset> images = List<Asset>();

  Widget buildGridView() {
    return GridView.builder(
      itemCount: images.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      },
    );
  }

  Future<void> loadImages() async {
    List<Asset> resultList = List<Asset>();
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: false,
        selectedAssets: images,
      );
    } on Exception catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      images = resultList;
    });
  }

  Future<File> writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = tempPath + '/file.jpg';
    return new File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<bool> _uploadImages() async {
    var random = Random();
    for (int i = 0; i < images.length; i++) {
      int statusCode = await _upload(images[i], random.nextInt(100));
      if (statusCode != 200) return false;
    }
    return true;
  }

  Future<int> _upload(Asset image, int random) async {
    ByteData data = await image.getByteData();
    _image = await writeToFile(data);
    var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
    var length = await _image.length();
    var uri = Uri.parse("http://192.168.0.6:3000/upload");
    var request = new http.MultipartRequest("POST", uri);
    String filename = widget.email + "$random" + basename(_image.path);
    imageFileNames.add(filename);
    var multipartFile =
        new http.MultipartFile('image', stream, length, filename: filename);
    request.files.add(multipartFile);
    var response = await request.send();
    response.stream.transform(Utf8Decoder()).listen((value) {
      print(value);
    });
    return response.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Car Details',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == "") {
                    return "Please enter car name";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Car Name',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _regNoController,
                validator: (value) {
                  if (value == "") {
                    return "Please enter registration number";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Registration Number',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Add Car Images:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              IconButton(
                icon: Icon(Icons.add, size: 30),
                onPressed: () {
                  loadImages();
                },
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                child: buildGridView(),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Builder(
        builder: (context) {
          return Container(
            height: 50.0,
            child: RaisedButton(
              child: Text("Add", style: TextStyle(color: Colors.white)),
              color: Colors.blue,
              onPressed: () {
                _add(context);
              },
            ),
          );
        },
      ),
    );
  }

  void _add(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      bool val = await _uploadImages();
      print("Value of val is: $val. Starting to save now");
      if (val) {
        var dbRepository = Provider.of<DbRepository>(context, listen: false);
        bool saved = await dbRepository.saveCarDetails(
          name: _nameController.text,
          email: widget.email,
          regNo: _regNoController.text,
          imageFileNames: imageFileNames,
        );
        imageFileNames = [];
        if (saved) {
          Navigator.of(context).pop();
          //Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => CarDetails(email: widget.email)));
          print("Data saved");
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Car details saving unsuccessful"),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        print("Upload failed");
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Upload failed"),
          backgroundColor: Colors.red,
        ));
      }
    }
  }
}
