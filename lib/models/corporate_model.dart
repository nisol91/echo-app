import 'package:cloud_firestore/cloud_firestore.dart';

class Corporate {
  String id;
  String description;
  String name;
  String img;
  Timestamp creationDate;
  bool featured;

  Corporate(
      {this.id,
      this.description,
      this.name,
      this.img,
      this.creationDate,
      this.featured});

  Corporate.fromMap(Map snapshot, String id)
      : id = id ?? '',
        description = snapshot['description'] ?? '',
        name = snapshot['name'] ?? '',
        img = snapshot['img'] ?? '',
        creationDate = snapshot['creationDate'],
        featured = snapshot['featured'] ?? false;

  toJson() {
    return {
      "description": description,
      "name": name,
      "img": img,
      "creationDate": creationDate,
      "featured": featured,
    };
  }
}
