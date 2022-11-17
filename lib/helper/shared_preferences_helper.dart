import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/cart.dart';
import '../model/food_ordered.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _instance;

  static Future init() async {
    _instance = await SharedPreferences.getInstance();
  }

  static Future setTotalCost(double totalCost) async {
    await _instance?.setDouble("total_cost", totalCost);
  }

  static double getTotalCost() {
    return _instance?.getDouble("total_cost") ?? 0;
  }

  static Future setFoodsOrdered(List<FoodOrdered> foodsOrdered) async {

    var jsonFoodsOrdered = jsonEncode(foodsOrdered.map((e) => e.toJson()).toList());
    await _instance?.setString("foods_ordered", jsonFoodsOrdered);

  }

  static List<FoodOrdered> getFoodsOrdered() {
    List<FoodOrdered> foodsOrdered = [];
    if(_instance?.getString("foods_ordered") != null) {
      List<dynamic> jsonFoodsOrdered = jsonDecode(_instance!.getString("foods_ordered")!);
      foodsOrdered = jsonFoodsOrdered.map((e) => FoodOrdered.fromJson(e)).toList();
    }
    return foodsOrdered;
  }

}