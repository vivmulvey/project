import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewExpenses extends StatefulWidget {
  ViewExpenses();

  @override
  _ViewExpensesState createState() => _ViewExpensesState();
}

class _ViewExpensesState extends State<ViewExpenses> {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  // final _firestore = FirebaseFirestore.instance;
  // var snapshot = FirebaseFirestore.instance.collection("expenses").get();
// snapshot.docs
  // var list = querySnapshot.documents;
// var items = _firestore.collection('expenses').get()
  @override
  Widget build(BuildContext context) {
    // CollectionReference expenses =
    //     FirebaseFirestore.instance.collection('expenses');

    final Stream<QuerySnapshot> _expensesStream =
        FirebaseFirestore.instance.collection('expenses').snapshots();

    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text('Expenses'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _expensesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return new ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return new ListTile(
                title: new Text(document.data()['vendor'] +
                    " - " +
                    document.data()['total']),
                subtitle: new Text(document.data()['email']),
              );
            }).toList(),
          );
          // if (snapshot.connectionState == ConnectionState.done) {
          //   Map<String, dynamic> data = snapshot.data.data();
          //   return Text("${data['vendor']} - ${data['price']}");
          // }

          // return Text("loading");
        },
      ),
    );
    // return FutureBuilder<DocumentSnapshot>(
    //   future: expenses.doc().get(),
    //   builder:
    //       (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //     if (snapshot.hasError) {
    //       return Text("Something went wrong");
    //     }

    //     if (snapshot.hasData && !snapshot.data.exists) {
    //       return Text("Document does not exist");
    //     }

    //     if (snapshot.connectionState == ConnectionState.done) {
    //       Map<String, dynamic> data = snapshot.data.data();
    //       return Text("${data['vendor']} - ${data['price']}");
    //     }

    //     return Text("loading");
    //   },
    // );
  }

  // @override
  // Widget build(BuildContext context) {

  // return Scaffold(
  //     key: _key,
  //     appBar: AppBar(
  //       backgroundColor: Colors.indigo[900],
  //       title: Text('Expenses'),
  //     ),
  //       body: snapshot.docs.length > 0 ? ListView(children: [
  //         for (var item in snapshot.docs) {
  //           ListTile(title: "${item['vendor']} - ${item['price']}", subtitle: item['email'],)
  //         }
  //       ],)
  // }

  // getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
  //   return snapshot.data.documents
  //       .map((doc) => new ListTile(
  //           title: new Text(doc["vendor"] + " - " + doc["total"]),
  //           subtitle: new Text(doc["email"])))
  //       .toList();
  // }
}
