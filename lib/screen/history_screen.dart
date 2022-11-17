import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:funix_assignment/widget/order_history_widget.dart';
import 'package:funix_assignment/viewmodel/cart_viewmodel.dart';

import '../model/cart.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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
          "History",
          style: TextStyle(
            color: Theme.of(context).iconTheme.color,
            fontSize: width * 0.055,
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            width * 0.08, width * 0.05, width * 0.08, width * 0.05),
        child: FutureBuilder(
          future: CartViewModel.instance().getOrderHistory(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              List<Cart> orderHistory = snapshot.data as List<Cart>;
              return ListView.builder(
                  itemCount: orderHistory.length,
                  itemBuilder: (context, index) {
                    return OrderHistory(orderHistory: orderHistory[index]);
                  });
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return SpinKitChasingDots(
                color: Theme.of(context).primaryColor,
                size: width * 0.08,
              );
            }
          },
        ),
      ),
    );
  }
}
