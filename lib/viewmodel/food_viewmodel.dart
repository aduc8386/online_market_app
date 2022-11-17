import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:funix_assignment/model/custom_user.dart';
import 'package:funix_assignment/model/food.dart';
import 'package:funix_assignment/service/firebase_auth_service.dart';
import 'package:funix_assignment/service/firestore_service.dart';

class FoodViewModel extends ChangeNotifier {
  static late FoodViewModel _instance;

  final CollectionReference foodsReferences = FirestoreService().foods;

  FoodViewModel._internal();

  factory FoodViewModel() {
    return _instance;
  }

  static FoodViewModel instance() => _instance;

  static void initial() {
    _instance = FoodViewModel._internal();
  }

  Future<List<Food>> getFoods() async {
    List<Food> foods = [];
    QuerySnapshot querySnapshot = await foodsReferences.get();
    foods = querySnapshot.docs
        .map((doc) =>
            Food.fromFirebaseResponse(doc.data() as Map<String, dynamic>))
        .toList();

    return foods;
  }

  Future<List<Food>> getVegetables() async {
    List<Food> vegetables = [];
    QuerySnapshot querySnapshot = await foodsReferences.get();
    vegetables = querySnapshot.docs
        .map((doc) =>
            Food.fromFirebaseResponse(doc.data() as Map<String, dynamic>))
        .toList();

    return vegetables.where((food) => food.category == "Vegetable").toList();
  }

  Future<List<Food>> getFruits() async {
    List<Food> fruits = [];
    QuerySnapshot querySnapshot = await foodsReferences.get();
    fruits = querySnapshot.docs
        .map((doc) =>
            Food.fromFirebaseResponse(doc.data() as Map<String, dynamic>))
        .toList();

    return fruits.where((food) => food.category == "Fruit").toList();
  }

  Future<List<Food>> getMeats() async {
    List<Food> meats = [];
    QuerySnapshot querySnapshot = await foodsReferences.get();
    meats = querySnapshot.docs
        .map((doc) =>
            Food.fromFirebaseResponse(doc.data() as Map<String, dynamic>))
        .toList();

    return meats.where((food) => food.category == "Meat").toList();
  }

  Future<List<Food>> getFavoriteFoods() async {
    List<Food> favoriteFoods = [];
    String currentUserId = FirebaseAuthService().currentUser!.uid;
    QuerySnapshot a = await FirestoreService()
        .users
        .doc(currentUserId)
        .collection("favorite_foods")
        .get();

    favoriteFoods = a.docs
        .map((food) =>
            Food.fromFirebaseResponse(food.data() as Map<String, dynamic>))
        .toList();

    // .then((userResponse) {
    //   CustomUser user = CustomUser.fromFirebaseResponse(
    //       userResponse.data() as Map<String, dynamic>);
    //   favoriteFoods = user.favoriteFoods;
    // });

    return favoriteFoods;
  }
}
