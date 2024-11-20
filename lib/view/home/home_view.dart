import 'package:delivery_food_app/common/color_extension.dart';
import 'package:delivery_food_app/models/meals.model.dart';
import 'package:delivery_food_app/services/services.dart';
import 'package:delivery_food_app/view/menu/item_details_view.dart';
import 'package:flutter/material.dart';

import '../../common/globs.dart';
import '../../common/service_call.dart';
import '../../common_widget/popular_resutaurant_row.dart';
import '../../common_widget/view_all_title_row.dart';
import '../more/my_order_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<MenuItem> menuItems = [];
  bool isUploading = true;
  TextEditingController txtSearch = TextEditingController();
  @override
  void initState() {
    getMenuItems();
    super.initState();
  }

  void getMenuItems() async {
    menuItems = await Service().getMenuItems();

    isUploading = false;
    setState(() {});
  }

  List catArr = [
    {"image": "assets/img/cat_offer.png", "name": "Offers"},
    {"image": "assets/img/cat_sri.png", "name": "Sri Lankan"},
    {"image": "assets/img/cat_3.png", "name": "Italian"},
    {"image": "assets/img/cat_4.png", "name": "Indian"},
  ];

  List mostPopArr = [
    {
      "image": "assets/img/m_res_1.png",
      "name": "Minute by tuk tuk",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/m_res_2.png",
      "name": "Café de Noir",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
  ];

  List recentArr = [
    {
      "image": "assets/img/item_1.png",
      "name": "Mulberry Pizza by Josh",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/item_2.png",
      "name": "Barita",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
    {
      "image": "assets/img/item_3.png",
      "name": "Pizza Rush Hour",
      "rate": "4.9",
      "rating": "124",
      "type": "Cafa",
      "food_type": "Western Food"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Good morning ${ServiceCall.userPayload[KKey.name] ?? ""}!",
                      style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyOrderView()));
                      },
                      icon: Image.asset(
                        "assets/img/shopping_cart.png",
                        color: TColor.white,
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // SizedBox(
              //   height: 120,
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     padding: const EdgeInsets.symmetric(horizontal: 15),
              //     itemCount: catArr.length,
              //     itemBuilder: ((context, index) {
              //       var cObj = catArr[index] as Map? ?? {};
              //       return CategoryCell(
              //         cObj: cObj,
              //         onTap: () {},
              //       );
              //     }),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ViewAllTitleRow(
                  title: "Menu",
                  onView: () {},
                ),
              ),
              isUploading
                  ? CircularProgressIndicator(
                      color: TColor.primary,
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: menuItems.length,
                      itemBuilder: ((context, index) {
                        return PopularRestaurantRow(
                          name: menuItems[index].name ?? '',
                          imageUrl: menuItems[index].imageUrl ?? '',
                          rating: menuItems[index].rating ?? 0,
                          category: menuItems[index].category ?? '',
                          price: menuItems[index].price ?? 0,
                          description: menuItems[index].description ?? '',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemDetailsView(
                                  item: menuItems[index],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: ViewAllTitleRow(
              //     title: "Most Popular",
              //     onView: () {},
              //   ),
              // ),
              // SizedBox(
              //   height: 200,
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     padding: const EdgeInsets.symmetric(horizontal: 15),
              //     itemCount: mostPopArr.length,
              //     itemBuilder: ((context, index) {
              //       var mObj = mostPopArr[index] as Map? ?? {};
              //       return MostPopularCell(
              //         mObj: mObj,
              //         onTap: () {},
              //       );
              //     }),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: ViewAllTitleRow(
              //     title: "Recent Items",
              //     onView: () {},
              //   ),
              // ),
              // ListView.builder(
              //   physics: const NeverScrollableScrollPhysics(),
              //   shrinkWrap: true,
              //   padding: const EdgeInsets.symmetric(horizontal: 15),
              //   itemCount: recentArr.length,
              //   itemBuilder: ((context, index) {
              //     var rObj = recentArr[index] as Map? ?? {};
              //     return RecentItemRow(
              //       rObj: rObj,
              //       onTap: () {},
              //     );
              //   }),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
