import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/helper/api_helper.dart';
import '../../../data/model/cart_item_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ApiHelper apiHelper;

  CartBloc({required this.apiHelper}) : super(CartLoadingState()) {
    on<FetchCartEvent>(_fetchCart);
    on<AddToCartEvent>(_addToCart);
    on<DeleteCartItemEvent>(_deleteCartItem);
  }

  Future<void> _fetchCart(
      FetchCartEvent event, Emitter<CartState> emit) async {
    try {
      emit(CartLoadingState());

      final res = await apiHelper.getCartList();
      final List data = res['data'] ?? [];

      final items =
      data.map((e) => CartItemModel.fromJson(e)).toList();

      emit(CartLoadedState(cartItems: items));
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }

  Future<void> _addToCart(
      AddToCartEvent event, Emitter<CartState> emit) async {
    try {
      emit(CartLoadingState());

      await apiHelper.updateCartQuantity(
        productId: event.productId,
        quantity: event.qty,
      );

      add(FetchCartEvent()); // refresh cart
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }

  Future<void> _deleteCartItem(
      DeleteCartItemEvent event, Emitter<CartState> emit) async {
    try {
      emit(CartLoadingState());

      await apiHelper.deleteCart(
        cartId: int.parse(event.cartId),
      );

      add(FetchCartEvent()); // refresh cart
    } catch (e) {
      emit(CartErrorState(message: "Delete failed"));
    }
  }
}