// cart_state.dart
import '../../data/model/cart_item_model.dart';

abstract class CartState {}

class CartInitialState extends CartState {}
class CartLoadingState extends CartState {}
class CartLoadedState extends CartState {
  final List<CartItemModel> cartItems;
  CartLoadedState({required this.cartItems});
}
class CartFailureState extends CartState {
  final String errorMsg;
  CartFailureState({required this.errorMsg});
}