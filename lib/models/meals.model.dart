class MenuItem {
  String? name;
  String? imageUrl;
  String? description;
  double? price;
  double? rating;
  String? category;
  int? quantity;
  double? totalPrice;
  String? state;
  String? phoneNumber;
  String? userId;
  String? address;
  MenuItem({
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.rating,
    required this.category,
  });

  MenuItem.fromJson(Map<String, dynamic> data) {
    name = data['name'];
    imageUrl = data['imageUrl'];
    description = data['description'];
    price = data['price'];
    rating = data['rating'];
    category = data['category'];
    quantity = data['quantity'];
    address = data['address'];
    totalPrice = data['totalPrice'];
    phoneNumber = data['phoneNumber'];
    state = data['state'];
    userId = data['userId'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'price': price,
      'rating': rating,
      'category': category,
      'quantity': quantity,
      'address': address,
      'totalPrice': totalPrice,
      'phoneNumber': phoneNumber,
      'state': state,
      'userId': userId,
    };
  }
}
