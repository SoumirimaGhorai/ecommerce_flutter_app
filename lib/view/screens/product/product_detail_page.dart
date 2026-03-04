import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/product_model.dart';
import '../../../view_model_bloc/cart/cart_bloc.dart';
import '../../../view_model_bloc/cart/cart_event.dart';


class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  ProductModel? currProduct;
  int qty = 1;
  bool isLoading = false;
  int currentTab = 0;
  int currentDot = 0;
  Color? selectedColor;
  bool isAddedToCart = false;

  @override
  Widget build(BuildContext context) {
    currProduct = ModalRoute.of(context)!.settings.arguments as ProductModel?;
    selectedColor ??= Colors.brown; // default selected color

    return Scaffold(
      backgroundColor: const Color(0xffF0E8F2),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                /// IMAGE SECTION
                Expanded(
                  flex: 3,
                  child: Container(
                    color: const Color(0xffF0E8F2),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                currProduct?.image ?? '',
                                width: 200,
                                height: 200,
                                errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image, size: 100),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(3, (index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    width: currentDot == index ? 18 : 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: currentDot == index
                                          ? Colors.deepOrangeAccent
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),

                        /// TOP ICONS
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 21, right: 21),
                          child: Row(
                            children: [
                              _circleIcon(
                                  icon: Icons.arrow_back_ios,
                                  onTap: () => Navigator.pop(context)),
                              const Spacer(),
                              _circleIcon(icon: Icons.share_outlined),
                              const SizedBox(width: 21),
                              _circleIcon(icon: Icons.favorite_border),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// DETAILS SECTION
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.all(21),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(21)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currProduct?.name ?? '',
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "₹${currProduct?.price ?? 0}",
                                    style: const TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: const [
                                      Icon(Icons.star,
                                          size: 14,
                                          color: Colors.deepOrangeAccent),
                                      SizedBox(width: 4),
                                      Text("4.8 (320 reviews)",
                                          style: TextStyle(color: Colors.grey)),
                                    ],
                                  ),
                                ],
                              ),
                              const Text("Seller: Tariqul Islam"),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Color",
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 11),

                          /// COLORS
                          SizedBox(
                            height: 44,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _ColorDot(
                                  color: Colors.orange,
                                  selected: selectedColor == Colors.orange,
                                  onTap: () {
                                    setState(() => selectedColor = Colors.orange);
                                  },
                                ),
                                _ColorDot(
                                  color: Colors.brown,
                                  selected: selectedColor == Colors.brown,
                                  onTap: () {
                                    setState(() => selectedColor = Colors.brown);
                                  },
                                ),
                                _ColorDot(
                                  color: Colors.black,
                                  selected: selectedColor == Colors.black,
                                  onTap: () {
                                    setState(() => selectedColor = Colors.black);
                                  },
                                ),
                                _ColorDot(
                                  color: Colors.amber,
                                  selected: selectedColor == Colors.amber,
                                  onTap: () {
                                    setState(() => selectedColor = Colors.amber);
                                  },
                                ),
                                _ColorDot(
                                  color: Colors.red,
                                  selected: selectedColor == Colors.red,
                                  onTap: () {
                                    setState(() => selectedColor = Colors.red);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          /// ---------------- TABS ----------------
                          Row(
                            children: [
                              _tabButton("Description", 0),
                              _tabButton("Specification", 1),
                              _tabButton("Reviews", 2),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _tabContent(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// BOTTOM BAR
            Positioned(
              bottom: 0,
              child: Container(
                height: 88,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.symmetric(horizontal: 21),
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(55),
                  color: Colors.black,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Quantity Selector
                    StatefulBuilder(
                      builder: (context, ss) {
                        return Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (qty > 1) {
                                  qty--;
                                  ss(() {});
                                }
                              },
                              icon: const Icon(Icons.remove, color: Colors.white),
                            ),
                            Text(
                              "$qty",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            IconButton(
                              onPressed: () {
                                qty++;
                                ss(() {});
                              },
                              icon: const Icon(Icons.add, color: Colors.white),
                            ),
                          ],
                        );
                      },
                    ),

                    /// Add to Cart Button
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : InkWell(
                      onTap:   isAddedToCart
                          ? null
                          : () {
                        context.read<CartBloc>().add(
                          AddToCartEvent(
                            productId: int.parse(currProduct!.id ?? '0'),
                            qty: qty,
                          ),
                        );
                        setState(() {
                          isAddedToCart = true;
                        });

                        _showSnackBar(context, "Item added to  successfully");
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 41, vertical: 14),
                        decoration: BoxDecoration(
                          color: isAddedToCart
                              ? Colors.brown
                              : Colors.deepOrangeAccent,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          isAddedToCart ? "Added" : "Add to cart",
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// TAB BUTTON
  Widget _tabButton(String title, int index) {
    final bool selected = currentTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => currentTab = index),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.deepOrangeAccent : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  color: selected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  /// TAB CONTENT
  Widget _tabContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80),
      child: _buildTabBody(),
    );
  }

  Widget _buildTabBody() {
    if (currentTab == 0) {
      return const Text(
        "This android smartphone delivers powerful performance with a sleek design. "
            "It features a 6.6-inch FHD+ AMOLED display, 8GB RAM, and a 5000mAh battery "
            "with fast charging. Ideal for gaming, streaming, and daily use.\n\n"
            "The 64MP triple camera setup captures stunning photos, while 5G connectivity "
            "ensures ultra-fast internet speeds.",
        style: TextStyle(fontSize: 16, height: 1.3),
      );
    }
    if (currentTab == 1) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• Display: 6.6-inch FHD+ AMOLED"),
          SizedBox(height: 6),
          Text("• Processor: Octa-core 2.4 GHz"),
          SizedBox(height: 6),
          Text("• RAM: 8 GB"),
          SizedBox(height: 6),
          Text("• Storage: 128 GB (Expandable)"),
          SizedBox(height: 6),
          Text("• Rear Camera: 64 MP + 8 MP + 2 MP"),
          SizedBox(height: 6),
          Text("• Front Camera: 16 MP"),
          SizedBox(height: 6),
          Text("• Battery: 5000 mAh"),
          SizedBox(height: 6),
          Text("• Warranty: 1 Year"),
        ],
      );
    }
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("⭐ 4.8 / 5",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text("• Excellent display quality and smooth performance"),
        Text("• Battery easily lasts a full day"),
        Text("• Camera quality is impressive for the price"),
        Text("• Fast charging is very useful"),
        Text("• Good value for money"),
        SizedBox(height: 10),
        Text("User Review:", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(
          "\"I am very happy with this phone. The display and performance are "
              "excellent, and the battery backup is amazing. Definitely worth buying.\"",
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }

  Widget _circleIcon({required IconData icon, VoidCallback? onTap}) {
    return Container(
      width: 50,
      height: 50,
      decoration:
      const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: IconButton(
        icon: Icon(icon, color: Colors.black),
        onPressed: onTap,
      ),
    );
  }
}

/// COLOR DOT
class _ColorDot extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback? onTap;

  const _ColorDot({required this.color, this.selected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: selected ? Border.all(color: color, width: 3) : null,
        ),
        child: Center(
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}

void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}




