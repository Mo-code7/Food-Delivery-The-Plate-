import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_food_app/common/color_extension.dart';
import 'package:delivery_food_app/models/meals.model.dart';
import 'package:flutter/material.dart';

import '../more/my_order_view.dart';
import 'item_details_view.dart';

class MenuItemsView extends StatefulWidget {
  final Map mObj;
  const MenuItemsView({super.key, required this.mObj});

  @override
  State<MenuItemsView> createState() => _MenuItemsViewState();
}

List<MenuItem> menuItems = [];

class _MenuItemsViewState extends State<MenuItemsView> {
  bool isLoading = true;
  TextEditingController txtSearch = TextEditingController();
  @override
  void initState() {
    getMenuItems(widget.mObj["name"].toString());

    super.initState();
  }

  Future<void> getMenuItems(String category) async {
    try {
      CollectionReference menuRef =
          FirebaseFirestore.instance.collection('menu');

      QuerySnapshot snapshot =
          await menuRef.where('category', isEqualTo: category).get();

      menuItems = snapshot.docs
          .map((e) => MenuItem.fromJson(e.data() as Map<String, dynamic>))
          .toList();
      print('menuItems: ${menuItems}');
    } catch (e) {
      menuItems = [];
      print('Error fetching $category items: $e');
    }
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset("assets/img/btn_back.png",
                          width: 20, height: 20),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        widget.mObj["name"].toString(),
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
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
                        width: 25,
                        height: 25,
                        color: TColor.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: TColor.primary,
                      ),
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: menuItems.length,
                      itemBuilder: ((context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ItemDetailsView(
                                          item: menuItems[index],
                                        )),
                              );
                            },
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                Container(
                                  width: double.maxFinite,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          menuItems[index].imageUrl ?? ''),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.maxFinite,
                                  height: 200,
                                  decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                        Colors.transparent,
                                        Colors.transparent,
                                        Colors.black
                                      ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter)),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            menuItems[index].name ?? '',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: TColor.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                "assets/img/rate.png",
                                                width: 10,
                                                height: 10,
                                                color: TColor.primary,
                                                fit: BoxFit.cover,
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                menuItems[index]
                                                    .rating
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: TColor.primary,
                                                    fontSize: 11),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                menuItems[index].category ?? '',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: TColor.white,
                                                    fontSize: 11),
                                              ),
                                              Text(
                                                " . ",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: TColor.primary,
                                                    fontSize: 11),
                                              ),
                                              Text(
                                                menuItems[index].category ?? '',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: TColor.white,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 22,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
