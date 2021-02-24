import 'package:flutter/material.dart';
import 'dart:io';

class ImageScreen extends StatefulWidget {
  final List<File> imageFiles;
  final int currentIndex;
  ImageScreen({this.imageFiles, this.currentIndex});

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  ScrollController scrollController;
  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: widget.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: List.generate(widget.imageFiles.length, (index) {
          return Hero(
            tag: widget.imageFiles[index],
            child: InteractiveViewer(
              child: Center(
                child: Image.file(
                  widget.imageFiles[index],
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
