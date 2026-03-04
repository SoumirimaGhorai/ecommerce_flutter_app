import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/helper/api_helper.dart';
import '../../data/model/cart_item_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ApiHelper apiHelper;

  CartBloc({required this.apiHelper}) : super(CartLoadingState()) {
    on<FetchCartEvent>(_fetchCart);
    on<AddToCartEvent>(_addToCart);
    on<DeleteCartItemEvent>(_deleteCartItem);
    on<UpdateCartQuantityEvent>(_updateQuantity);
    on<LoadLocalCartEvent>(_loadLocalCart);
  }

  /// ---------------- Load saved cart from SharedPreferences ----------------
  Future<void> _loadLocalCart(
      LoadLocalCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('cart_items') ?? '[]';
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final items = jsonList.map((e) => CartItemModel.fromJson(e)).toList();
      emit(CartLoadedState(cartItems: items));
    } catch (e) {
      emit(CartErrorState(message: 'Failed to load cart'));
    }
  }

  /// ---------------- Fetch cart from API ----------------
  Future<void> _fetchCart(FetchCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      final res = await apiHelper.getCartList();
      final List data = res['data'] ?? [];
      final items = data.map((e) => CartItemModel.fromJson(e)).toList();
      emit(CartLoadedState(cartItems: items));
      await _saveCartLocally(items);
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }

  /// ---------------- Add to cart ----------------
  Future<void> _addToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      await apiHelper.updateCartQuantity(
        productId: event.productId,
        quantity: event.qty,
      );
      add(FetchCartEvent());
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }

  /// ---------------- Delete item ----------------
  Future<void> _deleteCartItem(
      DeleteCartItemEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      await apiHelper.deleteCart(cartId: int.parse(event.cartId));
      add(FetchCartEvent());
    } catch (e) {
      emit(CartErrorState(message: "Delete failed"));
    }
  }

  /// ---------------- Update quantity ----------------
  Future<void> _updateQuantity(
      UpdateCartQuantityEvent event, Emitter<CartState> emit) async {
    if (state is CartLoadedState) {
      final currentItems =
      List<CartItemModel>.from((state as CartLoadedState).cartItems);

      final index =
      currentItems.indexWhere((item) => item.productId == event.productId);
      if (index != -1) {
        currentItems[index].quantity = event.newQuantity;
        emit(CartLoadedState(cartItems: currentItems));
        await _saveCartLocally(currentItems);
        // Optional: Update API
        await apiHelper.updateCartQuantity(
            productId: int.parse(event.productId),
            quantity: event.newQuantity);
      }
    }
  }

  /// ---------------- Save cart to local storage ----------------
  Future<void> _saveCartLocally(List<CartItemModel> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString('cart_items', jsonString);
  }
}