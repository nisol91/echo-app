import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/corporate_model.dart';
import '../viewmodels/crud_model_corporate.dart';
import 'package:provider/provider.dart';
import '../widgets/corporate_card.dart';

class CorporateListView extends StatefulWidget {
  @override
  _CorporateListViewState createState() => _CorporateListViewState();
}

class _CorporateListViewState extends State<CorporateListView> {
  List<Corporate> corporates;

  @override
  Widget build(BuildContext context) {
    final corporateProvider = Provider.of<CrudModel>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addProduct');
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Center(child: Text('Corporate View II')),
      ),
      body: Container(
        child: StreamBuilder(
            stream: corporateProvider.fetchCorporatesAsStream(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                corporates = snapshot.data.documents
                    .map((doc) => Corporate.fromMap(doc.data, doc.documentID))
                    .toList();
                print('cristoddio');
                print(corporates);

                return ListView.builder(
                  itemCount: corporates.length,
                  itemBuilder: (buildContext, index) =>
                      CorporateCard(corporateDetails: corporates[index]),
                );
              } else {
                return Text('fetching');
              }
            }),
      ),
    );
    ;
  }
}
