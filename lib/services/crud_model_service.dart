import 'dart:async';
import 'package:flutter/material.dart';
import '../locator.dart';
import '../services/api_crud.dart';
import '../models/service_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//CRUD PER LE CORPORATE
class CrudModelServices extends ChangeNotifier {
  Api _api = locator<Api>();

  List<Service> services;

  Future<List<Service>> fetchServices() async {
    var result = await _api.getDataCollection();
    services = result.documents
        .map((doc) => Service.fromMap(doc.data, doc.documentID))
        .toList();
    return services;
  }

  Stream<QuerySnapshot> fetchServicesAsStream() {
    return _api.streamDataCollection();
  }

  Future<Service> getServiceById(String id) async {
    var doc = await _api.getDocumentById(id);
    return Service.fromMap(doc.data, doc.documentID);
  }

  Future removeService(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future updateService(Service data, String id) async {
    await _api.updateDocument(data.toJson(), id);
    return;
  }

  Future addService(Service data) async {
    var result = await _api.addDocument(data.toJson());

    return;
  }
}
