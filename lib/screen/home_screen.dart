import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:funix_assignment/responsive/mobile/information_dialog.dart';
import 'package:funix_assignment/responsive/tablet/information_dialog_tablet.dart';
import 'package:funix_assignment/viewmodel/food_viewmodel.dart';

import '../model/food.dart';
import '../widget/food_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController scrollController = ScrollController();
  bool isBannerClosed = false;

  // List<Food> foods = Database.foods;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      setState(() {
        isBannerClosed = scrollController.offset > 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double bannerHeight = MediaQuery.of(context).size.height * 0.25;

    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    return orientation == Orientation.portrait
        ? Container(
            color: Theme.of(context).backgroundColor,
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 6),
                    child: AnimatedContainer(
                      // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      height: isBannerClosed ? 0 : bannerHeight,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: NetworkImage(
                            "https://images.unsplash.com/photo-1606787366850-de6330128bfc?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8Zm9vZCUyMHdhbGxwYXBlcnxlbnwwfHwwfHw%3D&w=1000&q=80",
                          ),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      duration: Duration(milliseconds: 1000),
                      alignment: Alignment.topCenter,
                      curve: Curves.ease,
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: FoodViewModel.instance().getFoods(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (snapshot.hasData) {
                          List<Food> foods = snapshot.data! as List<Food>;
                          return width < 600
                              ? MasonryGridView.count(
                                  primary: false,
                                  controller: scrollController,
                                  padding: const EdgeInsets.all(35),
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  crossAxisCount: 2,
                                  itemCount: foods.length,
                                  itemBuilder: (BuildContext context,
                                          int index) =>
                                      FoodCard(food: foods[index]),
                                )
                              : MasonryGridView.count(
                                  primary: false,
                                  controller: scrollController,
                                  padding: const EdgeInsets.all(50),
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  crossAxisCount: 3,
                                  itemCount: foods.length,
                                  itemBuilder: (BuildContext context,
                                          int index) =>
                                      FoodCard(food: foods[index]),
                                );
                        } else {
                          return SpinKitChasingDots(
                            color: Theme.of(context).primaryColor,
                            size: width * 0.08,
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        : Container(
            color: Theme.of(context).backgroundColor,
            child: Center(
              child: Row(
                children: [
                  Expanded(
                    child: FutureBuilder(
                      future: FoodViewModel.instance().getFoods(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (snapshot.hasData) {
                          List<Food> foods = snapshot.data! as List<Food>;
                          return orientation == Orientation.landscape
                              ? MasonryGridView.count(
                                  primary: false,
                                  controller: scrollController,
                                  padding: const EdgeInsets.all(35),
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  crossAxisCount: 3,
                                  itemCount: foods.length,
                                  itemBuilder: (BuildContext context,
                                          int index) =>
                                      InkWell(
                                          onTap: () {
                                            InformationDialog
                                                .showFoodDetailDialog(
                                                    context, foods[index]);
                                          },
                                          child: FoodCard(food: foods[index])),
                                )
                              : width < 600
                                  ? MasonryGridView.count(
                                      primary: false,
                                      controller: scrollController,
                                      padding: const EdgeInsets.all(35),
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      crossAxisCount: 2,
                                      itemCount: foods.length,
                                      itemBuilder: (BuildContext context,
                                              int index) =>
                                          InkWell(
                                              onTap: () {
                                                InformationDialog
                                                    .showFoodDetailDialog(
                                                        context, foods[index]);
                                              },
                                              child:
                                                  FoodCard(food: foods[index])),
                                    )
                                  : MasonryGridView.count(
                                      primary: false,
                                      controller: scrollController,
                                      padding: const EdgeInsets.all(50),
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20,
                                      crossAxisCount: 3,
                                      itemCount: foods.length,
                                      itemBuilder: (BuildContext context,
                                              int index) =>
                                          InkWell(
                                              onTap: () {
                                                InformationDialogTablet
                                                    .showInformationDialog(
                                                        context, foods[index]);
                                              },
                                              child:
                                                  FoodCard(food: foods[index])),
                                    );
                        } else {
                          return SpinKitChasingDots(
                            color: Theme.of(context).primaryColor,
                            size: width * 0.08,
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          );
  }

// Widget portraitLayout () {
//
// }
}
