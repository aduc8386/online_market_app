import 'package:flutter/material.dart';
import 'package:funix_assignment/viewmodel/cart_viewmodel.dart';
import 'package:funix_assignment/viewmodel/food_dialog_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../model/food.dart';
import '../../model/food.dart';
import '../../widget/food_widget.dart';

class InformationDialogTablet {
  static void showInformationDialog(BuildContext context, Food food) =>
      showDialog(
        context: context,
        builder: (mContext) {
          double width = MediaQuery.of(mContext).size.width;

          return Center(
            child: Dialog(
              backgroundColor: Theme.of(context).backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(width * 0.03),
              ),
              elevation: 0,
              child: _FoodInformationTablet(
                food: food,
              ),
            ),
          );
        },
      );
}

class _FoodInformationTablet extends StatefulWidget {
  const _FoodInformationTablet({Key? key, required this.food}) : super(key: key);
  final Food food;

  @override
  State<_FoodInformationTablet> createState() => _FoodInformationTabletState(food);
}

class _FoodInformationTabletState extends State<_FoodInformationTablet> {
  final Food food;

  _FoodInformationTabletState(this.food);

  @override
  void initState() {
    super.initState();
    Provider.of<FoodDialogViewModel>(context, listen: false).quantity = 0;
  }

  @override
  Widget build(BuildContext context) {
    int quantity = context.watch<FoodDialogViewModel>().quantity;
    double totalCost =
        context.read<FoodDialogViewModel>().getTotalCost(food.price);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(width * 0.04),
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
                  height: height * 0.25,
                  width: width * 0.3,
                  child: Hero(
                      tag: food.imageUrl,
                      child: ProductAvatar(imageUrl: food.imageUrl)),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
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
                    "\$${food.price}",
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
            food.desc!,
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
                        .addToCart(food: food, quantity: quantity);
                    Navigator.pop(context);
                  }
                },
                height: height*0.08,
                color: Theme.of(context).primaryColor,
                minWidth: 300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(width * 0.008),
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
    );
  }
}
