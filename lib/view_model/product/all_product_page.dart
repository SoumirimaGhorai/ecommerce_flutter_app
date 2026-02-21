import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_model/product/bloc/product_bloc.dart';
import '../../view_model/product/bloc/product_state.dart';
import '../../core/constants/app_route.dart';

class AllProductPage extends StatelessWidget {
  const AllProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Products"),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductErrorState) {
            return Center(child: Text(state.errorMsg));
          }

          if (state is ProductLoadedState) {
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 11 / 12,
              ),
              itemBuilder: (context, index) {
                final product = state.products[index];

                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.route_detail_page,
                      arguments: product,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffF0E8F2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          product.image ?? "",
                          height: 100,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.name ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "₹ ${product.price}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}