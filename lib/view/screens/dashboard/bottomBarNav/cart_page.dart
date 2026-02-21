import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/model/cart_item_model.dart';
import '../../../../view_model/cart/cart_bloc.dart';
import '../../../../view_model/cart/cart_event.dart';
import '../../../../view_model/cart/cart_state.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(FetchCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartFailureState) {
            return Center(child: Text(state.errorMsg));
          }

          if (state is CartLoadedState) {
            if (state.cartItems.isEmpty) {
              return const Center(child: Text("Cart is empty"));
            }

            int totalPrice = state.cartItems.fold(
                0,
                    (sum, item) =>
                sum + (int.parse(item.price!) * item.quantity!));

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) {
                      final CartItemModel item = state.cartItems[index];

                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: Image.network(
                            item.image ?? "",
                            width: 60,
                            errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image),
                          ),
                          title: Text(item.name ?? ""),
                          subtitle: Row(
                            children: [
                              IconButton(
                                onPressed: item.quantity! > 1
                                    ? () {
                                  context.read<CartBloc>().add(
                                    UpdateCartQuantityEvent(
                                      productId: item.productId!
                                      newQuantity: item.quantity! - 1,
                                    ),
                                  );
                                }
                                    : null,
                                icon: const Icon(Icons.remove),
                              ),
                              Text("${item.quantity}"),
                              IconButton(
                                onPressed: () {
                                  context.read<CartBloc>().add(
                                    UpdateCartQuantityEvent(
                                      productId: item.productId ?? 0,      // default to 0 if null
                                      newQuantity: (item.quantity ?? 1) + 1, // default to 1 if null
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "₹${int.parse(item.price!) * item.quantity!}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: () {
                                  context.read<CartBloc>().add(
                                    DeleteCartItemEvent(cartId: item.id!),
                                  );
                                },
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey.shade200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "₹$totalPrice",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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