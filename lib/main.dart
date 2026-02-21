import 'package:e_commarce_project/view_model/cart/cart_bloc.dart';
import 'package:e_commarce_project/view_model/category/category_bloc.dart';
import 'package:e_commarce_project/view_model/product/bloc/product_bloc.dart';
import 'package:e_commarce_project/view_model/user/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_route.dart';
import 'data/helper/api_helper.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserBloc(apiHelper: ApiHelper())),
        BlocProvider(create: (context) => ProductBloc(apiHelper: ApiHelper())),
        BlocProvider(create: (context) => CartBloc(apiHelper: ApiHelper())),
        BlocProvider(create: (context) => CategoryBloc(apiHelper: ApiHelper())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: AppRoutes.route_splash,
      routes: AppRoutes.mRoutes,
    );
  }
}