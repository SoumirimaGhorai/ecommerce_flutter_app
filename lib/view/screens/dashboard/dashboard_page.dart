import 'package:flutter/material.dart';

import 'bottomBarNav/cart_page.dart';
import 'bottomBarNav/fav_page.dart';
import 'bottomBarNav/home_page.dart';
import 'bottomBarNav/menu_page.dart';
import 'bottomBarNav/profile_page.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  int selectedIndex = 2;

  final List<Widget> mNav_pages = [
    MenuPage(),
    FavPage(),
    HomePage(),
    MyProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mNav_pages[selectedIndex],
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              isSelected: selectedIndex == 0,
              onPressed: () {
                setState(() => selectedIndex = 0);
              },
              icon: const Icon(Icons.dashboard_outlined, color: Colors.grey),
              selectedIcon: const Icon(
                Icons.dashboard_outlined,
                color: Colors.deepOrange,
              ),
            ),
            IconButton(
              isSelected: selectedIndex == 1,
              onPressed: () {
                setState(() => selectedIndex = 1);
              },
              icon: const Icon(Icons.favorite_outline, color: Colors.grey),
              selectedIcon: const Icon(
                Icons.favorite_outline,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(width: 21),

            /// 🛒 CART (FULL SCREEN – NO BOTTOM BAR)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>  CartPage(),
                  ),
                );
              },
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.grey,
              ),
            ),

            IconButton(
              isSelected: selectedIndex == 3,
              onPressed: () {
                setState(() => selectedIndex = 3);
              },
              icon: const Icon(Icons.person_outline_rounded, color: Colors.grey),
              selectedIcon: const Icon(
                Icons.person_outline_rounded,
                color: Colors.deepOrange,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => selectedIndex = 2);
        },
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        child: const Icon(Icons.home_outlined),
      ),
    );
  }
}