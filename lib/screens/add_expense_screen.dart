import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'details.dart';
import 'login_screen.dart';

class AddExpenseScreen extends StatefulWidget {
  static const String id = 'add_expense_screen';
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final User user = FirebaseAuth.instance.currentUser;
  String expense;

  // FirebaseUser loggedInUser;
  // final FirebaseAuth auth = FirebaseAuth.instance;

  User loggedInUser;

  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() {
    if (user != null) {
      print(" logged in");
    } else {
      print("not logged in");
    }
    // try {
    //   final User user = await _auth.currentUser;
    //   if (user != null) {
    //     loggedInUser = user;
    //     print(loggedInUser.email);
    //   }
    // } catch (e) {
    //   print(e);
    // }
  }

  String _text = '';
  PickedFile _image;
  Map parsedData = Map();

  bool checkStringForPrice(string) {
    // [0-9]{2}:[0-9]{2} [A-Z]{2}
    var re = RegExp('[0-9]{2}.[0-9]{2}');

    var match = re.stringMatch(string);

    if (match != null) {
      match.toString();
      setState(() => {parsedData["Total"] = match.toString()});
      return true;
    }

    return false;
  }

  bool checkStringForDate(string) {
    var re = RegExp(
      r'^'
      r'(?<year>[0-9]{4,})'
      r'/'
      r'(?<month>[0-9]{1,2})'
      r'/'
      r'(?<day>[0-9]{1,2})'
      r' '
      r'(?<timeHour>[0-9]{2})'
      r':'
      r'(?<timeMin>[0-9]{2})'
      r' '
      r'(?<timeAM>[A-Z]M)'
      r'$',
    );

    var match = re.firstMatch(string);
    if (match != null) {
      var hour = int.parse(match.namedGroup('timeHour'));

      if (match.namedGroup('timeAM') == "AM") {
        hour += 12;
      }

      var dateTime = DateTime(
        int.parse(match.namedGroup('year')),
        int.parse(match.namedGroup('month')),
        int.parse(match.namedGroup('day')),
        hour,
        int.parse(match.namedGroup('timeMin')),
      );
      print(dateTime);

      setState(() => {parsedData["Date"] = dateTime.toString()});

      return true;
    }

    return false;
  }

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text('Add Expense'),
        actions: <Widget>[
          FlatButton(
            onPressed: scanText,
            child: Text(
              'Scan',
              style: TextStyle(color: Colors.white),
            ),
          ),
          FlatButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
              print(loggedInUser);
            },
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        child: Icon(Icons.add_a_photo),
        backgroundColor: Colors.indigo[900],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: _image != null
            ? Image.file(
                File(_image.path),
                fit: BoxFit.fitWidth,
              )
            : Container(),
      ),
    );
  }

  Future scanText() async {
    showDialog(
        context: context,
        child: Center(
          child: CircularProgressIndicator(),
        ));
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(File(_image.path));
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();
    final VisionText visionText =
        await textRecognizer.processImage(visionImage);

    // print(visionText.blocks);
    // var i = 0;
    setState(() => {parsedData["Vendor:"] = visionText.blocks[0].text});
    checkStringForDate(visionText.blocks[6].text);
    // setState(() => {parsedData["Vendor"] = visionText.blocks[6].text});
    for (var i = 0; i < visionText.blocks.length; i++) {
      if (visionText.blocks[i].text == "Total") {
        checkStringForPrice(visionText.blocks[i + 1].text);
      }
    }

    // for (TextBlock block in visionText.blocks) {
    //   // print(block.lines[i]);
    //   // i++;
    //   if (block.text == "Total") {
    //     setState(() => {

    //     })
    //   }

    //   print(block.lines[0].text);

    //   for (TextLine line in block.lines) {
    //     if (checkStringForDate(line.text)) return;
    //     // if (checkStringForTime(line.text)) return;

    //     _text += line.text + '\n';
    //   }
    // }

    Navigator.of(context).pop();
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Details(_text, parsedData)));
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
      } else {
        print('No image selected');
      }
    });
  }
}
