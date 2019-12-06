import 'package:cloud_firestore/cloud_firestore.dart';

class Corporate {
  String id;
  String name;
  String description;
  String address;
  String img;
  String corporateType;
  bool featured;
  Timestamp creationDate;

  Corporate({
    this.id,
    this.name,
    this.description,
    this.address,
    this.img,
    this.corporateType,
    this.featured,
    this.creationDate,
  });

  Corporate.fromMap(Map snapshot, String id)
      : id = id ?? '',
        name = snapshot['name'] ?? '',
        description = snapshot['description'] ?? '',
        address = snapshot['address'] ?? '',
        img = snapshot['img'] ?? '',
        corporateType = snapshot['corporateType'] ?? '',
        featured = snapshot['featured'],
        creationDate = snapshot['creationDate'];

  toJson() {
    return {
      "name": name,
      "description": description,
      "address": address,
      "img": img,
      "corporateType": corporateType,
      "featured": featured,
      "creationDate": creationDate,
    };
  }
}
