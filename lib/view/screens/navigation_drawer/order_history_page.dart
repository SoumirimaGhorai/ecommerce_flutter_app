import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/helper/api_helper.dart';
import '../../../data/model/order_model.dart';
import '../../../view_model_bloc/order/order_bloc.dart';
import '../../../view_model_bloc/order/order_event.dart';
import '../../../view_model_bloc/order/order_state.dart';
import 'order_history/order_details_page.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  /// Calculate grand total across all orders
  double _calculateGrandTotal(List<OrderModel> orders) {
    return orders.fold(0, (sum, order) {
      return sum +
          order.products.fold(
              0,
                  (orderSum, item) =>
              orderSum + double.parse(item.price) * item.quantity);
    });
  }

  @override
  void initState() {
    super.initState();
    /// Load orders via BLoC
    context.read<OrderBloc>().add(FetchOrderEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        centerTitle: true,
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrderErrorState) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is OrderLoadedState) {
            if (state.orders.isEmpty) {
              return const Center(child: Text("No orders found"));
            }

            final grandTotal = _calculateGrandTotal(state.orders);

            return Column(
              children: [
                /// GRAND TOTAL DISPLAY
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[200],
                  child: Text(
                    "Grand Total: ₹ ${grandTotal.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                /// ORDER LIST
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: state.orders.length,
                    itemBuilder: (context, index) {
                      final order = state.orders[index];
                      return OrderCard(
                        order: order,
                        onDelete: () {
                          /// Local delete & UI update
                          setState(() {
                            state.orders.removeAt(index);
                          });
                        },
                        onViewDetails: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  OrderDetailsPage(order: order),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

/// Single order card widget
class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onDelete;
  final VoidCallback onViewDetails;

  const OrderCard({
    super.key,
    required this.order,
    required this.onDelete,
    required this.onViewDetails,
  });

  int get totalItems =>
      order.products.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount =>
      order.products.fold(
          0, (sum, item) => sum + double.parse(item.price) * item.quantity);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ORDER ID + STATUS + DELETE ICON
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order #${order.orderNumber}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _statusColor(order.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        order.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 8),

            /// DATE
            Text(
              "Date: ${order.createdAt}",
              style: TextStyle(color: Colors.grey[600]),
            ),

            const Divider(height: 20),

            /// TOTAL ITEMS + AMOUNT
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Items: $totalItems",
                    style: const TextStyle(fontSize: 14)),
                Text("₹ ${totalAmount.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),

            const SizedBox(height: 10),

            /// VIEW DETAILS BUTTON
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onViewDetails,
                child: const Text("View Details"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Status color helper
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }
}