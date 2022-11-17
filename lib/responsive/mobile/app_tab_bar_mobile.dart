import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:funix_assignment/model/cart.dart';
import 'package:funix_assignment/helper/shared_preferences_helper.dart';
import 'package:provider/provider.dart';

import '../../screen/cart_screen.dart';
import '../../viewmodel/cart_viewmodel.dart';

class AppBarMobile extends StatefulWidget implements PreferredSizeWidget {
  const AppBarMobile({Key? key}) : super(key: key);

  @override
  State<AppBarMobile> createState() => _AppBarMobileState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AppBarMobileState extends State<AppBarMobile> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // init();
  }

  @override
  Widget build(BuildContext context) {


    final width = MediaQuery.of(context).size.width;

    final user = Provider.of<User?>(context);

    return AppBar(
      iconTheme: Theme.of(context).iconTheme,
      title: Text(
        "Online Market",
        style: TextStyle(
          color: Theme.of(context).iconTheme.color,
          fontWeight: FontWeight.bold,
          fontSize: width * 0.05,
        ),
      ),
      backgroundColor:
      Theme.of(context).backgroundColor,
      elevation: 0,
      actions: [
        Padding(
          padding:
          EdgeInsets.only(right: width * 0.01),
          child: Consumer<CartViewModel>(
            builder: (context, cart, child) {
              String foodCounter = cart
                  .cart.foodsOrdered.length
                  .toString();
              return Badge(
                badgeContent: Text(
                  user == null ? "0" : foodCounter,
                  style: TextStyle(
                      color: Theme.of(context)
                          .iconTheme
                          .color,
                      fontSize: width * 0.025),
                ),
                position: BadgePosition.topEnd(
                    top: 3, end: 3),
                elevation: 0,
                animationDuration:
                Duration(milliseconds: 500),
                badgeColor:
                Theme.of(context).primaryColor,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed("/$CartScreen");
                  },
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Theme.of(context)
                        .iconTheme
                        .color,
                    size: width * 0.05,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
