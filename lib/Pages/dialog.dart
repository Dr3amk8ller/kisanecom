class Item {
  final int id;
  final String name;
  final String color;
  final int price;
  final String desc;
  final String image;

  Item(
      {required this.id,
      required this.name,
      required this.color,
      required this.price,
      required this.desc,
      required this.image});

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
        id: map["id"],
        color: map["color"],
        desc: map["desc"],
        image: map["image"],
        name: map["name"],
        price: map["price"]);
  }

  toMap() => {
        "id": id,
        "name": name,
        "desc": desc,
        "color": color,
        "price": price,
        "image": image
      };
}

class CatalogModel {
  static List items = [];

  Item getById(int id) => items.firstWhere((element) => element.id == id);

  Item getByPosition(int pos) => items[pos];
}
