import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:funix_assignment/model/custom_user.dart';
import 'package:funix_assignment/service/firebase_auth_service.dart';
import 'package:funix_assignment/service/firestore_service.dart';
import 'package:uuid/uuid.dart';

class SignUpScreen extends StatefulWidget {
  final Function toggleSignInSignUp;

  const SignUpScreen(this.toggleSignInSignUp, {Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final formKey = GlobalKey<FormState>();

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
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      "Register",
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
                    label: "Full Name",
                    inputType: TextInputType.text,
                    controller: nameController,
                  ),
                  SizedBox(
                    height: 20,
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
                  _CustomTextField(
                    label: "Confirm password",
                    inputType: TextInputType.text,
                    controller: confirmPasswordController,
                    obscureText: true,
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
                      if (formKey.currentState!.validate()) {
                        String fullName = nameController.value.text;
                        String email = emailController.value.text;
                        String password = passwordController.value.text;


                        User? user = await _auth.registerWithEmailAndPassword(
                            email, password);
                        if(user != null) {
                          FirestoreService().addUserData(user.uid, fullName, email, password);
                        }
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    elevation: 0,
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Theme.of(context).iconTheme.color,
                        fontSize: width * 0.045,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Already have account? ",
                      style: TextStyle(
                        color:
                            Theme.of(context).tabBarTheme.unselectedLabelColor,
                        fontSize: width * 0.03,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Sign in",
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
