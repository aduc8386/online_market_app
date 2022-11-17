import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:funix_assignment/service/firebase_auth_service.dart';
import 'package:funix_assignment/viewmodel/food_viewmodel.dart';

import '../responsive/mobile/information_dialog.dart';
import '../model/food.dart';
import '../widget/food_widget.dart';
import 'account_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

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
            "Favorite",
            style: TextStyle(
              color: Theme.of(context).iconTheme.color,
              fontSize: width * 0.055,
            ),
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
        ),
        body: FirebaseAuthService().currentUser == null
            ? _SignInFirst()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        width * 0.08, width * 0.05, width * 0.08, 0),
                    child: Text(
                      "These are all foods you have liked",
                      style: TextStyle(
                        color: Theme.of(context).iconTheme.color,
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: FoodViewModel.instance().getFavoriteFoods(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Error"),
                          );
                        } else if (snapshot.hasData) {
                          List<Food> favoriteFoods =
                              snapshot.data as List<Food>;
                          return favoriteFoods.isEmpty
                              ? Center(
                                  child: Text(
                                    "You have not like any food",
                                    style: TextStyle(
                                      color: Theme.of(context).iconTheme.color,
                                      fontSize: width * 0.03,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                )
                              : MasonryGridView.count(
                                  primary: false,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 35),
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  crossAxisCount: 2,
                                  itemCount: favoriteFoods.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          InkWell(
                                              onTap: () {
                                                InformationDialog
                                                    .showFoodDetailDialog(
                                                        context,
                                                        favoriteFoods[index]);
                                              },
                                              child: FoodCard(
                                                  food: favoriteFoods[index])),
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
                ],
              ));
  }
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
