import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../app_state_container.dart';
import '../models/corporate_model.dart';
import '../viewmodels/crud_model_corporate.dart';
import 'package:provider/provider.dart';
import '../widgets/corporate_card.dart';
import 'package:flushbar/flushbar.dart';

class CorporateListView extends StatefulWidget {
  @override
  _CorporateListViewState createState() => _CorporateListViewState();
}

class _CorporateListViewState extends State<CorporateListView> {
  List<Corporate> corporates;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);

    final corporateProvider = Provider.of<CrudModel>(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/addCorporate');
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Center(child: Text('Corporate View II')),
        ),
        body: Container(
          height: 200,
          padding: EdgeInsets.all(10),
          child: StreamBuilder(
              stream: corporateProvider.fetchCorporatesAsStream(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (container.areYouAdmin == false) {
                  print('non sei admin');
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                            'devi essere admin per poter accedere a questa pagina'),
                      ],
                    ),
                  );
                } else {
                  if (snapshot.hasData) {
                    print('fatto');

                    corporates = snapshot.data.documents
                        .map((doc) =>
                            Corporate.fromMap(doc.data, doc.documentID))
                        .toList();
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: corporates.length,
                      itemBuilder: (buildContext, index) =>
                          CorporateCard(corporateDetails: corporates[index]),
                    );
                  } else {
                    print('loading');

                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[CircularProgressIndicator()],
                      ),
                    );
                  }
                }
              }),
        ));
    ;
  }
}
