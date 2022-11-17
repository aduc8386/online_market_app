import 'package:flutter/material.dart';
import 'package:funix_assignment/model/food_ordered.dart';
import 'package:funix_assignment/viewmodel/cart_viewmodel.dart';
import 'package:intl/intl.dart';

import '../model/cart.dart';
import '../model/food.dart';

class OrderHistory extends StatefulWidget {
  OrderHistory({Key? key, required this.orderHistory}) : super(key: key);
  final Cart orderHistory;
  bool showDetail = false;

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return widget.showDetail
        ? Card(
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.all(width * 0.03),
              child: Column(
                children: [
                  FutureBuilder(
                      future: CartViewModel.instance()
                          .getFoodsOrdered(widget.orderHistory.checkedOutAt),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<FoodOrdered> foodsOrdered =
                              snapshot.data as List<FoodOrdered>;
                          return Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    fit: FlexFit.tight,
                                    child: Text(
                                      widget.orderHistory.customerName,
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 3,
                                    fit: FlexFit.tight,
                                    child: Text(
                                      DateFormat.yMMMMd('en_US')
                                          .format(
                                            DateTime.fromMicrosecondsSinceEpoch(
                                              int.parse(widget
                                                  .orderHistory.checkedOutAt),
                                            ),
                                          )
                                          .toString(),
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Text(
                                      "\$${widget.orderHistory.totalCost.toString()}",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          widget.showDetail =
                                              !widget.showDetail;
                                        });
                                      },
                                      child: Icon(widget.showDetail
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: foodsOrdered.length,
                                itemBuilder: (context, index) {
                                  int ordinalNum = index + 1;
                                  Food food = foodsOrdered[index].food;
                                  String foodName =
                                      foodsOrdered[index].food.name;
                                  String foodQuantity =
                                      foodsOrdered[index].quantity.toString();
                                  String totalCost =
                                      (foodsOrdered[index].quantity *
                                              foodsOrdered[index].food.price)
                                          .toString();
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Text(
                                              ordinalNum.toString(),
                                              textAlign: TextAlign.center,
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
                                              textAlign: TextAlign.center,
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
                                      Divider(
                                        thickness: 0.5,
                                        color: Theme.of(context).cardColor,
                                      ),
                                      SizedBox(
                                        height: 0.01 * width,
                                      ),
                                    ],
                                  );
                                },
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Text(
                                      "Delivery cost",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: width * 0.025,
                                        color: Theme.of(context).iconTheme.color
                                      ),
                                    ),
                                  ),
                                  Spacer(
                                    flex: 2,
                                  ),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Text(
                                      widget.orderHistory.deliveryCost
                                          .toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).iconTheme.color,
                                        fontSize: width * 0.025,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      })
                ],
              ),
            ),
          )
        : Card(
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.all(width * 0.03),
              child: Column(
                children: [
                  FutureBuilder(
                      future: CartViewModel.instance()
                          .getFoodsOrdered(widget.orderHistory.checkedOutAt),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    fit: FlexFit.tight,
                                    child: Text(
                                      widget.orderHistory.customerName,
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 3,
                                    fit: FlexFit.tight,
                                    child: Text(
                                      DateFormat.yMMMMd('en_US')
                                          .format(
                                            DateTime.fromMicrosecondsSinceEpoch(
                                              int.parse(widget
                                                  .orderHistory.checkedOutAt),
                                            ),
                                          )
                                          .toString(),
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Text(
                                      "\$${widget.orderHistory.totalCost.toString()}",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          widget.showDetail =
                                              !widget.showDetail;
                                        });
                                      },
                                      child: Icon(widget.showDetail
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      })
                ],
              ),
            ),
          );
  }
}
