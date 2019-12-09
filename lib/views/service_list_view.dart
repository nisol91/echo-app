import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../app_state_container.dart';
import '../models/service_model.dart';
import '../services/crud_model_service.dart';
import 'package:provider/provider.dart';
import '../widgets/service_card.dart';

class ServiceListView extends StatelessWidget {
//   @override
//   _ServiceListViewState createState() => _ServiceListViewState();
// }

// class _ServiceListViewState extends State<ServiceListView> {
  List<Service> services;
  List<Service> selectedServices = [];

  String companyId;

  ServiceListView({@required this.companyId});

  // @override
  // initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);

    final serviceProvider = Provider.of<CrudModelService>(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      padding: EdgeInsets.all(1),
      child: StreamBuilder(
          stream: serviceProvider.fetchServicesAsStream(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              print('fatto');

              services = snapshot.data.documents
                  .map((doc) => Service.fromMap(doc.data, doc.documentID))
                  .toList();

              print(services);

              //filtro veramente rudimentale ma fa quello che deve:
              //filtro i servizi per company, ogni servizio ha un company id,
              // se combacia allora lo faccio apparire nella lista
              //di quella company.
              // for (var i = 0; i < services.length; i++) {
              //   if (services[i].companyId == companyId) {
              //     selectedServices..add(services[i]);
              //   }
              // }
              //sono riuscito a migliorare il filtro usando where!!!!ora funziona
              selectedServices = services
                  .where((doc) => (doc.companyId == companyId))
                  .toList();
              print('===================');
              print(selectedServices);

              print('===================');

              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: selectedServices.length,
                  itemBuilder: (buildContext, index) {
                    return ServiceCard(serviceDetails: selectedServices[index]);
                  });
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
          }),
    );
    ;
  }
}