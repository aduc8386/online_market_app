import 'package:uuid/uuid.dart';

class Food {
  late String fid;
  late String name;
  String? desc;
  late String imageUrl;
  late bool isLiked = false;
  String? category;
  late double price;

  Food(
      {required this.fid,
      required this.name,
      this.desc,
      required this.imageUrl,
      required this.isLiked,
      this.category,
      required this.price});

  Food.fromFirebaseResponse(Map<String, dynamic> response) {
    fid = response["fid"];
    name = response["name"];
    imageUrl = response["image_url"];
    isLiked = response["is_liked"];
    price = double.parse(response["price"].toString());
    desc = response["description"];
    category = response["category"];
  }

  Food.fromJson(Map<String, dynamic> json) {
    fid = json["fid"];
    name = json["name"];
    imageUrl = json["image_url"];
    isLiked = json["is_liked"];
    price = double.parse(json["price"].toString());
    desc = json["description"];
    category = json["category"];
  }

  Map<String, dynamic> toJson() {
    return {
      "fid": fid,
      "name": name,
      "image_url": imageUrl,
      "is_liked": isLiked,
      "price": price,
      "description": desc,
      "category": category,
    };
  }

  static List<Map<String, dynamic>> convertToJsonList(List<Food> foods) {
    List<Map<String, dynamic>> map = [];
    for (var food in foods) {
      Map<String, dynamic> foodJson = food.toJson();
      map.add(foodJson);
    }
    return map;
  }
}
