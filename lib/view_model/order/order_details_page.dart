import 'package:flutter/material.dart';
import '../../../data/model/order_model.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsPage({super.key, required this.order});

  double get totalAmount =>
      order.products.fold(
          0, (sum, item) => sum + double.parse(item.price) * item.quantity);

  int get totalItems =>
      order.products.fold(0, (sum, item) => sum + item.quantity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order #${order.orderNumber}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text("Status: ${order.status}",
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text("Date: ${order.createdAt}"),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: order.products.length,
                itemBuilder: (_, index) {
                  final product = order.products[index];
                  return Card(
                    child: ListTile(
                      leading: Image.network(
                        product.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(product.name),
                      subtitle: Text(
                          "Qty: ${product.quantity} x ₹${product.price}"),
                      trailing: Text(
                          "₹${double.parse(product.price) * product.quantity}"),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Items: $totalItems",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("Total Amount: ₹$totalAmount",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }
}