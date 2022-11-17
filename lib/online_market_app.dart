import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:funix_assignment/responsive/tablet/app_drawer_tablet.dart';
import 'package:funix_assignment/model/custom_user.dart';
import 'package:funix_assignment/responsive/mobile/app_tab_bar_mobile.dart';
import 'package:funix_assignment/responsive/tablet/app_tab_bar_tablet.dart';
import 'package:funix_assignment/screen/account_screen.dart';
import 'package:funix_assignment/screen/cart_screen.dart';
import 'package:funix_assignment/screen/favorite_screen.dart';
import 'package:funix_assignment/screen/history_screen.dart';
import 'package:funix_assignment/screen/sign_in_screen.dart';
import 'package:funix_assignment/screen/sign_up_screen.dart';
import 'package:funix_assignment/service/firebase_auth_service.dart';
import 'package:funix_assignment/helper/shared_preferences_helper.dart';
import 'package:funix_assignment/viewmodel/cart_viewmodel.dart';
import 'package:funix_assignment/viewmodel/food_dialog_viewmodel.dart';
import 'package:funix_assignment/viewmodel/food_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'responsive/mobile/app_drawer.dart';
import 'app_themes.dart';
import 'key/global_key.dart';
import 'screen/home_screen.dart';
import 'screen/store_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferencesHelper.init();
  FoodViewModel.initial();
  CartViewModel.initial();

  runApp(const FoodApp());
}

class FoodApp extends StatefulWidget {
  const FoodApp({Key? key}) : super(key: key);

  @override
  State<FoodApp> createState() => _FoodAppState();
}

class _FoodAppState extends State<FoodApp> {
  int currentBottomNavigationIndex = 0;
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => FoodViewModel.instance()),
        ChangeNotifierProvider(create: (context) => CartViewModel.instance()),
        ChangeNotifierProvider(create: (context) => FoodDialogViewModel()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, child) {
          return StreamProvider<User?>.value(
            initialData: FirebaseAuthService().currentUser,
            value: FirebaseAuthService().userStream,
            catchError: (_, __) => null,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              scaffoldMessengerKey: snackBarKey,
              themeMode: Provider.of<ThemeProvider>(context).themeMode,
              theme: AppThemes.light,
              darkTheme: AppThemes.dark,
              home: Builder(builder: (context) {
                double width = MediaQuery.of(context).size.width;
                Provider.of<CartViewModel>(context).cart.foodsOrdered = SharedPreferencesHelper.getFoodsOrdered();
                Provider.of<CartViewModel>(context).cart.totalCost = SharedPreferencesHelper.getTotalCost();
                return FutureBuilder(
                  future: firebase,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Something went wrong"),
                      );
                    }
                    return snapshot.hasData
                        ? Scaffold(
                            appBar: _appBar(width),
                            drawer: width < 600
                                ? FoodAppDrawer()
                                : FoodAppDrawerTablet(),
                            body: currentBottomNavigationIndex == 1
                                ? StoreScreen()
                                : HomeScreen(),
                            bottomNavigationBar: BottomNavigationBar(
                              currentIndex: currentBottomNavigationIndex,
                              onTap: (index) {
                                setState(() {
                                  currentBottomNavigationIndex = index;
                                });
                              },
                              elevation: 0,
                              items: const [
                                BottomNavigationBarItem(
                                  icon: Icon(
                                    Icons.home,
                                  ),
                                  label: "Home",
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(
                                    Icons.store,
                                  ),
                                  label: "Store",
                                ),
                              ],
                            ),
                          )
                        : Scaffold(
                            body: CircularProgressIndicator(
                              backgroundColor: Theme.of(context).backgroundColor,
                              color: Theme.of(context).primaryColor,
                            ),
                          );
                  },
                );
              }),
              initialRoute: "/",
              routes: {
                "/$CartScreen": (_) => const CartScreen(),
                "/$AccountScreen": (_) => const AccountScreen(),
                "/$FavoriteScreen": (_) => const FavoriteScreen(),
                "/$HistoryScreen": (_) => const HistoryScreen(),
              },
              //
              // onGenerateRoute: (settings) {
              //   late Widget screen;
              //
              //   if (settings.name == "/$CartScreen") {
              //     screen = const CartScreen();
              //   } else if(settings.name == "/$AccountScreen") {
              //     screen = const AccountScreen();
              //   } else if(settings.name == "/$HistoryScreen") {
              //     screen = const HistoryScreen();
              //   } else if(settings.name == "/$FavoriteScreen") {
              //     screen = const FavoriteScreen();
              //   } else if(settings.name!.startsWith("/$AccountScreen/")) {
              //     final subRoute =
              //     settings.name!.substring("/$AccountScreen/".length);
              //     screen =
              //   } else if(settings.name == "/$SignUpScreen") {
              //     screen = SignUpScreen();
              //   }
              //
              //   return MaterialPageRoute(
              //     builder: (context) {
              //       return screen;
              //     },
              //     settings: settings,
              //   );
              // },
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _appBar(double width) {
    if (width < 600) {
      return AppBarMobile();
    } else {
      return AppBarTablet();
    }
  }
}
