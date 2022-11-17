import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:funix_assignment/service/firestore_service.dart';
import 'package:funix_assignment/viewmodel/cart_viewmodel.dart';
import 'package:provider/provider.dart';

import '../responsive/mobile/information_dialog.dart';
import '../model/cart.dart';
import '../model/food.dart';
import '../helper/shared_preferences_helper.dart';
import 'account_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _phoneNumberEditingController =
      TextEditingController();
  final TextEditingController _addressEditingController =
      TextEditingController();
  final TextEditingController _noteEditingController = TextEditingController();

  void submitOrder(Cart cart) {
    FirestoreService().order(cart);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    final cart = context.watch<CartViewModel>().cart;
    final user = Provider.of<User?>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: width < 600 ? AppBar(
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
          "Cart",
          style: TextStyle(
            color: Theme.of(context).iconTheme.color,
            fontSize: width * 0.055,
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
      ) : AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).iconTheme.color,
            size: width * 0.035,
          ),
        ),
        iconTheme: Theme.of(context).iconTheme,
        title: Text(
          "Cart",
          style: TextStyle(
            color: Theme.of(context).iconTheme.color,
            fontSize: width * 0.035,
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
      ),
      body:  user == null ? _SignInFirst() : SafeArea(
        child: orientation == Orientation.portrait ? SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(width * 0.05),
                child: SizedBox(
                  height: height * 0.76,
                  child: Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Enter name and address",
                            style: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                              fontSize: width * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _CustomTextField(
                            label: "Enter name",
                            inputType: TextInputType.name,
                            controller: _nameEditingController,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _CustomTextField(
                            label: "Enter phone number",
                            inputType: TextInputType.phone,
                            controller: _phoneNumberEditingController,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _CustomTextField(
                            label: "Enter address",
                            inputType: TextInputType.streetAddress,
                            controller: _addressEditingController,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _CustomTextField(
                            label: "Note for shop",
                            inputType: TextInputType.text,
                            controller: _noteEditingController,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            "Shopping Cart",
                            style: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                              fontSize: width * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          cart.foodsOrdered.isNotEmpty
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Spacer(
                                          flex: 2,
                                        ),
                                        Flexible(
                                            fit: FlexFit.tight,
                                            flex: 1,
                                            child: Text(
                                              "Quantity",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                                fontSize: width * 0.025,
                                              ),
                                            )),
                                        Flexible(
                                          fit: FlexFit.tight,
                                          flex: 1,
                                          child: Text(
                                            "Cost",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                              fontSize: width * 0.025,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      height: height * 0.15,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: cart.foodsOrdered.length,
                                        itemBuilder: (context, index) {
                                          int ordinalNum = index + 1;
                                          Food food = cart.foodsOrdered[index].food;
                                          String foodName =
                                              cart.foodsOrdered[index].food.name;
                                          String foodQuantity = cart
                                              .foodsOrdered[index].quantity
                                              .toString();
                                          String totalCost = (cart
                                                      .foodsOrdered[index]
                                                      .quantity *
                                                  cart.foodsOrdered[index].food
                                                      .price)
                                              .toString();
                                          return InkWell(
                                            onTap: () {
                                              InformationDialog
                                                  .showFoodOrderedDetailDialog(
                                                  context, food, int.parse(foodQuantity));
                                            },
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Flexible(
                                                      flex: 1,
                                                      fit: FlexFit.tight,
                                                      child: Text(
                                                        ordinalNum.toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Theme.of(context)
                                                              .iconTheme
                                                              .color,
                                                          fontSize: width * 0.025,
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex: 1,
                                                      fit: FlexFit.tight,
                                                      child: Text(
                                                        foodName,
                                                        style: TextStyle(
                                                          color: Theme.of(context)
                                                              .iconTheme
                                                              .color,
                                                          fontSize: width * 0.025,
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex: 1,
                                                      fit: FlexFit.tight,
                                                      child: Text(
                                                        foodQuantity,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Theme.of(context)
                                                              .iconTheme
                                                              .color,
                                                          fontSize: width * 0.025,
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex: 1,
                                                      fit: FlexFit.tight,
                                                      child: Text(
                                                        totalCost,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Theme.of(context)
                                                              .iconTheme
                                                              .color,
                                                          fontSize: width * 0.025,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  thickness: 0.5,
                                                  color:
                                                      Theme.of(context).cardColor,
                                                ),
                                                SizedBox(
                                                  height: 0.01 * width,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: Text(
                                        "Cart is empty",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .tabBarTheme
                                                .unselectedLabelColor
                                                ?.withOpacity(0.5),
                                            fontSize: width * 0.02),
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: width * 0.4,
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  cursorColor: Theme.of(context).primaryColor,
                                  cursorHeight: width * 0.05,
                                  cursorWidth: 1.5,
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context).cardColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context).cardColor),
                                      ),
                                      border: OutlineInputBorder(),
                                      labelText: "Coupon",
                                      labelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .tabBarTheme
                                            .unselectedLabelColor,
                                        fontSize: width * 0.025,
                                      ),
                                      fillColor:
                                          Theme.of(context).primaryColorLight,
                                      contentPadding:
                                          EdgeInsets.all(width * 0.025)),
                                  style: TextStyle(
                                    color: Theme.of(context).iconTheme.color,
                                    fontSize: width * 0.03,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Periodical Delivery",
                                style: TextStyle(
                                  color: Theme.of(context).iconTheme.color,
                                  fontSize: width * 0.03,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Checkbox(
                                value: context
                                    .watch<CartViewModel>()
                                    .isPeriodicalDelivery,
                                onChanged: (value) {
                                  Provider.of<CartViewModel>(context,
                                          listen: false)
                                      .setPeriodicalDelivery(value!);
                                },
                                checkColor: Theme.of(context).iconTheme.color,
                                activeColor: Theme.of(context).primaryColor,
                                focusColor: Theme.of(context).primaryColor,
                                hoverColor: Theme.of(context).primaryColor,
                                side: BorderSide(
                                  color: Theme.of(context).cardColor,
                                ),
                              ),
                            ],
                          ),
                          context.watch<CartViewModel>().isPeriodicalDelivery
                              ? Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: MaterialButton(
                                            onPressed: () {
                                              Provider.of<CartViewModel>(
                                                      context,
                                                      listen: false)
                                                  .setDateForPeriodicalDelivery(
                                                      "Monday");
                                            },
                                            color: context
                                                            .watch<CartViewModel>()
                                                            .cart
                                                            .periodicalDeliveryDate[
                                                        "Monday"] ==
                                                    true
                                                ? Theme.of(context).primaryColor
                                                : Theme.of(context)
                                                    .primaryColorLight,
                                            elevation: 0,
                                            child: Text(
                                              "Monday",
                                              style: TextStyle(
                                                  color: context
                                                                  .watch<
                                                                      CartViewModel>()
                                                                  .cart
                                                                  .periodicalDeliveryDate[
                                                              "Monday"] ==
                                                          true
                                                      ? Theme.of(context)
                                                          .iconTheme
                                                          .color
                                                      : Theme.of(context)
                                                          .tabBarTheme
                                                          .unselectedLabelColor,
                                                  fontSize: width * 0.025),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: MaterialButton(
                                            onPressed: () {
                                              Provider.of<CartViewModel>(
                                                      context,
                                                      listen: false)
                                                  .setDateForPeriodicalDelivery(
                                                      "Tuesday");
                                            },
                                            color: context
                                                            .watch<CartViewModel>()
                                                            .cart
                                                            .periodicalDeliveryDate[
                                                        "Tuesday"] ==
                                                    true
                                                ? Theme.of(context).primaryColor
                                                : Theme.of(context)
                                                    .primaryColorLight,
                                            elevation: 0,
                                            child: Text(
                                              "Tuesday",
                                              style: TextStyle(
                                                  color: context
                                                                  .watch<
                                                                      CartViewModel>()
                                                                  .cart
                                                                  .periodicalDeliveryDate[
                                                              "Tuesday"] ==
                                                          true
                                                      ? Theme.of(context)
                                                          .iconTheme
                                                          .color
                                                      : Theme.of(context)
                                                          .tabBarTheme
                                                          .unselectedLabelColor,
                                                  fontSize: width * 0.025),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: MaterialButton(
                                            onPressed: () {
                                              Provider.of<CartViewModel>(
                                                      context,
                                                      listen: false)
                                                  .setDateForPeriodicalDelivery(
                                                      "Wednesday");
                                            },
                                            color: context
                                                            .watch<CartViewModel>()
                                                            .cart
                                                            .periodicalDeliveryDate[
                                                        "Wednesday"] ==
                                                    true
                                                ? Theme.of(context).primaryColor
                                                : Theme.of(context)
                                                    .primaryColorLight,
                                            elevation: 0,
                                            child: Text(
                                              "Wednesday",
                                              style: TextStyle(
                                                  color: context
                                                                  .watch<
                                                                      CartViewModel>()
                                                                  .cart
                                                                  .periodicalDeliveryDate[
                                                              "Wednesday"] ==
                                                          true
                                                      ? Theme.of(context)
                                                          .iconTheme
                                                          .color
                                                      : Theme.of(context)
                                                          .tabBarTheme
                                                          .unselectedLabelColor,
                                                  fontSize: width * 0.025),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: MaterialButton(
                                            onPressed: () {
                                              Provider.of<CartViewModel>(
                                                  context,
                                                  listen: false)
                                                  .setDateForPeriodicalDelivery(
                                                  "Thursday");
                                            },
                                            color: context
                                                .watch<CartViewModel>()
                                                .cart
                                                .periodicalDeliveryDate[
                                            "Thursday"] ==
                                                true
                                                ? Theme.of(context).primaryColor
                                                : Theme.of(context)
                                                .primaryColorLight,
                                            elevation: 0,
                                            child: Text(
                                              "Thursday",
                                              style: TextStyle(
                                                  color: context
                                                      .watch<
                                                      CartViewModel>()
                                                      .cart
                                                      .periodicalDeliveryDate[
                                                  "Thursday"] ==
                                                      true
                                                      ? Theme.of(context)
                                                      .iconTheme
                                                      .color
                                                      : Theme.of(context)
                                                      .tabBarTheme
                                                      .unselectedLabelColor,
                                                  fontSize: width * 0.025),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: MaterialButton(
                                            onPressed: () {
                                              Provider.of<CartViewModel>(
                                                  context,
                                                  listen: false)
                                                  .setDateForPeriodicalDelivery(
                                                  "Friday");
                                            },
                                            color: context
                                                .watch<CartViewModel>()
                                                .cart
                                                .periodicalDeliveryDate[
                                            "Friday"] ==
                                                true
                                                ? Theme.of(context).primaryColor
                                                : Theme.of(context)
                                                .primaryColorLight,
                                            elevation: 0,
                                            child: Text(
                                              "Friday",
                                              style: TextStyle(
                                                  color: context
                                                      .watch<
                                                      CartViewModel>()
                                                      .cart
                                                      .periodicalDeliveryDate[
                                                  "Friday"] ==
                                                      true
                                                      ? Theme.of(context)
                                                      .iconTheme
                                                      .color
                                                      : Theme.of(context)
                                                      .tabBarTheme
                                                      .unselectedLabelColor,
                                                  fontSize: width * 0.025),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: MaterialButton(
                                            onPressed: () {
                                              Provider.of<CartViewModel>(
                                                      context,
                                                      listen: false)
                                                  .setDateForPeriodicalDelivery(
                                                      "Saturday");
                                            },
                                            color: context
                                                            .watch<CartViewModel>()
                                                            .cart
                                                            .periodicalDeliveryDate[
                                                        "Saturday"] ==
                                                    true
                                                ? Theme.of(context).primaryColor
                                                : Theme.of(context)
                                                    .primaryColorLight,
                                            elevation: 0,
                                            child: Text(
                                              "Saturday",
                                              style: TextStyle(
                                                  color: context
                                                                  .watch<
                                                                      CartViewModel>()
                                                                  .cart
                                                                  .periodicalDeliveryDate[
                                                              "Saturday"] ==
                                                          true
                                                      ? Theme.of(context)
                                                          .iconTheme
                                                          .color
                                                      : Theme.of(context)
                                                          .tabBarTheme
                                                          .unselectedLabelColor,
                                                  fontSize: width * 0.025),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: MaterialButton(
                                            onPressed: () {
                                              Provider.of<CartViewModel>(
                                                      context,
                                                      listen: false)
                                                  .setDateForPeriodicalDelivery(
                                                      "Sunday");
                                            },
                                            color: context
                                                            .watch<CartViewModel>()
                                                            .cart
                                                            .periodicalDeliveryDate[
                                                        "Sunday"] ==
                                                    true
                                                ? Theme.of(context).primaryColor
                                                : Theme.of(context)
                                                    .primaryColorLight,
                                            elevation: 0,
                                            child: Text(
                                              "Sunday",
                                              style: TextStyle(
                                                  color: context
                                                                  .watch<
                                                                      CartViewModel>()
                                                                  .cart
                                                                  .periodicalDeliveryDate[
                                                              "Sunday"] ==
                                                          true
                                                      ? Theme.of(context)
                                                          .iconTheme
                                                          .color
                                                      : Theme.of(context)
                                                          .tabBarTheme
                                                          .unselectedLabelColor,
                                                  fontSize: width * 0.025),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Delivery Time",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                            fontSize: width * 0.03,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        RadioListTile<String>(
                                          value: "Office Hours",
                                          groupValue: context
                                              .watch<CartViewModel>()
                                              .cart
                                              .periodicalDeliveryTime,
                                          onChanged: (value) {
                                            // print(value);
                                            Provider.of<CartViewModel>(context,
                                                    listen: false)
                                                .setTimeForPeriodicalDelivery(
                                                    value!);
                                          },
                                          title: Text(
                                            "Office Hours (8AM - 6PM)",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                              fontSize: width * 0.025,
                                            ),
                                          ),
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                        ),
                                        RadioListTile<String>(
                                          value: "After 6PM",
                                          groupValue: context
                                              .watch<CartViewModel>()
                                              .cart
                                              .periodicalDeliveryTime,
                                          onChanged: (value) {
                                            // print(value);
                                            Provider.of<CartViewModel>(context,
                                                    listen: false)
                                                .setTimeForPeriodicalDelivery(
                                                    value!);
                                          },
                                          title: Text(
                                            "After 6PM",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                              fontSize: width * 0.025,
                                            ),
                                          ),
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: width,
                child: Row(
                  children: [
                    Flexible(
                      flex: 7,
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            cart.foodsOrdered.isNotEmpty ? Text(
                              "Delivery: \$${context.watch<CartViewModel>().cart.deliveryCost}",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .tabBarTheme
                                      .unselectedLabelColor,
                                  fontSize: width * 0.025),
                            ) : Container(),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              "Total: \$${cart.foodsOrdered.isEmpty ? "0.0" : context.watch<CartViewModel>().cart.totalCost}",
                              style: TextStyle(
                                  color: Theme.of(context).iconTheme.color,
                                  fontSize: width * 0.04),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      fit: FlexFit.tight,
                      child: SizedBox(
                        height: height * 0.1,
                        child: MaterialButton(
                          onPressed: () {
                            final isValid = formKey.currentState!.validate();

                            if (cart.foodsOrdered.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  _customSnackBar("Cart is empty"));
                            }

                            if (isValid) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(_customSnackBar("Done"));
                              String customerName =
                                  _nameEditingController.value.text;
                              String customerPhoneNumber =
                                  _phoneNumberEditingController.value.text;
                              String customerAddress =
                                  _addressEditingController.value.text;
                              String customerNote =
                                  _noteEditingController.value.text;

                              Provider.of<CartViewModel>(context, listen: false)
                                  .setCustomerInformation(
                                      customerName,
                                      customerPhoneNumber,
                                      customerAddress,
                                      customerNote,
                                      DateTime.now()
                                          .microsecondsSinceEpoch
                                          .toString());


                            }

                            submitOrder(cart);
                          },
                          elevation: 0,
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            "Order",
                            style: TextStyle(
                                color: Theme.of(context).iconTheme.color,
                                fontSize: width * 0.04),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ) : SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(width * 0.05),
                child: SizedBox(
                  height: height * 0.48,
                  child: Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Enter name and address",
                            style: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                              fontSize: width * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _CustomTextField(
                            label: "Enter name",
                            inputType: TextInputType.name,
                            controller: _nameEditingController,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _CustomTextField(
                            label: "Enter phone number",
                            inputType: TextInputType.phone,
                            controller: _phoneNumberEditingController,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _CustomTextField(
                            label: "Enter address",
                            inputType: TextInputType.streetAddress,
                            controller: _addressEditingController,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _CustomTextField(
                            label: "Note for shop",
                            inputType: TextInputType.text,
                            controller: _noteEditingController,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            "Shopping Cart",
                            style: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                              fontSize: width * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          cart.foodsOrdered.isNotEmpty
                              ? Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Spacer(
                                    flex: 2,
                                  ),
                                  Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Text(
                                        "Quantity",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color,
                                          fontSize: width * 0.025,
                                        ),
                                      )),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 1,
                                    child: Text(
                                      "Cost",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .iconTheme
                                            .color,
                                        fontSize: width * 0.025,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: height * 0.15,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: cart.foodsOrdered.length,
                                  itemBuilder: (context, index) {
                                    int ordinalNum = index + 1;
                                    String foodName =
                                        cart.foodsOrdered[index].food.name;
                                    String foodQuantity = cart
                                        .foodsOrdered[index].quantity
                                        .toString();
                                    String totalCost = (cart
                                        .foodsOrdered[index]
                                        .quantity *
                                        cart.foodsOrdered[index].food
                                            .price)
                                        .toString();

                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceEvenly,
                                          children: [
                                            Flexible(
                                              flex: 1,
                                              fit: FlexFit.tight,
                                              child: Text(
                                                ordinalNum.toString(),
                                                textAlign:
                                                TextAlign.center,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                  fontSize: width * 0.025,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              fit: FlexFit.tight,
                                              child: Text(
                                                foodName,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                  fontSize: width * 0.025,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              fit: FlexFit.tight,
                                              child: Text(
                                                foodQuantity,
                                                textAlign:
                                                TextAlign.center,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                  fontSize: width * 0.025,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              fit: FlexFit.tight,
                                              child: Text(
                                                totalCost,
                                                textAlign:
                                                TextAlign.center,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                  fontSize: width * 0.025,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          thickness: 0.5,
                                          color:
                                          Theme.of(context).cardColor,
                                        ),
                                        SizedBox(
                                          height: 0.01 * width,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                              : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Text(
                                  "Cart is empty",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .tabBarTheme
                                          .unselectedLabelColor
                                          ?.withOpacity(0.5),
                                      fontSize: width * 0.02),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: width * 0.4,
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  cursorColor: Theme.of(context).primaryColor,
                                  cursorHeight: width * 0.05,
                                  cursorWidth: 1.5,
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context).cardColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context).cardColor),
                                      ),
                                      border: OutlineInputBorder(),
                                      labelText: "Coupon",
                                      labelStyle: TextStyle(
                                        color: Theme.of(context)
                                            .tabBarTheme
                                            .unselectedLabelColor,
                                        fontSize: width * 0.025,
                                      ),
                                      fillColor:
                                      Theme.of(context).primaryColorLight,
                                      contentPadding:
                                      EdgeInsets.all(width * 0.025)),
                                  style: TextStyle(
                                    color: Theme.of(context).iconTheme.color,
                                    fontSize: width * 0.03,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Periodical Delivery",
                                style: TextStyle(
                                  color: Theme.of(context).iconTheme.color,
                                  fontSize: width * 0.03,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Checkbox(
                                value: context
                                    .watch<CartViewModel>()
                                    .isPeriodicalDelivery,
                                onChanged: (value) {
                                  Provider.of<CartViewModel>(context,
                                      listen: false)
                                      .setPeriodicalDelivery(value!);
                                },
                                checkColor: Theme.of(context).iconTheme.color,
                                activeColor: Theme.of(context).primaryColor,
                                focusColor: Theme.of(context).primaryColor,
                                hoverColor: Theme.of(context).primaryColor,
                                side: BorderSide(
                                  color: Theme.of(context).cardColor,
                                ),
                              ),
                            ],
                          ),
                          context.watch<CartViewModel>().isPeriodicalDelivery
                              ? Column(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: MaterialButton(
                                      onPressed: () {
                                        Provider.of<CartViewModel>(
                                            context,
                                            listen: false)
                                            .setDateForPeriodicalDelivery(
                                            "Monday");
                                      },
                                      color: context
                                          .watch<CartViewModel>()
                                          .cart
                                          .periodicalDeliveryDate[
                                      "Monday"] ==
                                          true
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context)
                                          .primaryColorLight,
                                      elevation: 0,
                                      child: Text(
                                        "Monday",
                                        style: TextStyle(
                                            color: context
                                                .watch<
                                                CartViewModel>()
                                                .cart
                                                .periodicalDeliveryDate[
                                            "Monday"] ==
                                                true
                                                ? Theme.of(context)
                                                .iconTheme
                                                .color
                                                : Theme.of(context)
                                                .tabBarTheme
                                                .unselectedLabelColor,
                                            fontSize: width * 0.025),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: MaterialButton(
                                      onPressed: () {
                                        Provider.of<CartViewModel>(
                                            context,
                                            listen: false)
                                            .setDateForPeriodicalDelivery(
                                            "Tuesday");
                                      },
                                      color: context
                                          .watch<CartViewModel>()
                                          .cart
                                          .periodicalDeliveryDate[
                                      "Tuesday"] ==
                                          true
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context)
                                          .primaryColorLight,
                                      elevation: 0,
                                      child: Text(
                                        "Tuesday",
                                        style: TextStyle(
                                            color: context
                                                .watch<
                                                CartViewModel>()
                                                .cart
                                                .periodicalDeliveryDate[
                                            "Tuesday"] ==
                                                true
                                                ? Theme.of(context)
                                                .iconTheme
                                                .color
                                                : Theme.of(context)
                                                .tabBarTheme
                                                .unselectedLabelColor,
                                            fontSize: width * 0.025),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: MaterialButton(
                                      onPressed: () {
                                        Provider.of<CartViewModel>(
                                            context,
                                            listen: false)
                                            .setDateForPeriodicalDelivery(
                                            "Wednesday");
                                      },
                                      color: context
                                          .watch<CartViewModel>()
                                          .cart
                                          .periodicalDeliveryDate[
                                      "Wednesday"] ==
                                          true
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context)
                                          .primaryColorLight,
                                      elevation: 0,
                                      child: Text(
                                        "Wednesday",
                                        style: TextStyle(
                                            color: context
                                                .watch<
                                                CartViewModel>()
                                                .cart
                                                .periodicalDeliveryDate[
                                            "Wednesday"] ==
                                                true
                                                ? Theme.of(context)
                                                .iconTheme
                                                .color
                                                : Theme.of(context)
                                                .tabBarTheme
                                                .unselectedLabelColor,
                                            fontSize: width * 0.025),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: MaterialButton(
                                      onPressed: () {
                                        Provider.of<CartViewModel>(
                                            context,
                                            listen: false)
                                            .setDateForPeriodicalDelivery(
                                            "Thursday");
                                      },
                                      color: context
                                          .watch<CartViewModel>()
                                          .cart
                                          .periodicalDeliveryDate[
                                      "Thursday"] ==
                                          true
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context)
                                          .primaryColorLight,
                                      elevation: 0,
                                      child: Text(
                                        "Thursday",
                                        style: TextStyle(
                                            color: context
                                                .watch<
                                                CartViewModel>()
                                                .cart
                                                .periodicalDeliveryDate[
                                            "Thursday"] ==
                                                true
                                                ? Theme.of(context)
                                                .iconTheme
                                                .color
                                                : Theme.of(context)
                                                .tabBarTheme
                                                .unselectedLabelColor,
                                            fontSize: width * 0.025),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: MaterialButton(
                                      onPressed: () {
                                        Provider.of<CartViewModel>(
                                            context,
                                            listen: false)
                                            .setDateForPeriodicalDelivery(
                                            "Friday");
                                      },
                                      color: context
                                          .watch<CartViewModel>()
                                          .cart
                                          .periodicalDeliveryDate[
                                      "Friday"] ==
                                          true
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context)
                                          .primaryColorLight,
                                      elevation: 0,
                                      child: Text(
                                        "Friday",
                                        style: TextStyle(
                                            color: context
                                                .watch<
                                                CartViewModel>()
                                                .cart
                                                .periodicalDeliveryDate[
                                            "Friday"] ==
                                                true
                                                ? Theme.of(context)
                                                .iconTheme
                                                .color
                                                : Theme.of(context)
                                                .tabBarTheme
                                                .unselectedLabelColor,
                                            fontSize: width * 0.025),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: MaterialButton(
                                      onPressed: () {
                                        Provider.of<CartViewModel>(
                                            context,
                                            listen: false)
                                            .setDateForPeriodicalDelivery(
                                            "Saturday");
                                      },
                                      color: context
                                          .watch<CartViewModel>()
                                          .cart
                                          .periodicalDeliveryDate[
                                      "Saturday"] ==
                                          true
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context)
                                          .primaryColorLight,
                                      elevation: 0,
                                      child: Text(
                                        "Saturday",
                                        style: TextStyle(
                                            color: context
                                                .watch<
                                                CartViewModel>()
                                                .cart
                                                .periodicalDeliveryDate[
                                            "Saturday"] ==
                                                true
                                                ? Theme.of(context)
                                                .iconTheme
                                                .color
                                                : Theme.of(context)
                                                .tabBarTheme
                                                .unselectedLabelColor,
                                            fontSize: width * 0.025),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: MaterialButton(
                                      onPressed: () {
                                        Provider.of<CartViewModel>(
                                            context,
                                            listen: false)
                                            .setDateForPeriodicalDelivery(
                                            "Sunday");
                                      },
                                      color: context
                                          .watch<CartViewModel>()
                                          .cart
                                          .periodicalDeliveryDate[
                                      "Sunday"] ==
                                          true
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context)
                                          .primaryColorLight,
                                      elevation: 0,
                                      child: Text(
                                        "Sunday",
                                        style: TextStyle(
                                            color: context
                                                .watch<
                                                CartViewModel>()
                                                .cart
                                                .periodicalDeliveryDate[
                                            "Sunday"] ==
                                                true
                                                ? Theme.of(context)
                                                .iconTheme
                                                .color
                                                : Theme.of(context)
                                                .tabBarTheme
                                                .unselectedLabelColor,
                                            fontSize: width * 0.025),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Delivery Time",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .iconTheme
                                          .color,
                                      fontSize: width * 0.03,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  RadioListTile<String>(
                                    value: "Office Hours",
                                    groupValue: context
                                        .watch<CartViewModel>()
                                        .cart
                                        .periodicalDeliveryTime,
                                    onChanged: (value) {
                                      // print(value);
                                      Provider.of<CartViewModel>(context,
                                          listen: false)
                                          .setTimeForPeriodicalDelivery(
                                          value!);
                                    },
                                    title: Text(
                                      "Office Hours (8AM - 6PM)",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .iconTheme
                                            .color,
                                        fontSize: width * 0.025,
                                      ),
                                    ),
                                    activeColor:
                                    Theme.of(context).primaryColor,
                                  ),
                                  RadioListTile<String>(
                                    value: "After 6PM",
                                    groupValue: context
                                        .watch<CartViewModel>()
                                        .cart
                                        .periodicalDeliveryTime,
                                    onChanged: (value) {
                                      // print(value);
                                      Provider.of<CartViewModel>(context,
                                          listen: false)
                                          .setTimeForPeriodicalDelivery(
                                          value!);
                                    },
                                    title: Text(
                                      "After 6PM",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .iconTheme
                                            .color,
                                        fontSize: width * 0.025,
                                      ),
                                    ),
                                    activeColor:
                                    Theme.of(context).primaryColor,
                                  ),
                                ],
                              )
                            ],
                          )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: width,
                child: Row(
                  children: [
                    Flexible(
                      flex: 7,
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            cart.foodsOrdered.isNotEmpty ? Text(
                              "Delivery: \$${context.watch<CartViewModel>().cart.deliveryCost}",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .tabBarTheme
                                      .unselectedLabelColor,
                                  fontSize: width * 0.02),
                            ) : Container(),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              "Total: \$${cart.foodsOrdered.isEmpty ? "0.0" : context.watch<CartViewModel>().cart.totalCost}",
                              style: TextStyle(
                                  color: Theme.of(context).iconTheme.color,
                                  fontSize: width * 0.03),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: SizedBox(
                        height: height * 0.15,
                        child: MaterialButton(
                          onPressed: () {
                            final isValid = formKey.currentState!.validate();

                            if (cart.foodsOrdered.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  _customSnackBar("Cart is empty"));
                            }

                            if (isValid) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(_customSnackBar("Done"));
                              String customerName =
                                  _nameEditingController.value.text;
                              String customerPhoneNumber =
                                  _phoneNumberEditingController.value.text;
                              String customerAddress =
                                  _addressEditingController.value.text;
                              String customerNote =
                                  _noteEditingController.value.text;

                              Provider.of<CartViewModel>(context, listen: false)
                                  .setCustomerInformation(
                                  customerName,
                                  customerPhoneNumber,
                                  customerAddress,
                                  customerNote,
                                  DateTime.now()
                                      .microsecondsSinceEpoch
                                      .toString());
                            }
                          },
                          elevation: 0,
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            "Order",
                            style: TextStyle(
                                color: Theme.of(context).iconTheme.color,
                                fontSize: width * 0.03),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameEditingController.dispose();
    _noteEditingController.dispose();
    _addressEditingController.dispose();
    _phoneNumberEditingController.dispose();
  }
}

enum PeriodicalDeliveryTime { officeHours, after6PM }

class _CustomTextField extends StatelessWidget {
  final String label;
  final TextInputType inputType;
  final TextEditingController controller;

  const _CustomTextField(
      {Key? key,
      required this.label,
      required this.inputType,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: TextFormField(
        keyboardType: inputType,
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
              fontSize: width * 0.025,
            ),
            fillColor: Theme.of(context).primaryColorLight,
            contentPadding: EdgeInsets.all(width * 0.01)),
        style: TextStyle(
          color: Theme.of(context).iconTheme.color,
          fontSize: width * 0.025,
        ),
      ),
    );
  }
}

SnackBar _customSnackBar(String content) {
  return SnackBar(content: Text(content));
}

class _SignInFirst extends StatelessWidget {
  const _SignInFirst({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.fromLTRB(width * 0.08, width * 0.05, width * 0.08, width * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            flex: 12,
            fit: FlexFit.tight,
            child: Center(
              child: Text(
                "You must sign in first",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).iconTheme.color,
                  fontSize: width * 0.03,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: MaterialButton(
              elevation: 0,
              height: width*0.1,
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/$AccountScreen");
              },
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "Sign in",
                style: TextStyle(
                    color: Theme.of(context).iconTheme.color,
                    fontSize: width * 0.045),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
