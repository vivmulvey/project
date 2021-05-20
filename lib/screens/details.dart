import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:text_recognition_project/screens/view_expenses_screen.dart';

class Details extends StatefulWidget {
  final String text;
  final Map parsedData;
  Details(this.text, this.parsedData);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text('Receipt Details'),
      ),
      body: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              for (var k in widget.parsedData.keys)
                Text('$k: ${widget.parsedData[k]}'),

              ElevatedButton(
                  child: const Text("Save"),
                  onPressed: () => {
                        print("save"),
                        _firestore.collection('expenses').add({
                          "date": widget.parsedData["Date"],
                          "vendor": widget.parsedData["Vendor"],
                          "total": widget.parsedData["Total"],
                          "email": _auth.currentUser.email
                        }).then((value) => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ViewExpenses())))
                      })
              // SelectableText(
              //     widget.text.isEmpty ? 'No Text Available' : widget.text),
            ],
          )),
    );
  }
}
