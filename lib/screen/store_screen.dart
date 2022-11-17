import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:funix_assignment/viewmodel/food_viewmodel.dart';

import '../responsive/mobile/information_dialog.dart';
import '../model/food.dart';
import '../widget/food_widget.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;


    return Container(
      color: Theme.of(context).backgroundColor,
      child: DefaultTabController(
        length: 3,
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
            body: Column(
              children: [
                Container(
                  color: Theme.of(context).backgroundColor,
                  child: TabBar(
                    indicatorColor: Theme.of(context).iconTheme.color,
                    indicatorWeight: 2,
                    tabs: const [
                      Tab(text: "Vegetable"),
                      Tab(text: "Fruit"),
                      Tab(text: "Meat"),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).backgroundColor,
                    child: TabBarView(
                      children: [
                        FutureBuilder(
                          future: FoodViewModel.instance().getVegetables(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final vegetables = snapshot.data as List<Food>;
                              return width < 600 ? MasonryGridView.count(
                                primary: false,
                                padding: const EdgeInsets.all(35),
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount: 2,
                                itemCount: vegetables.length,
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    InkWell(
                                        onTap: () {
                                          InformationDialog
                                              .showFoodDetailDialog(
                                                  context, vegetables[index]);
                                        },
                                        child:
                                            FoodCard(food: vegetables[index])),
                              ) : MasonryGridView.count(
                                primary: false,
                                padding: const EdgeInsets.all(50),
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                crossAxisCount: 3,
                                itemCount: vegetables.length,
                                itemBuilder: (BuildContext context,
                                    int index) =>
                                    InkWell(
                                        onTap: () {
                                          InformationDialog
                                              .showFoodDetailDialog(
                                              context, vegetables[index]);
                                        },
                                        child:
                                        FoodCard(food: vegetables[index])),
                              );
                            } else {
                              return SpinKitChasingDots(
                                color: Theme.of(context).primaryColor,
                                size: width * 0.08,
                              );
                            }
                          },
                        ),
                        FutureBuilder(
                          future: FoodViewModel.instance().getFruits(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final fruits = snapshot.data as List<Food>;
                              return width < 600 ? MasonryGridView.count(
                                primary: false,
                                padding: const EdgeInsets.all(35),
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount: 2,
                                itemCount: fruits.length,
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    InkWell(
                                        onTap: () {
                                          InformationDialog
                                              .showFoodDetailDialog(
                                                  context, fruits[index]);
                                        },
                                        child:
                                            FoodCard(food: fruits[index])),
                              ) : MasonryGridView.count(
                                primary: false,
                                padding: const EdgeInsets.all(50),
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                crossAxisCount: 3,
                                itemCount: fruits.length,
                                itemBuilder: (BuildContext context,
                                    int index) =>
                                    InkWell(
                                        onTap: () {
                                          InformationDialog
                                              .showFoodDetailDialog(
                                              context, fruits[index]);
                                        },
                                        child:
                                        FoodCard(food: fruits[index])),
                              );
                            } else {
                              return SpinKitChasingDots(
                                color: Theme.of(context).primaryColor,
                                size: width * 0.08,
                              );
                            }
                          },
                        ),
                        FutureBuilder(
                          future: FoodViewModel.instance().getMeats(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final meats = snapshot.data as List<Food>;
                              return width < 600 ? MasonryGridView.count(
                                primary: false,
                                padding: const EdgeInsets.all(35),
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount: 2,
                                itemCount: meats.length,
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    InkWell(
                                        onTap: () {
                                          InformationDialog
                                              .showFoodDetailDialog(
                                                  context, meats[index]);
                                        },
                                        child:
                                            FoodCard(food: meats[index])),
                              ) : MasonryGridView.count(
                                primary: false,
                                padding: const EdgeInsets.all(50),
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                crossAxisCount: 3,
                                itemCount: meats.length,
                                itemBuilder: (BuildContext context,
                                    int index) =>
                                    InkWell(
                                        onTap: () {
                                          InformationDialog
                                              .showFoodDetailDialog(
                                              context, meats[index]);
                                        },
                                        child:
                                        FoodCard(food: meats[index])),
                              );
                            } else {
                              return SpinKitChasingDots(
                                color: Theme.of(context).primaryColor,
                                size: width * 0.08,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),

        // child: Scaffold(
        //   body: Column(
        //     children: [
        //       Container(
        //         color: Colors.green[800],
        //         child: TabBar(
        //           labelStyle: TextStyle(
        //             fontSize: 14,
        //             letterSpacing: 1,
        //             color: Colors.white,
        //           ),
        //           indicatorColor: Colors.white,
        //           indicatorWeight: 3,
        //           unselectedLabelColor: Colors.green[300],
        //           tabs: const [
        //             Tab(text: "Vegetable"),
        //             Tab(text: "Meat"),
        //             Tab(text: "Stuffs"),
        //           ],
        //         ),
        //       ),
        //       Expanded(
        //         child: TabBarView(
        //           children: <Widget>[
        //             GridView.count(
        //                 primary: false,
        //                 padding: const EdgeInsets.all(20),
        //                 crossAxisSpacing: 10,
        //                 mainAxisSpacing: 10,
        //                 crossAxisCount: 2,
        //                 children: <Widget>[getList()]),
        //             Center(
        //               child: Text("Meat here"),
        //             ),
        //             Center(
        //               child: Text("Stuffs here"),
        //             ),
        //           ],
        //         ),
        //       )
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
