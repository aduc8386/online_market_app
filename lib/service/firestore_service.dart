import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:funix_assignment/model/custom_user.dart';
import 'package:funix_assignment/service/firebase_auth_service.dart';
import 'package:funix_assignment/helper/shared_preferences_helper.dart';
import 'package:funix_assignment/viewmodel/cart_viewmodel.dart';
import 'package:provider/provider.dart';

import '../model/cart.dart';
import '../model/food.dart';

class FirestoreService {
  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference favoriteFoods = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuthService().currentUser?.uid)
      .collection("favorite_foods");
  final CollectionReference foods =
      FirebaseFirestore.instance.collection("foods");

  Future addUserData(
      String uid, String fullName, String email, String password) async {
    Map<String, bool> periodicalDeliveryDate = {
      "Monday": false,
      "Tuesday": false,
      "Wednesday": false,
      "Thursday": false,
      "Friday": false,
      "Saturday": false,
      "Sunday": false,
    };

    Map<String, dynamic> cart = {
      "customer_name": fullName,
      "customer_address": "No address yet",
      "customer_phone_number": "No phone number yet",
      "note": "No note yet",
      "periodical_delivery_date": periodicalDeliveryDate,
      "periodical_delivery_time": "Office Hours",
      "checked_out_at": DateTime.now().microsecondsSinceEpoch.toString(),
      "total_cost": 0.0,
      "created_at": DateTime.now().microsecondsSinceEpoch.toString(),
    };

    Map<String, dynamic> user = {
      "address": "No address yet",
      "phone_number": "No phone number yet",
      "full_name": fullName,
      "uid": uid,
      "email": email,
      "password": password,
      "cart": cart,
    };

    await users.doc(uid).set(user);
  }

  Future order(Cart order) async {
    // List<Map<String, dynamic>> foodsOrderedJson = [];
    // order.foodsOrdered.map((foodOrdered) {
    //   Map<String, dynamic> i = {foodOrdered.food.name: foodOrdered.toJson()};
    //   print(i.values);
    //   foodsOrderedJson.add(i);
    // });

    Map<String, dynamic> orderJson = {
      "customer_name": order.customerName,
      "customer_address": order.customerAddress,
      "customer_phone_number": order.customerPhoneNumber,
      "note": order.note,
      "periodical_delivery_date": order.periodicalDeliveryDate,
      "periodical_delivery_time": order.periodicalDeliveryTime,
      // "foods_ordered": foodsOrderedJson,
      "checked_out_at": order.checkedOutAt,
      "total_cost": order.totalCost,
      "created_at": order.createdAt,
      "delivery_cost": order.deliveryCost,
    };

    // print("List: " + foodsOrderedJson.toString());

    CustomUser? customUser =
        await FirebaseAuthService().getCurrentUser().then((value) => value);

    // List<Map<String, dynamic>> ordersHistory = [];
    //
    // customUser?.ordersHistory.map((order) {
    //   Map<String, dynamic> orderJson1 = order.toJson();
    //   ordersHistory.add(orderJson1);
    // });
    // ordersHistory.add(orderJson);

    // customUser?.ordersHistory = ordersHistory.map((cart) => Cart.fromFirebaseResponse(cart)).toList();

    await FirestoreService()
        .users
        .doc(customUser?.uid)
        .collection("order_history")
        .doc(order.checkedOutAt)
        .set(orderJson);

    for (int i = 0; i < order.foodsOrdered.length; i++) {
      Map<String, dynamic> map = {
        "food": order.foodsOrdered[i].food.toJson(),
        "quantity": order.foodsOrdered[i].quantity
      };
      await FirestoreService()
          .users
          .doc(customUser?.uid)
          .collection("order_history")
          .doc(order.checkedOutAt)
          .collection("foods_ordered")
          .doc(order.foodsOrdered[i].food.fid)
          .set(map);
    }
  }

  Future<bool> isLiked(Food food) async {
    final favFoodRef = favoriteFoods.doc(food.fid);
    bool isLiked = await favFoodRef.get().then((value) {
      if (value.exists) {
        return true;
      } else {
        return false;
      }
    });
    return isLiked;
  }

  Future setLiked(Food food) async {
    bool isLiked = await FirestoreService().isLiked(food);

    final favFoodRef = favoriteFoods.doc(food.fid);

    if (isLiked) {
      await favFoodRef.delete();
    } else {
      Map<String, dynamic> map = food.toJson();
      favoriteFoods.doc(food.fid).set(map);
    }
  }
}
