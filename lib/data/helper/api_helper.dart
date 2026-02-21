import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_url.dart';
import '../../core/constants/app_constant.dart';
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