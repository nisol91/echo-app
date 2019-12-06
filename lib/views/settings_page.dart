import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// QUESTO FILE è SOLO UN ESPERIMENTO, NON è UFFICIALE
//NOTA: questa è una lista piu rudimentale e statica (senza stream) rispetto a corporate_list_view

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Firestore _firestore = Firestore.instance;
  @override
  void initState() {
    super.initState();
    Firestore.instance
        .collection('corporate')
        .snapshots()
        .listen((data) => data.documents.forEach((doc) => print(doc['name'])));
  }

  Future<QuerySnapshot> getAllDocuments() {
    return _firestore.collection('doggos').getDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Settings"),
      ),
      body: new MountainList(),
      // body: Text('data'),

      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () {
          Firestore.instance.collection('doggos').document().setData(
            {
              'name': 'Mount Nuovo II!!!!!',
              'description': 'neve',
            },
          );
        },
      ),
    );
  }
}

class MountainList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('doggos').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['name']),
                  subtitle: new Text(document['description']),
                );
              }).toList(),
            );
        }
      },
    );
  }
}