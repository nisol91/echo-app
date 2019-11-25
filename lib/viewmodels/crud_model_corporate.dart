import 'dart:async';
import 'package:flutter/material.dart';
import '../locator.dart';
import '../services/api_crud.dart';
import '../models/corporate_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrudModel extends ChangeNotifier {
  Api _api = locator<Api>();

  List<Corporate> corporates;

  Future<List<Corporate>> fetchCorporates() async {
    var result = await _api.getDataCollection();
    corporates = result.documents
        .map((doc) => Corporate.fromMap(doc.data, doc.documentID))
        .toList();
    return corporates;
  }

  Stream<QuerySnapshot> fetchCorporatesAsStream() {
    return _api.streamDataCollection();
  }

  Future<Corporate> getCorporateById(String id) async {
    var doc = await _api.getDocumentById(id);
    return Corporate.fromMap(doc.data, doc.documentID);
  }

  Future removeCorporate(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future updateCorporate(Corporate data, String id) async {
    await _api.updateDocument(data.toJson(), id);
    return;
  }

  Future addCorporate(Corporate data) async {
    var result = await _api.addDocument(data.toJson());

    return;
  }
}
