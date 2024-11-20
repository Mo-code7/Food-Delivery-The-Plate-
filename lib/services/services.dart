import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_food_app/models/meals.model.dart';
import 'package:delivery_food_app/view/menu/menu_items_view.dart';
import 'package:delivery_food_app/view/more/my_order_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Service {
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String address = '';
  String phoneNumber = '';
  Future<List<MenuItem>> getMenuItems() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('menu').get();
    menuItems = querySnapshot.docs
        .map((e) => MenuItem.fromJson(e.data() as Map<String, dynamic>))
        .toList();

    return menuItems;
  }

  Future<void> _loadUserData() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    var user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        address = data['address'] ?? '';
        phoneNumber = data['mobile'] ?? '';
        print('Address: $address');
        print('Phone number: $phoneNumber');
      }
    }
  }

  Future<List<String>> showAddressInputDialog(BuildContext context) async {
    String address = '';
    String phoneNumber = '';
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Address'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: addressController,
                decoration:
                    const InputDecoration(hintText: "Enter your address"),
              ),
              TextField(
                controller: phoneController,
                decoration:
                    const InputDecoration(hintText: "Enter your phone number"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                address = addressController.text;
                phoneNumber = phoneController.text;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    return [address, phoneNumber];
  }

  void uploadNewImage() async {
    File? imageFile = await pickImage();

    if (imageFile == null) {
      if (kDebugMode) {
        print('No image selected.');
      }
      return;
    }

    String imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    String? imageUrl = await uploadImage(imageFile, imageName);

    if (imageUrl != null) {
      if (kDebugMode) {
        print('Image URL: $imageUrl');
      }
    } else {
      if (kDebugMode) {
        print('Image upload failed.');
      }
    }
  }

  Future<String?> uploadImage(File imageFile, String imageName) async {
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('menu_images/$imageName');

      UploadTask uploadTask = storageReference.putFile(imageFile);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        if (kDebugMode) {
          print(
              'Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
        }
      });

      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();

      if (kDebugMode) {
        print('Image uploaded successfully: $downloadUrl');
      }
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      return null;
    }
  }

  Future<File?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
      return null;
    }
  }

  Future<void> addMenuItem(
      {required String name,
      required String description,
      required double price,
      required double rating,
      required String category,
      required File imageFile,
      required imageUrl}) async {
    String imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    if (imageUrl == null) {
      if (kDebugMode) {
        print('Failed to upload image.');
      }
      return;
    }

    MenuItem menuItem = MenuItem(
      name: name,
      imageUrl: imageUrl,
      description: description,
      price: price,
      rating: rating,
      category: category,
    );

    try {
      CollectionReference menuRef =
          FirebaseFirestore.instance.collection('menu');

      await menuRef.add(menuItem.toJson());
      if (kDebugMode) {
        print('Menu item added successfully.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding menu item: $e');
      }
    }
  }

  void uploadNewItem() async {
    String name = 'Cold Brew Coffee';
    String description = 'Slow-steeped coffee served over ice.';
    double price = 3.49;
    double rating = 4.5;
    String category = 'Beverages';
    String imageUrl =
        'https://firebasestorage.googleapis.com/v0/b/ordersdelivery-403d3.appspot.com/o/menu_images%2FCold%20Brew%20Coffee.jpg?alt=media&token=e9f8e22e-ade5-41ca-aaa9-e19acd343049';
    File imageFile = File('path/to/your/image.jpg');

    await addMenuItem(
      name: name,
      description: description,
      price: price,
      rating: rating,
      category: category,
      imageFile: imageFile,
      imageUrl: imageUrl,
    );
  }

  Future<void> saveOrder(
    BuildContext context,
    MenuItem orderData,
    int quantity,
  ) async {
    await _loadUserData();
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      print('User ID: $userId');
      orderData.quantity = quantity;
      orderData.address = address;
      orderData.phoneNumber = phoneNumber;
      orderData.totalPrice = orderData.quantity! * orderData.price!;
      orderData.state = 'Pending';
      print('Order data: ${orderData.toJson()}');

      await FirebaseFirestore.instance
          .collection('orders')
          .doc(userId)
          .collection('userOrders')
          .add(orderData.toJson());

      print('Order saved successfully for user: $userId');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Order Submitted'),
            content: Text('Your order has been successfully placed!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyOrderView()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error saving order: $e');
    }
  }
}
