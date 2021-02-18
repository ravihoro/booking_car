import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:math';

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
  String _error = "No error detected";
  File _image;

  List<Asset> images = List<Asset>();

  Widget buildGridView() {
    return GridView.count(
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
      crossAxisCount: 3,
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

  void _upload() {
    var random = Random();
    images.forEach((image) async {
      ByteData data = await image.getByteData();
      _image = await writeToFile(data);
      print(DateTime.now().toIso8601String());
      var stream =
          new http.ByteStream(DelegatingStream.typed(_image.openRead()));
      var length = await _image.length();
      var uri = Uri.parse("http://192.168.0.6:3000/upload");
      var request = new http.MultipartRequest("POST", uri);
      String filename =
          widget.email + "${random.nextInt(100)}" + basename(_image.path);
      var multipartFile =
          new http.MultipartFile('image', stream, length, filename: filename);
      request.files.add(multipartFile);
      var response = await request.send();
      response.stream.transform(Utf8Decoder()).listen((value) {
        print(value);
      });
    });
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
              RaisedButton(
                child: Text('Upload'),
                onPressed: () {
                  _upload();
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50.0,
        child: RaisedButton(
          child: Text("Add", style: TextStyle(color: Colors.white)),
          color: Colors.blue,
          onPressed: () {
            _add();
          },
        ),
      ),
    );
  }

  void _add() async {
    await _upload();
  }
}
