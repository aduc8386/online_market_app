import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:funix_assignment/screen/sign_in_screen.dart';
import 'package:funix_assignment/screen/sign_up_screen.dart';
import 'package:funix_assignment/screen/user_profile_screen.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  bool showSignIn = true;

  void toggleSignInSignUp() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    final user = Provider.of<User?>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).iconTheme.color,
            size: width * 0.055,
          ),
        ),
        iconTheme: Theme.of(context).iconTheme,
        title: Text(
          "Account",
          style: TextStyle(
            color: Theme.of(context).iconTheme.color,
            fontSize: width * 0.055,
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
      ),
      body: user != null ? UserProfileScreen(uid: user.uid) : showSignIn ? SignInScreen(toggleSignInSignUp) : SignUpScreen(toggleSignInSignUp),
    );
  }
}

