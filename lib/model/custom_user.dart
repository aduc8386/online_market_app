import 'package:funix_assignment/model/cart.dart';

import 'food.dart';

class CustomUser {
  String fullName = "Error";
  String email = "Error";
  String? phoneNumber;
  String password = "Error";
  String uid = "Error";
  String? address;
  Cart currentCart = Cart.initial();
  List<Food> favoriteFoods = [];
  List<Cart> ordersHistory = [];

  CustomUser();

  CustomUser.fromFirebaseResponse(Map<String, dynamic> snapshot) {
    uid = snapshot["uid"];
    fullName = snapshot["full_name"];
    email = snapshot["email"];
    phoneNumber = snapshot["phone_number"];
    address = snapshot["address"];
    password = snapshot["password"];
    currentCart = Cart.fromFirebaseResponse(snapshot["cart"]);
    // favoriteFoods = (snapshot["favorite_foods"].length > 0 &&
    //         snapshot["favorite_foods"] != null)
    //     ? List<Food>.generate(
    //         snapshot["favorite_foods"].length,
    //         (index) => Food.fromFirebaseResponse(
    //             snapshot["favorite_foods"][index])).toList()
    //     : [];
    // ordersHistory = (snapshot["orders_history"].length > 0 &&
    //         snapshot["orders_history"] != null)
    //     ? List<Cart>.generate(
    //         snapshot["orders_history"].length,
    //         (index) => Cart.fromFirebaseResponse(
    //             snapshot["orders_history"][index])).toList()
    //     : [] as List<Cart>;
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "full_name": fullName,
      "email": email,
      "phone_number": phoneNumber,
      "address": address,
      "password": password,
      "favorite_foods": favoriteFoods,
    };
  }

  static Map<String, dynamic> convertToJsonList(CustomUser user) {
    Map<String, dynamic> userJson = user.toJson();
    return userJson;
  }
}
