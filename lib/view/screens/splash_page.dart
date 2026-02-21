
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_route.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () async{
      String nextPageName = AppRoutes.route_login;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("user_token") ?? "";

      if(token.isNotEmpty){
        nextPageName = AppRoutes.route_dashboard;
      }

      Navigator.pushReplacementNamed(context, nextPageName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 200),
            SizedBox(height: 11),
            Text(
              'Shopper\'s Stop',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
