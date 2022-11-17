import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:funix_assignment/screen/account_screen.dart';
import 'package:funix_assignment/service/firebase_auth_service.dart';

class SignInScreen extends StatefulWidget {
  final Function toggleSignInSignUp;

  const SignInScreen(this.toggleSignInSignUp, {Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _auth = FirebaseAuthService();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return isLoading
        ? SpinKitChasingDots(
            color: Theme.of(context).primaryColor,
            size: width * 0.08,
          )
        : Padding(
            padding: EdgeInsets.fromLTRB(
                width * 0.05, width * 0.08, width * 0.05, width * 0.05),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 100,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://www.w3schools.com/w3images/avatar2.png"),
                        fit: BoxFit.fitHeight,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Flexible(
                  flex: 1,
                  child: Text(
                    "Welcome",
                    style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontSize: width * 0.08,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                _CustomTextField(
                  label: "Email",
                  inputType: TextInputType.text,
                  controller: emailController,
                ),
                SizedBox(
                  height: 20,
                ),
                _CustomTextField(
                  label: "Password",
                  inputType: TextInputType.text,
                  controller: passwordController,
                  obscureText: true,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(right: width * 0.05),
                  child: Text(
                    "Forgot password?",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Theme.of(context).tabBarTheme.unselectedLabelColor,
                      fontSize: width * 0.03,
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                MaterialButton(
                  height: width * 0.12,
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    String email = emailController.value.text;
                    String password = passwordController.value.text;

                    await _auth.signInWithEmailAndPassword(email, password);

                    if(!mounted) {
                      return;
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
                  elevation: 0,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Theme.of(context).iconTheme.color,
                        fontSize: width * 0.045),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Don't have account? ",
                    style: TextStyle(
                      color: Theme.of(context).tabBarTheme.unselectedLabelColor,
                      fontSize: width * 0.03,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Sign up",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: width * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            widget.toggleSignInSignUp();
                          },
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

class _CustomTextField extends StatelessWidget {
  final String label;
  final TextInputType inputType;
  final TextEditingController controller;
  final bool obscureText;

  const _CustomTextField(
      {Key? key,
      required this.label,
      required this.inputType,
      required this.controller,
      this.obscureText = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: TextFormField(
        keyboardType: inputType,
        obscureText: obscureText,
        controller: controller,
        cursorColor: Theme.of(context).primaryColor,
        cursorHeight: width * 0.05,
        cursorWidth: 1.5,
        validator: (value) {
          if (value!.isEmpty) {
            return "This field cannot be empty";
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).cardColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).cardColor),
            ),
            labelText: label,
            labelStyle: TextStyle(
              color: Theme.of(context).tabBarTheme.unselectedLabelColor,
              fontSize: width * 0.035,
            ),
            fillColor: Theme.of(context).primaryColorLight,
            contentPadding: EdgeInsets.all(width * 0.01)),
        style: TextStyle(
          color: Theme.of(context).iconTheme.color,
          fontSize: width * 0.035,
        ),
      ),
    );
  }
}


