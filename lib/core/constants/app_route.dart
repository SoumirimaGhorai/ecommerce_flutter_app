

import 'package:e_commarce_project/view/screens/navigation_drawer/order_history_page.dart';
import 'package:flutter/material.dart';
import '../../view/screens/dashboard/dashboard_page.dart';
import '../../view/screens/login_page.dart';
import '../../view/screens/sign_up_page.dart';
import '../../view/screens/splash_page.dart';
import '../../view/screens/product/all_product_page.dart';
import '../../view/screens/product/product_detail_page.dart';

class AppRoutes{
  static final String route_splash = "/";
  static final String route_login = "/login";
  static final String route_sign_up = "/sign_up";
  static final String route_dashboard = "/dashboard";
  static final String route_detail_page = "/detail_page";
  static final String route_product_page="/all_product_page";
  static final String route_order_history_page='/order_history_page';



  static Map<String, WidgetBuilder> mRoutes = {
    route_splash: (context) => SplashPage(),
    route_login: (context) => LoginPage(),
    route_sign_up: (context) => SignUpPage(),
    route_dashboard: (context) => DashBoardPage(),
    route_detail_page: (context) => ProductDetailPage(),
    route_product_page:(context)=>AllProductPage(),
    route_order_history_page:(context)=>OrderHistoryPage(),





  };

}
