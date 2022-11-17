import 'package:flutter/material.dart';
import 'package:funix_assignment/helper/shared_preferences_helper.dart';
import 'package:funix_assignment/viewmodel/cart_viewmodel.dart';
import 'package:funix_assignment/viewmodel/food_dialog_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../model/food.dart';
import '../../widget/food_widget.dart';

class InformationDialog {
  static void showFoodDetailDialog(BuildContext context, Food food) =>
      showDialog(
        context: context,
        builder: (mContext) {
          double width = MediaQuery.of(mContext).size.width;

          return Center(
            child: Dialog(
              backgroundColor: Theme.of(context).backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(width * 0.04),
              ),
              elevation: 0,
              child: _FoodDetail(
                food: food,
              ),
            ),
          );
        },
      );

  static void showFoodOrderedDetailDialog(
          BuildContext context, Food food, int quantity) =>
      showDialog(
        context: context,
        builder: (mContext) {
          double width = MediaQuery.of(mContext).size.width;

          return Center(
            child: Dialog(
              backgroundColor: Theme.of(context).backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(width * 0.04),
              ),
              elevation: 0,
              child: _FoodOrderedDetail(
                food: food,
                quantity: quantity,
              ),
            ),
          );
        },
      );
}

class _FoodDetail extends StatefulWidget {
  const _FoodDetail({Key? key, required this.food}) : super(key: key);
  final Food food;

  @override
  State<_FoodDetail> createState() => _FoodDetailState();
}

class _FoodDetailState extends State<_FoodDetail> {
  @override
  void initState() {
    super.initState();
    Provider.of<FoodDialogViewModel>(context, listen: false).quantity = 0;
  }

  @override
  Widget build(BuildContext context) {
    int quantity = context.watch<FoodDialogViewModel>().quantity;
    double totalCost =
        context.read<FoodDialogViewModel>().getTotalCost(widget.food.price);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(width * 0.04),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                  child: SizedBox(
                    height: height * 0.15,
                    width: width * 0.35,
                    child: Hero(
                        tag: widget.food.imageUrl,
                        child: ProductAvatar(imageUrl: widget.food.imageUrl)),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.food.name,
                      style: TextStyle(
                        color: Theme.of(context).iconTheme.color,
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.05,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "\$${widget.food.price}",
                      style: TextStyle(
                        color: Theme.of(context).iconTheme.color,
                        fontSize: width * 0.03,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Description",
              style: TextStyle(
                color: Theme.of(context).iconTheme.color,
                fontWeight: FontWeight.bold,
                fontSize: width * 0.04,
                letterSpacing: 1,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              widget.food.desc!,
              style: TextStyle(
                color: Theme.of(context).tabBarTheme.unselectedLabelColor,
                fontStyle: FontStyle.italic,
                fontSize: width * 0.03,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    context.read<FoodDialogViewModel>().decreaseQuantity();
                  },
                  child: Icon(
                    Icons.remove,
                    size: width * 0.05,
                  ),
                ),
                Text(
                  quantity.toString(),
                  style: TextStyle(
                    color: Theme.of(context).iconTheme.color,
                    fontSize: width * 0.04,
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.read<FoodDialogViewModel>().increaseQuantity();
                  },
                  child: Icon(
                    Icons.add,
                    size: width * 0.05,
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    if (quantity > 0) {
                      Provider.of<CartViewModel>(context, listen: false)
                          .addToCart(food: widget.food, quantity: quantity);
                      Navigator.pop(context);
                      SharedPreferencesHelper.setFoodsOrdered(Provider.of<CartViewModel>(context, listen: false).cart.foodsOrdered);
                      SharedPreferencesHelper.setTotalCost(Provider.of<CartViewModel>(context, listen: false).cart.totalCost);
                    }
                  },
                  color: Theme.of(context).primaryColor,
                  minWidth: 150,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.025),
                  ),
                  elevation: 0,
                  child: Text(
                    "\$${totalCost.toString()}",
                    style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontSize: width * 0.04,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _FoodOrderedDetail extends StatefulWidget {
  const _FoodOrderedDetail(
      {Key? key, required this.food, required this.quantity})
      : super(key: key);
  final Food food;
  final int quantity;

  @override
  State<_FoodOrderedDetail> createState() => _FoodOrderedDetailState();
}

class _FoodOrderedDetailState extends State<_FoodOrderedDetail> {
  @override
  void initState() {
    super.initState();
    Provider.of<FoodDialogViewModel>(context, listen: false).quantity =
        widget.quantity;
  }

  @override
  Widget build(BuildContext context) {
    int quantity = context.watch<FoodDialogViewModel>().quantity;
    double totalCost =
        context.read<FoodDialogViewModel>().getTotalCost(widget.food.price);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(width * 0.04),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                  child: SizedBox(
                    height: height * 0.15,
                    width: width * 0.35,
                    child: Hero(
                        tag: widget.food.imageUrl,
                        child: ProductAvatar(imageUrl: widget.food.imageUrl)),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.food.name,
                      style: TextStyle(
                        color: Theme.of(context).iconTheme.color,
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.05,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "\$${widget.food.price}",
                      style: TextStyle(
                        color: Theme.of(context).iconTheme.color,
                        fontSize: width * 0.03,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Description",
              style: TextStyle(
                color: Theme.of(context).iconTheme.color,
                fontWeight: FontWeight.bold,
                fontSize: width * 0.04,
                letterSpacing: 1,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              widget.food.desc!,
              style: TextStyle(
                color: Theme.of(context).tabBarTheme.unselectedLabelColor,
                fontStyle: FontStyle.italic,
                fontSize: width * 0.03,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    context.read<FoodDialogViewModel>().decreaseQuantity();
                  },
                  child: Icon(
                    Icons.remove,
                    size: width * 0.05,
                  ),
                ),
                Text(
                  quantity.toString(),
                  style: TextStyle(
                    color: Theme.of(context).iconTheme.color,
                    fontSize: width * 0.04,
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.read<FoodDialogViewModel>().increaseQuantity();
                  },
                  child: Icon(
                    Icons.add,
                    size: width * 0.05,
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    Provider.of<CartViewModel>(context, listen: false)
                        .updateCart(food: widget.food, quantity: quantity);
                    Navigator.pop(context);
                    SharedPreferencesHelper.setFoodsOrdered(Provider.of<CartViewModel>(context, listen: false).cart.foodsOrdered);
                    SharedPreferencesHelper.setTotalCost(Provider.of<CartViewModel>(context, listen: false).cart.totalCost);
                  },
                  color: Theme.of(context).primaryColor,
                  minWidth: 150,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.025),
                  ),
                  elevation: 0,
                  child: Text(
                    quantity > 0 ? "\$${totalCost.toString()}" : "Remove",
                    style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontSize: width * 0.04,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
