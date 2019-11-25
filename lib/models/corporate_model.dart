class Corporate {
  String id;
  String description;
  String name;
  String img;

  Corporate({this.id, this.description, this.name, this.img});

  Corporate.fromMap(Map snapshot, String id)
      : id = id ?? '',
        description = snapshot['description'] ?? '',
        name = snapshot['name'] ?? '',
        img = snapshot['img'] ?? '';

  toJson() {
    return {
      "description": description,
      "name": name,
      "img": img,
    };
  }
}
