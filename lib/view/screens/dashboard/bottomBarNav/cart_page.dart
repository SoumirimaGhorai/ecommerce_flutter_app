import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../view_model/cart/bloc/cart_bloc.dart';
import '../../../../view_model/cart/bloc/cart_event.dart';
import '../../../../view_model/cart/bloc/cart_state.dart';
import '../../../../view_model/cart/checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('My Cart')),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoadingState) {
            return const Center(child:Text('No internet connection'));
          }

          if (state is CartErrorState) {
            return Center(child: Text(state.message));
          }

          if (state is CartLoadedState) {
            final cartItems = state.cartItems;

            if (cartItems.isEmpty) {
              return const Center(child: Text('Your cart is empty'));
            }

            double total = 0;
            for (var item in cartItems) {
              total += (double.tryParse(item.price ?? '0') ?? 0) *
                  (item.quantity ?? 1);
            }

            return Column(
              children: [
                /// Cart list
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: Image.network(
                            item.image ?? '',
                            width: 60,
                            height: 60,
                            errorBuilder: (_, _, _) =>
                            const Icon(Icons.image, size: 50),
                          ),
                          title: Text(item.name ?? ''),
                          subtitle: Text(
                              'Qty: ${item.quantity} | ₹${item.price}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context.read<CartBloc>().add(
                                DeleteCartItemEvent(
                                  cartId: item.id ?? '',
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// 🔹 Total + Checkout
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '₹$total',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Proceed to checkout'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrangeAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Checkout',
                            style:
                            TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        color: Color(0xffF0E8F2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.black),
    );
  }
}