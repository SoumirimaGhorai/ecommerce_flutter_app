class OrderProductModel {
  final int id;
  final String name;
  final int quantity;
  final String price;
  final String image;

  OrderProductModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.image,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      quantity: int.tryParse(json['quantity'].toString()) ?? 0,
      price: json['price']?.toString() ?? '0',
      image: json['image'] ?? '',
    );
  }
}

class OrderModel {
  final int id;
  final String orderNumber;
  final String totalAmount;
  final String status;
  final String createdAt;
  final List<OrderProductModel> products;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.products,
  });

  ///  COMPUTED TOTAL ITEMS (NO ERRORS)
  int get totalItems {
    return products.fold<int>(
      0,
          (sum, item) => sum + item.quantity,
    );
  }
  ///  TOTAL AMOUNT (price × quantity)
  double get totalAmounts {
    return products.fold<double>(
      0.0,
          (sum, item) {
        final price = double.tryParse(item.price) ?? 0.0;
        return sum + (price * item.quantity);
      },
    );
  }
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final productList = json['product'] as List? ?? [];

    return OrderModel(
      id: json['id'] ?? 0,
      orderNumber: json['order_number']?.toString() ?? '',
      totalAmount: json['total_amount']?.toString() ?? '0',
      status: json['status'] == "1" ? "Completed" : "Pending",
      createdAt: json['created_at']?.toString() ?? '',
      products: productList
          .map((e) => OrderProductModel.fromJson(e))
          .toList(),
    );
  }
}