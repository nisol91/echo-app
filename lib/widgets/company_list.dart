import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../app_state_container.dart';
import '../models/company_model.dart';
import '../services/crud_model_company.dart';
import 'package:provider/provider.dart';
import '../widgets/company_card.dart';

class CompanyList extends StatefulWidget {
  bool filter;

  @override
  _CompanyListState createState() => _CompanyListState();
}

class _CompanyListState extends State<CompanyList> {
  List<Company> companies;

  @override
  initState() {
    super.initState();
  }

  void orderAlfa() {
    print('sorting...');
    Firestore.instance
        .collection("companies")
        .orderBy('name', descending: false)
        .getDocuments()
        .then((doc) {
      print('OKOKOKOKOKOK');
    });
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);

    final companyProvider = Provider.of<CrudModelCompany>(context);
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      padding: EdgeInsets.all(1),
      child: StreamBuilder(
          stream: companyProvider.fetchCompaniesAsStream(),
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

                companies = snapshot.data.documents
                    .map((doc) => Company.fromMap(doc.data, doc.documentID))
                    .toList();
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: companies.length,
                  itemBuilder: (buildContext, index) =>
                      CompanyCard(companyDetails: companies[index]),
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
    );
  }
}
