import 'dart:io';

import 'package:edge_detection/edge_detection.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

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
      var textDetect = FirebaseVision.instance.textRecognizer();
      if (key == 1)
        pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (key == 2)
        pickedFile = await picker.getImage(source: ImageSource.camera);
      if (key == 3) {
        try {
          detectFile = await EdgeDetection.detectEdge;
        } on PlatformException {
          print("Failed to get cropped image path.");
        }
      }
      setState(() {
        if (detectFile != null) {
          _image = File(detectFile);
        } else {
          _image = File(pickedFile.path);
        }
      });
      var image = FirebaseVisionImage.fromFile(_image);
      final text =  await textDetect.processImage(image);
//      if (detectFile != null)
//        text = await TesseractOcr.extractText(detectFile, language: "eng");
//      else
//        text = await TesseractOcr.extractText(pickedFile.path, language: "eng");
      if (mounted) {
        setState(() {
          string = text.text;
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
                mainAxisAlignment: MainAxisAlignment.center,
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
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: RaisedButton(
                      child: Text("Scan hình"),
                      onPressed: () => getImage(3),
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
