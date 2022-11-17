import 'package:flutter/material.dart';
import 'package:funix_assignment/service/firestore_service.dart';

import '../model/food.dart';
import '../responsive/mobile/information_dialog.dart';



class FoodCard extends StatefulWidget {
  final Food food;

  const FoodCard({Key? key, required this.food}) : super(key: key);

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  bool isLiked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setLiked();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final orientation = MediaQuery.of(context).orientation;

    return orientation == Orientation.landscape
        ? DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Card(
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        InformationDialog.showFoodDetailDialog(
                            context, widget.food);
                      },
                      child: SizedBox(
                        height: height * 0.25,
                        width: width * 0.25,
                        child: ProductAvatar(
                          imageUrl: widget.food.imageUrl,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print(widget.food.name);
                      },
                      child: Transform.translate(
                        offset: Offset(width * 0.08, -width * 0.12),
                        child: Icon(
                          widget.food.isLiked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Theme.of(context).iconTheme.color,
                          size: 32,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        InformationDialog.showFoodDetailDialog(
                            context, widget.food);
                      },
                      child: SizedBox(
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.food.name,
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).iconTheme.color,
                                        fontSize: 16,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "\$${widget.food.price.toString()}",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .tabBarTheme
                                            .unselectedLabelColor,
                                        fontSize: 14,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(0, 0, width * 0.04, 0),
                              child: Icon(
                                Icons.add_shopping_cart,
                                color: Theme.of(context).iconTheme.color,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : width < 600
            ? DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            InformationDialog.showFoodDetailDialog(
                                context, widget.food);
                          },
                          child: SizedBox(
                            height: height * 0.15,
                            width: width * 0.35,
                            child: ProductAvatar(
                              imageUrl: widget.food.imageUrl,
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(width * 0.11, -width * 0.25),
                          child: InkWell(
                            onTap: () async {
                              await FirestoreService().setLiked(widget.food);
                              setLiked();
                              // FirestoreService().favoriteFoods.doc(widget.food.name) != null ?  : ;
                            },
                            child: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: Theme.of(context).iconTheme.color,
                              size: 32,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            InformationDialog.showFoodDetailDialog(
                                context, widget.food);
                          },
                          child: SizedBox(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.food.name,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                            fontSize: 16,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "\$${widget.food.price.toString()}",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .tabBarTheme
                                                .unselectedLabelColor,
                                            fontSize: 14,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      0, 0, width * 0.05, 0),
                                  child: Icon(
                                    Icons.add_shopping_cart,
                                    color: Theme.of(context).iconTheme.color,
                                    size: 32,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.15,
                          width: width * 0.22,
                          child: Hero(
                              tag: widget.food.imageUrl,
                              child: ProductAvatar(
                                imageUrl: widget.food.imageUrl,
                              )),
                        ),
                        Transform.translate(
                          offset: Offset(width * 0.08, -width * 0.17),
                          child: Icon(
                            Icons.favorite_border,
                            color: Theme.of(context).iconTheme.color,
                            size: 36,
                          ),
                        ),
                        SizedBox(
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.food.name,
                                        style: TextStyle(
                                          color:
                                              Theme.of(context).iconTheme.color,
                                          fontSize: width * 0.025,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "\$${widget.food.price.toString()}",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .tabBarTheme
                                              .unselectedLabelColor,
                                          fontSize: width * 0.02,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0, 0, width * 0.025, 0),
                                child: Icon(
                                  Icons.add_shopping_cart,
                                  color: Theme.of(context).iconTheme.color,
                                  size: 32,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
  }

  void setLiked() async {
    isLiked = await FirestoreService().isLiked(widget.food);
    if (!mounted) {
      return;
    }
    setState(() {});
  }
}

class ProductAvatar extends StatelessWidget {
  final String imageUrl;

  const ProductAvatar({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
