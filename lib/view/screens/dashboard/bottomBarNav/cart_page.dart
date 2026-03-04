import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../view_model_bloc/cart/cart_bloc.dart';
import '../../../../view_model_bloc/cart/cart_event.dart';
import '../../../../view_model_bloc/cart/cart_state.dart';
import '../../../../data/model/cart_item_model.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    /// Load saved cart items
    context.read<CartBloc>().add(LoadLocalCartEvent());
  }

  double _calculateTotal(List<CartItemModel> items) {
    return items.fold(
        0,
            (sum, item) =>
        sum + (double.tryParse(item.price ?? '0') ?? 0) * (item.quantity ?? 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        leadingWidth: 56,
        leading: Container(
          margin: const EdgeInsets.only(left: 12),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey.shade200,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('My Cart', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartErrorState) {
            return Center(child: Text(state.message));
          }

          if (state is CartLoadedState) {
            final cartItems = state.cartItems;

            if (cartItems.isEmpty) {
              return const Center(child: Text('Your cart is empty'));
            }

            final total = _calculateTotal(cartItems);

            return Column(
              children: [
                /// CART LIST
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            // Product Image
                            Image.network(
                              item.image ?? '',
                              width: 70,
                              height: 70,
                              errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image, size: 50),
                            ),
                            const SizedBox(width: 12),

                            // Product Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name ?? '',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Electronics',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 6),
                                  Text('₹${item.price}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),

                            // Actions
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete_forever_outlined,
                                      color: Colors.orange),
                                  onPressed: () {
                                    context.read<CartBloc>().add(
                                        DeleteCartItemEvent(cartId: item.id!));
                                  },
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey.shade200,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if ((item.quantity ?? 1) > 1) {
                                              context.read<CartBloc>().add(
                                                UpdateCartQuantityEvent(
                                                  productId: item.productId!,
                                                  newQuantity:
                                                  (item.quantity ?? 1) - 1,
                                                ),
                                              );
                                            }
                                          },
                                          child: const Icon(Icons.remove, size: 18),
                                        ),
                                        const SizedBox(width: 12),
                                        Text('${item.quantity ?? 1}',
                                            style: const TextStyle(fontSize: 16)),
                                        const SizedBox(width: 12),
                                        GestureDetector(
                                          onTap: () {
                                            context.read<CartBloc>().add(
                                              UpdateCartQuantityEvent(
                                                productId: item.productId!,
                                                newQuantity:
                                                (item.quantity ?? 1) + 1,
                                              ),
                                            );
                                          },
                                          child: const Icon(Icons.add, size: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                /// BOTTOM SECTION
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      /// Discount Field
                      Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xffF6F6F6),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Enter Discount Code',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text('Apply',
                                  style: TextStyle(color: Colors.orange)),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Subtotal
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal'),
                          Text('₹${total.toStringAsFixed(2)}',
                              style:
                              const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 10),

                      /// Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('₹${total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// Checkout Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to checkout page
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Checkout',
                            style: TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
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