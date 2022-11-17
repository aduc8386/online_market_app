import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:funix_assignment/key/global_key.dart';
import 'package:funix_assignment/model/custom_user.dart';
import 'package:funix_assignment/service/firestore_service.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final userStream = FirebaseAuth.instance.authStateChanges();
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<CustomUser?> getCurrentUser() async {
    CustomUser? customUser;
    if(currentUser != null){
      await FirestoreService().users.doc(currentUser!.uid).get().then((userResponse) {
        customUser = CustomUser.fromFirebaseResponse(
            userResponse.data() as Map<String, dynamic>);
      });
    }
    return customUser;
  }

  Future signInAnonymous() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      print(e);
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch(e){
      snackBarKey.currentState?.showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      return userCredential.user;
    } on FirebaseAuthException catch(e){
      snackBarKey.currentState?.showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }

  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch(e) {
      print(e);
    }
  }
}
