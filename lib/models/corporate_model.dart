import 'package:cloud_firestore/cloud_firestore.dart';

class Corporate {
  String id;
  String description;
  String name;
  String img;
  Timestamp creationDate;

  Corporate(
      {this.id, this.description, this.name, this.img, this.creationDate});

  Corporate.fromMap(Map snapshot, String id)
      : id = id ?? '',
        description = snapshot['description'] ?? '',
        name = snapshot['name'] ?? '',
        img = snapshot['img'] ?? '',
        creationDate = snapshot['creationDate'];

  toJson() {
    return {
      "description": description,
      "name": name,
      "img": img,
      "creationDate": creationDate,
    };
  }
}
