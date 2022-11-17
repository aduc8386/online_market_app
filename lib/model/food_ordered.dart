import 'food.dart';

class FoodOrdered {
  late Food food;
  late int quantity;

  FoodOrdered(this.food, this.quantity);

  FoodOrdered.fromFirebaseResponse(Map<String, dynamic> response) {
    food = Food.fromFirebaseResponse(response["food"]);
    quantity = response["quantity"];
  }

  FoodOrdered.fromJson(Map<String, dynamic> json) {
    food = Food.fromJson(json["food"]);
    quantity = json["quantity"];
  }

  Map<String, dynamic> toJson() {
    return {
      "food": food,
      "quantity": quantity,
    };
  }

  static List<Map<String, dynamic>> convertToJsonList(List<FoodOrdered> foodsOrdered) {
    List<Map<String, dynamic>> map = [];
    for (var foodOrdered in foodsOrdered) {
      Map<String, dynamic> foodOrderedJson = foodOrdered.toJson();
      map.add(foodOrderedJson);
    }
    return map;
  }
}
