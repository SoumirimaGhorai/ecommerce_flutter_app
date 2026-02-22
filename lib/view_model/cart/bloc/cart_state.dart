import '../../../data/model/cart_item_model.dart';

abstract class CartState {}

class CartInitialState extends CartState {}

class CartLoadingState extends CartState {}

class CartLoadedState extends CartState {
  final List<CartItemModel> cartItems;

  CartLoadedState({required this.cartItems});
}

class CartErrorState extends CartState {
  final String message;

  CartErrorState({required this.message});
}