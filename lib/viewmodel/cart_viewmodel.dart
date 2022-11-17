import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:funix_assignment/model/food_ordered.dart';

import '../model/cart.dart';
import '../model/food.dart';
import '../service/firebase_auth_service.dart';
import '../service/firestore_service.dart';

class CartViewModel extends ChangeNotifier {
  static late CartViewModel _instance;
  Cart cart = Cart.initial();
  bool isPeriodicalDelivery = false;

  CartViewModel._internal();

  factory CartViewModel() {
    return _instance;
  }

  static CartViewModel instance() => _instance;

  static void initial() {
    _instance = CartViewModel._internal();
  }

  void addToCart({required Food food, required int quantity}) {
    bool isExist = false;
    if (cart.foodsOrdered.isEmpty) {
      cart.foodsOrdered.add(FoodOrdered(food, quantity));
    } else {
      for (int i = 0; i < cart.foodsOrdered.length; i++) {
        if (food.fid == cart.foodsOrdered[i].food.fid) {
          isExist = true;
          cart.foodsOrdered[i].quantity += quantity;
        }
      }
      if (!isExist) {
        cart.foodsOrdered.add(FoodOrdered(food, quantity));
      }
    }
    cart.totalCost = 0;
    for (FoodOrdered foodOrdered in cart.foodsOrdered) {
      cart.totalCost += (foodOrdered.quantity * foodOrdered.food.price);
    }
    cart.totalCost += cart.deliveryCost;

    notifyListeners();
  }

  void updateCart({required Food food, required int quantity}) {
    for (FoodOrdered f in cart.foodsOrdered) {
      if (f.food.fid == food.fid) {
        if(quantity != 0) {
          f.quantity = quantity;
        } else {
          cart.foodsOrdered.remove(f);
        }

        cart.totalCost = 0;
        for (FoodOrdered foodOrdered in cart.foodsOrdered) {
          cart.totalCost += (foodOrdered.quantity * foodOrdered.food.price);
        }
        cart.totalCost += cart.deliveryCost;
        notifyListeners();
        return;
      }
    }
  }

  void setPeriodicalDelivery(bool value) {
    isPeriodicalDelivery = value;
    notifyListeners();
  }

  void setDateForPeriodicalDelivery(String date) {
    cart.periodicalDeliveryDate[date] == true
        ? cart.periodicalDeliveryDate[date] = false
        : cart.periodicalDeliveryDate[date] = true;
    notifyListeners();
  }

  void setTimeForPeriodicalDelivery(String time) {
    cart.periodicalDeliveryTime = time;
    notifyListeners();
  }

  void setCustomerInformation(String name, String phoneNumber, String address,
      String note, String checkedOutAt) {
    cart.customerName = name;
    cart.customerPhoneNumber = phoneNumber;
    cart.customerAddress = address;
    cart.note = note;
    cart.checkedOutAt = checkedOutAt;
    notifyListeners();
  }

  Future<List<Cart>> getOrderHistory() async {
    List<Cart> orderHistory = [];
    String currentUserId = FirebaseAuthService().currentUser!.uid;
    QuerySnapshot a = await FirestoreService()
        .users
        .doc(currentUserId)
        .collection("order_history")
        .get();

    orderHistory = a.docs
        .map((cart) =>
            Cart.fromFirebaseResponse(cart.data() as Map<String, dynamic>))
        .toList();

    return orderHistory;
  }

  Future<List<FoodOrdered>> getFoodsOrdered(String checkedOutTime) async {
    List<FoodOrdered> foodsOrdered = [];
    String currentUserId = FirebaseAuthService().currentUser!.uid;
    QuerySnapshot a = await FirestoreService()
        .users
        .doc(currentUserId)
        .collection("order_history")
        .doc(checkedOutTime)
        .collection("foods_ordered")
        .get();

    foodsOrdered = a.docs
        .map((foodOrdered) =>
            FoodOrdered.fromFirebaseResponse(foodOrdered.data() as Map<String, dynamic>))
        .toList();

    return foodsOrdered;
  }
}
