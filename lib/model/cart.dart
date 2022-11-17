import 'package:funix_assignment/model/food_ordered.dart';

class Cart {
  String customerName = "";
  String customerPhoneNumber = "";
  String customerAddress = "";
  List<FoodOrdered> foodsOrdered = [];
  String checkedOutAt = "";
  String? note;
  String createdAt = DateTime.now().microsecondsSinceEpoch.toString();
  double totalCost = 0;
  double deliveryCost = 3.0;
  String periodicalDeliveryTime = "Office Hours";
  Map<String, bool> periodicalDeliveryDate = {
    "Monday": false,
    "Tuesday": false,
    "Wednesday": false,
    "Thursday": false,
    "Friday": false,
    "Saturday": false,
    "Sunday": false,
  };

  Cart(
      this.customerName,
      this.customerPhoneNumber,
      this.customerAddress,
      this.foodsOrdered,
      this.checkedOutAt,
      this.note,
      this.createdAt,
      this.totalCost);

  Cart.initial();

  Cart.fromFirebaseResponse(Map<String, dynamic> response) {
    customerName = response["customer_name"];
    customerPhoneNumber = response["customer_phone_number"];
    customerAddress = response["customer_address"];
    note = response["note"];
    periodicalDeliveryTime = response["periodical_delivery_time"];
    periodicalDeliveryDate["Monday"] = response["periodical_delivery_date"]["Monday"];
    periodicalDeliveryDate["Tuesday"] = response["periodical_delivery_date"]["Tuesday"];
    periodicalDeliveryDate["Wednesday"] = response["periodical_delivery_date"]["Wednesday"];
    periodicalDeliveryDate["Thursday"] = response["periodical_delivery_date"]["Thursday"];
    periodicalDeliveryDate["Friday"] = response["periodical_delivery_date"]["Friday"];
    periodicalDeliveryDate["Saturday"] = response["periodical_delivery_date"]["Saturday"];
    periodicalDeliveryDate["Sunday"] = response["periodical_delivery_date"]["Sunday"];
    checkedOutAt = response["checked_out_at"];
    totalCost = response["total_cost"];
    createdAt = response["created_at"];
  }

  Cart.fromJson(Map<String, dynamic> json) {
    customerName = json["customer_name"];
    customerPhoneNumber = json["customer_phone_number"];
    customerAddress = json["customer_address"];
    note = json["note"];
    periodicalDeliveryTime = json["periodical_delivery_time"];
    periodicalDeliveryDate["Monday"] = json["periodical_delivery_date"]["Monday"];
    periodicalDeliveryDate["Tuesday"] = json["periodical_delivery_date"]["Tuesday"];
    periodicalDeliveryDate["Wednesday"] = json["periodical_delivery_date"]["Wednesday"];
    periodicalDeliveryDate["Thursday"] = json["periodical_delivery_date"]["Thursday"];
    periodicalDeliveryDate["Friday"] = json["periodical_delivery_date"]["Friday"];
    periodicalDeliveryDate["Saturday"] = json["periodical_delivery_date"]["Saturday"];
    periodicalDeliveryDate["Sunday"] = json["periodical_delivery_date"]["Sunday"];
    checkedOutAt = json["checked_out_at"];
    totalCost = json["total_cost"];
    createdAt = json["created_at"];

  }

  Map<String, dynamic> toJson() {
    return {
      "customer_name": customerName,
      "customer_phone_number": customerPhoneNumber,
      "customer_address": customerAddress,
      "note": note,
      "checkout_at": checkedOutAt,
      "total_cost": totalCost,
      "created_at": createdAt,
    };
  }

  static List<Map<String, dynamic>> convertToJsonList(List<Cart> orderHistory) {
    List<Map<String, dynamic>> map = [];
    for (var order in orderHistory) {
      Map<String, dynamic> orderJson = order.toJson();
      map.add(orderJson);
    }
    return map;
  }
}
