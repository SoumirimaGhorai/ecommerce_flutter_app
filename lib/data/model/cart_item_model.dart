class CartItemModel {
  String? id;
  String? productId;
  String? name;
  String? price;
  int? quantity;
  String? image;

  CartItemModel({
    this.id,
    this.productId,
    this.name,
    this.price,
    this.quantity,
    this.image,
  });

  CartItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    productId = json['product_id'].toString();
    name = json['name'];
    price = json['price'];
    quantity = json['quantity'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'image': image,
    };
  }
}