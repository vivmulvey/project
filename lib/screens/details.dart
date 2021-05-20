
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final String text;
  final Map parsedData;
  Details(this.text, this.parsedData);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
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
          child: Column(children: [
            for (var k in widget.parsedData.keys)
              Text('$k ${widget.parsedData[k]}'),

            ElevatedButton(
              child: const Text("Save"),
              onPressed: () => {
                print("save");
              }
            )
            // SelectableText(
            //     widget.text.isEmpty ? 'No Text Available' : widget.text),
          ],)),
    );
  }
}
