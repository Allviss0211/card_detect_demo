import 'dart:io';
import 'dart:typed_data';

import 'package:edge_detection/edge_detection.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var string = "";
  File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Future getImage(int key) async {
      var detectFile;
      var pickedFile;
      if (key == 1)
        pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (key == 2)
         pickedFile = await picker.getImage(source: ImageSource.camera);
//      {
//        try {
//          detectFile = await EdgeDetection.detectEdge;
//        } on PlatformException {
//          print("Failed to get cropped image path.");
//        }
//      }
      setState(() {
//        _image = File(detectFile);
        _image = File(pickedFile.path);
      });

      final text = await TesseractOcr.extractText(pickedFile.path,
          language: "vie");
      if (mounted) {
        setState(() {
          string = text;
        });
      }
    }

    Widget imagePicker = Container();
    if (_image != null) {
      print("Đã có hình");
      imagePicker = Container(
        child: Image.file(
          _image,
        ),
      );
    }

    Widget faceImage = Container();
    if (string != null) {
      faceImage = Column(
        children: <Widget>[
          Text(string),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Text Image Picker"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: RaisedButton(
                      child: Text("Chọn hình"),
                      onPressed: () => getImage(1),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: RaisedButton(
                      child: Text("Chụp hình"),
                      onPressed: () => getImage(2),
                    ),
                  ),
                ],
              ),
              imagePicker,
              faceImage
            ],
          ),
        ),
      ),
    );
  }
}
