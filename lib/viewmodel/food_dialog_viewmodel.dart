import 'package:flutter/material.dart';

class FoodDialogViewModel extends ChangeNotifier {
  int quantity = 0;

  void increaseQuantity() {
    quantity += 1;
    notifyListeners();
  }

  void decreaseQuantity() {
    if (quantity >= 1) {
      quantity -= 1;
    }
    notifyListeners();
  }

  double getTotalCost(double cost) {
    return cost * quantity;
  }


}