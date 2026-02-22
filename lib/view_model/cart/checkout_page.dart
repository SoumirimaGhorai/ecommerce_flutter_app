import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/cart_bloc.dart';
import 'bloc/cart_state.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is! CartLoadedState) {
            return const Center(child: CircularProgressIndicator());
          }

          double total = 0;
          for (var item in state.cartItems) {
            total += (double.tryParse(item.price ?? '0') ?? 0) *
                (item.quantity ?? 1);
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: state.cartItems.map((item) {
                    return ListTile(
                      title: Text(item.name ?? ''),
                      trailing: Text(
                        '₹${item.price} x ${item.quantity}',
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                      // MaterialPageRoute(
                      //   builder: (_) => PaymentPage(total: total),
                      // ),
                    //);
                  },
                  child: Text('Place Order ₹$total'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}