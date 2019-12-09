import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../app_state_container.dart';
import '../models/company_model.dart';
import '../services/crud_model_company.dart';
import 'package:provider/provider.dart';
import '../widgets/company_card.dart';

class CompanyListView extends StatefulWidget {
  @override
  _CompanyListViewState createState() => _CompanyListViewState();
}

class _CompanyListViewState extends State<CompanyListView> {
  List<Company> companies;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);

    final companyProvider = Provider.of<CrudModelCompany>(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/addCompany');
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Center(child: Text('Admin Dashboard')),
        ),
        body: Container(
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
        ));
    ;
  }
}
