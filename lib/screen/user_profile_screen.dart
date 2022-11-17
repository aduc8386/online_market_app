import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:funix_assignment/model/custom_user.dart';
import 'package:funix_assignment/service/firebase_auth_service.dart';
import 'package:funix_assignment/service/firestore_service.dart';

class UserProfileScreen extends StatefulWidget {
  final String uid;

  const UserProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _auth = FirebaseAuthService();

  bool isLoading = true;
  CustomUser? user;
  String name = "Nothing";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() async {
    user = await FirebaseAuthService().getCurrentUser().then((value) => value);
    // name = user.fullName;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;


    return isLoading
        ? SpinKitChasingDots(
            color: Theme.of(context).primaryColor,
            size: width * 0.08,
          )
        : SingleChildScrollView(
            padding: EdgeInsets.all(width * 0.05),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProfileImageWidget(
                  imagePath: "https://www.w3schools.com/w3images/avatar2.png",
                  onClicked: () {},
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  user!.fullName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).iconTheme.color,
                    fontSize: width * 0.065,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  user!.email,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).tabBarTheme.unselectedLabelColor,
                    fontSize: width * 0.03,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Full name",
                        style: TextStyle(
                            color: Theme.of(context)
                                .iconTheme
                                .color!
                                .withOpacity(0.5),
                            fontSize: width * 0.03,
                            fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        readOnly: true,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: user!.fullName,
                          labelStyle: TextStyle(
                            color: Theme.of(context).iconTheme.color,
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.bold,
                          ),
                          disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).iconTheme.color!,
                              width: 0.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Email",
                        style: TextStyle(
                            color: Theme.of(context)
                                .iconTheme
                                .color!
                                .withOpacity(0.5),
                            fontSize: width * 0.03,
                            fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        readOnly: true,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: user!.email,
                          labelStyle: TextStyle(
                            color: Theme.of(context).iconTheme.color,
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.bold,
                          ),
                          disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).iconTheme.color!,
                              width: 0.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Password",
                        style: TextStyle(
                            color: Theme.of(context)
                                .iconTheme
                                .color!
                                .withOpacity(0.5),
                            fontSize: width * 0.03,
                            fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        readOnly: true,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: "***********",
                          labelStyle: TextStyle(
                            color: Theme.of(context).iconTheme.color,
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.bold,
                          ),
                          disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).iconTheme.color!,
                              width: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
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
                    await _auth.signOut();
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
                    "Log out",
                    style: TextStyle(
                        color: Theme.of(context).iconTheme.color,
                        fontSize: width * 0.045),
                  ),
                ),
              ],
            ),
          );
  }
}

class ProfileImageWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;

  const ProfileImageWidget(
      {Key? key, required this.imagePath, required this.onClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          ClipOval(
            child: Material(
              color: Colors.transparent,
              child: Ink.image(
                image: NetworkImage(imagePath),
                fit: BoxFit.fitWidth,
                width: 150,
                height: 150,
                child: InkWell(
                  onTap: onClicked,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 8,
            child: ClipOval(
              child: Container(
                color: Theme.of(context).backgroundColor,
                padding: EdgeInsets.all(4),
                child: ClipOval(
                  child: Container(
                    padding: EdgeInsets.all(6),
                    color: Theme.of(context).primaryColor,
                    child: Icon(
                      Icons.edit,
                      size: 20,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
