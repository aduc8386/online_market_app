import 'package:flutter/material.dart';
import 'package:funix_assignment/app_themes.dart';
import 'package:provider/provider.dart';

class FoodAppDrawerTablet extends StatefulWidget {
  const FoodAppDrawerTablet({Key? key}) : super(key: key);

  @override
  State<FoodAppDrawerTablet> createState() => _FoodAppDrawerTabletState();
}

class _FoodAppDrawerTabletState extends State<FoodAppDrawerTablet> {
  @override
  Widget build(BuildContext context) {
    bool isInDarkTheme = Provider.of<ThemeProvider>(context).isDarkMode;

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Drawer(
      backgroundColor: Theme.of(context).backgroundColor,
      width: width * 0.5,
      elevation: 0,
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
                child: Text(
                  "Menu",
                  style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 14.0),
                child: ListTile(
                  leading: Icon(
                    Icons.account_circle,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    "Account",
                    style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontSize: width * 0.025,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 14.0),
                child: ListTile(
                  leading: Icon(
                    Icons.history,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    "History",
                    style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontSize: width * 0.025,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 14.0),
                child: ListTile(
                  leading: Icon(
                    Icons.favorite,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    "Favorite",
                    style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontSize: width * 0.025,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                thickness: .5,
                height: 10,
                indent: 20,
                endIndent: 20,
                color: Theme.of(context).iconTheme.color,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                child: SwitchListTile(
                  title: Text(
                    "Dark Theme",
                    style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontSize: width * 0.025,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: isInDarkTheme,
                  activeColor: Theme.of(context).iconTheme.color,
                  onChanged: (bool value) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .themeToggle(value);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 14.0),
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    "Logout",
                    style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontSize: width * 0.025,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
