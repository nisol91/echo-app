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
  String email = '';
  bool areYouAdmin = false;

  @override
  initState() {
    super.initState();
    getUser();
  }

  Future<bool> getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      email = user.email;

      new Future.delayed(new Duration(milliseconds: 10), () {
        Firestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .getDocuments()
            .then((doc) {
          if (doc.documents[0]['role'] == 'admin') {
            print('true');
            if (!mounted) {
              return false;
            }
            setState(() {
              areYouAdmin = true;
            });
            return true;
          } else {
            print('false');

            return false;
          }
        });
      });
    } else {
      print('false');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: (areYouAdmin == true)
          ? Container(
              height: 200,
              padding: EdgeInsets.all(10),
              child: StreamBuilder(
                  stream: corporateProvider.fetchCorporatesAsStream(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
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
                      return Text('fetching');
                    }
                  }),
            )
          : Container(
              child: Column(
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text('devi essere admin per poter accedere a questa pagina'),
                ],
              ),
            ),
    );
    ;
  }
}
