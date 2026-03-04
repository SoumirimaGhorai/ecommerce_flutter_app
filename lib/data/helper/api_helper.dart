import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constant.dart';
import '../../core/constants/app_url.dart';
import 'api_exception.dart';

class ApiHelper {
  ApiHelper();

  /// =========================
  /// POST API (Login, Register, Add to Cart, etc.)
  /// =========================
  Future<dynamic> postAPI({
    required String url,
    Map<String, dynamic>? mBodyParams,
    Map<String, String>? mHeaders,
    bool isAuth = false,
  }) async {
    try {
      mHeaders ??= {};

      if (!isAuth) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token =
            prefs.getString(AppConstants.PREF_USER_TOKEN) ?? "";
        mHeaders["Authorization"] = "Bearer $token";
      }

      mHeaders["Content-Type"] = "application/json";

      final response = await http.post(
        Uri.parse(url),
        body: mBodyParams != null ? jsonEncode(mBodyParams) : null,
        headers: mHeaders,
      );

      return handleResponse(res: response);
    } on SocketException catch (e) {
      throw NoInternetException(exceptionMsg: e.toString());
    } catch (e) {
      rethrow;
    }
  }

  /// =========================
  /// GET PRODUCTS
  /// =========================
  Future<dynamic> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse(AppUrls.product_url),
        headers: {
          "Content-Type": "application/json",
        },
      );
      return handleResponse(res: response);
    } on SocketException catch (e) {
      throw NoInternetException(exceptionMsg: e.toString());
    } catch (e) {
      rethrow;
    }
  }

  /// =========================
  /// GET CATEGORIES
  Future<dynamic> getCategories() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token =
          prefs.getString(AppConstants.PREF_USER_TOKEN) ?? "";

      final response = await http.get(
        Uri.parse(AppUrls.category_url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      return handleResponse(res: response);
    } on SocketException {
      throw NoInternetException(exceptionMsg: "No internet connection");
    }
  }

  Future<dynamic> getCartList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(AppConstants.PREF_USER_TOKEN) ?? '';

    final response = await http.get(
      Uri.parse(
          AppUrls.view_cart_url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }
  /// ========================= DELETE CART ITEM =========================
  Future<dynamic> deleteCart({required int cartId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(AppConstants.PREF_USER_TOKEN) ?? '';

    final response = await http.post(
      Uri.parse(AppUrls.delete_cart_url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'cart_id': cartId}),
    );

    return handleResponse(res: response);
  }

  /// ========================= UPDATE CART QUANTITY =========================
  Future<dynamic> updateCartQuantity({
    required int productId,
    required int quantity,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(AppConstants.PREF_USER_TOKEN) ?? '';

    final response = await http.post(
      Uri.parse(AppUrls.add_to_cart_url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "product_id": productId,
        "quantity": quantity,
      }),
    );
    return handleResponse(res: response);
  }


  /// =========================
  /// GET ORDER LIST
  /// =========================
  Future<dynamic> getOrders() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token =
          prefs.getString(AppConstants.PREF_USER_TOKEN) ?? "";

      final response = await http.post(
        Uri.parse(AppUrls.get_order_url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      return handleResponse(res: response);
    } on SocketException {
      throw NoInternetException(
        exceptionMsg: "No internet connection",
      );
    } catch (e) {
      rethrow;
    }
  }
  /// HANDLE API RESPONSE
  /// =========================
  dynamic handleResponse({required http.Response res}) {
    switch (res.statusCode) {
      case 200:
        return jsonDecode(res.body);

      case 400:
        throw BadRequestException(
          exceptionMsg: "Bad Request (${res.statusCode})",
        );

      case 401:
        throw UnAuthorisedException(
          exceptionMsg: "Unauthorized (${res.statusCode})",
        );

      case 404:
        throw NoInternetException(
          exceptionMsg: "Not Found (${res.statusCode})",
        );

      case 500:
      default:
        throw ServerException(
          exceptionMsg: "Server Error (${res.statusCode})",
        );
    }
  }
}